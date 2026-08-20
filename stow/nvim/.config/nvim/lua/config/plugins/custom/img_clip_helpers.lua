-- =============================================================================
-- FILE: lua/config/plugins/custom/img_clip_helpers.lua
--
-- PURPOSE:
--   Shared helpers for vault note images. Used by notes/img-clip.lua (paste/naming)
--   and notes/image.lua (vault-root path resolution for inline preview).
--
-- NAMING POLICY:
--   Prompted names become `{YYYYMMDD}-{lower_snake_case}` under
--   `$ZK_DIR/assets/`. Links in notes are vault-root: `![](assets/<file>)`.
--
-- =============================================================================

-- Directory name under $ZK_DIR for stored images; also the link prefix in notes.
-- Exported so img-clip.lua can build templates / dir_path fallbacks from one source.
local ASSETS_DIRNAME = "assets"

-- os.date format for the basename timestamp prefix (trailing "-" separates name).
local BASENAME_DATE_FORMAT = "%Y%m%d-"

-- Prompt shown by vim.fn.input before normalizing and writing an asset.
local INPUT_PROMPT = "Image name: "

local M = {
  ASSETS_DIRNAME = ASSETS_DIRNAME,
}

---@return string|nil expanded ZK_DIR
local function zk_dir()
  local zk = vim.env.ZK_DIR
  if not zk or zk == "" then return nil end
  return vim.fn.expand(zk)
end

--- Absolute path to `$ZK_DIR/<ASSETS_DIRNAME>`, or nil when ZK_DIR is unset.
---@return string|nil
function M.assets_dir()
  local zk = zk_dir()
  if not zk then return nil end
  return vim.fs.joinpath(zk, ASSETS_DIRNAME)
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
--- Aborts with notify when ZK_DIR is missing, input empty/invalid, or a file
--- with that basename already exists under the assets directory.
---@return string|nil basename without extension
function M.prompt_asset_basename()
  local assets = M.assets_dir()
  if not assets then
    vim.notify("ZK_DIR is not set", vim.log.levels.ERROR)
    return nil
  end

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

--- image.nvim hook: map vault-root `assets/…` links to `$ZK_DIR/assets/…`
--- when document_path is under the vault (string prefix check). Else fallback.
---@param document_path string
---@param image_path string
---@param fallback fun(string, string): string
---@return string
function M.resolve_image_path(document_path, image_path, fallback)
  local zk = zk_dir()
  if not zk then return fallback(document_path, image_path) end

  local zk_prefix = zk:sub(-1) == "/" and zk or (zk .. "/")
  local under_vault = document_path:sub(1, #zk_prefix) == zk_prefix or document_path == zk
  if not under_vault or not image_path:match("^" .. ASSETS_DIRNAME .. "/") then
    return fallback(document_path, image_path)
  end

  local candidate = vim.fs.joinpath(zk, image_path)
  if vim.fn.filereadable(candidate) == 1 then return candidate end
  return fallback(document_path, image_path)
end

return M
