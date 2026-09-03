-- =============================================================================
-- FILE: lua/config/plugins/custom/img_clip_helpers.lua
--
-- PURPOSE:
--   Shared helpers for note image paste. Used by notes/img-clip.lua
--   (paste/naming). image.nvim previews via standard note-relative links (no
--   custom resolve hook).
--
-- POLICY:
--   Images land in `<git-root>/assets/` for the current buffer
--   (`vim.fs.root(path, ".git")`). Links in notes are paths relative to the note
--   file that resolve to that asset. Naming: `{YYYYMMDD}-{lower_snake_case}`.
--
-- =============================================================================

-- Directory name under the git root for stored images.
local ASSETS_DIRNAME = "assets"

-- os.date format for the basename timestamp prefix (trailing "-" separates name).
local BASENAME_DATE_FORMAT = "%Y%m%d-"

-- Prompt shown by vim.fn.input before normalizing and writing an asset.
local INPUT_PROMPT = "Image name: "

-- Markdown image links always use `/` (portable; `\` is an escape in Markdown).
local MD_PATH_SEP = "/"

local M = {}

---@param err "unsaved"|"no_git"|string|nil
---@return string
function M.destination_error_message(err)
  if err == "unsaved" then
    return "Save the file before pasting an image"
  elseif err == "no_git" then
    return "No git root found for this buffer"
  end
  return "Cannot determine image assets directory"
end

---@param err "unsaved"|"no_git"|string|nil
function M.notify_destination_error(err)
  vim.notify(M.destination_error_message(err), vim.log.levels.ERROR)
end

---@return string|nil path, string|nil err "unsaved"|"no_git"
local function buffer_path()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then return nil, "unsaved" end
  return path, nil
end

--- Git root of the current buffer, or nil with an error tag.
---@return string|nil root, string|nil err
function M.git_root()
  local path, err = buffer_path()
  if not path then return nil, err end

  local root = vim.fs.root(path, ".git")
  if not root then return nil, "no_git" end
  return root, nil
end

--- Absolute path to `<git-root>/<ASSETS_DIRNAME>`, or nil with an error tag.
---@return string|nil assets, string|nil err
function M.assets_dir()
  local root, err = M.git_root()
  if not root then return nil, err end
  return vim.fs.joinpath(root, ASSETS_DIRNAME), nil
end

--- Absolute assets dir, or nil after notifying why destination is unavailable.
---@return string|nil
function M.assets_dir_or_notify()
  local assets, err = M.assets_dir()
  if not assets then
    M.notify_destination_error(err)
    return nil
  end
  return assets
end

--- Path of `target` relative to directory `start` (with `..` as needed).
--- Always uses `/` so the result is safe in Markdown image links.
---@param target string
---@param start string
---@return string
function M.path_relative_to(target, start)
  target = vim.fs.normalize(vim.fn.fnamemodify(target, ":p"))
  start = vim.fs.normalize(vim.fn.fnamemodify(start, ":p"))

  local function split(path)
    local parts = {}
    for part in path:gmatch "[^/\\]+" do
      parts[#parts + 1] = part
    end
    return parts
  end

  local target_parts = split(target)
  local start_parts = split(start)

  local common = 0
  for i = 1, math.min(#target_parts, #start_parts) do
    if target_parts[i] == start_parts[i] then
      common = i
    else
      break
    end
  end

  local result = {}
  for _ = common + 1, #start_parts do
    result[#result + 1] = ".."
  end
  for i = common + 1, #target_parts do
    result[#result + 1] = target_parts[i]
  end

  if #result == 0 then return "." end
  return table.concat(result, MD_PATH_SEP)
end

--- Directory of the buffer that initiated the current paste (set by img-clip.lua).
--- Falls back to the current buffer when unset (sync paste keeps them equal).
M._paste_note_dir = nil

--- img-clip template: markdown image with a path relative to the note.
---@param context { file_path: string }|nil
---@return string|nil
function M.markdown_image_template(context)
  if type(context) ~= "table" or type(context.file_path) ~= "string" or context.file_path == "" then
    vim.notify("img-clip template missing file_path", vim.log.levels.ERROR)
    return nil
  end

  local note_dir = M._paste_note_dir or vim.fn.expand "%:p:h"
  local abs = context.file_path
  if abs:sub(1, 1) ~= "/" and not abs:match "^[A-Za-z]:[\\/]" then abs = vim.fs.joinpath(note_dir, abs) end
  local rel = M.path_relative_to(abs, note_dir)
  return "![](" .. rel .. ")"
end

--- Turn a human prompt into a filesystem-safe lower_snake_case slug.
---@param name string
---@return string
local function to_lower_snake_case(name)
  local s = name:lower()
  s = s:gsub("[^%w]+", "_")
  s = s:gsub("_+", "_")
  return s:gsub("^_", ""):gsub("_$", "")
end

--- Prompt for a name, then return `{YYYYMMDD}-{snake}` (no extension).
--- Aborts with notify when destination is unavailable, input empty/invalid, or a
--- file with that basename already exists under the target assets directory.
---@return string|nil basename without extension
function M.prompt_asset_basename()
  local assets = M.assets_dir_or_notify()
  if not assets then return nil end

  local input = vim.fn.input { prompt = INPUT_PROMPT }
  if input == "" then return nil end

  local snake = to_lower_snake_case(input)
  if snake == "" then
    vim.notify("Image name is empty after normalizing to lower_snake_case", vim.log.levels.WARN)
    return nil
  end

  local basename = os.date(BASENAME_DATE_FORMAT) .. snake
  local existing = vim.fn.glob(vim.fs.joinpath(assets, basename) .. ".*", false, true)
  if #existing > 0 then
    vim.notify("Asset already exists: " .. existing[1], vim.log.levels.ERROR)
    return nil
  end

  return basename
end

return M
