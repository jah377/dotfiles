-- =============================================================================
-- FILE: lua/config/lib/img_clip_helpers.lua
-- MODULE: require("config.lib.img_clip_helpers")
-- Helpers for pasting images into notes (plugins/notes/img-clip.lua).
--
-- POLICY:
-- Images are stored in `<git-root>/assets/` for the current buffer
-- (`vim.fs.root(path, ".git")`). Links written into notes are relative to the
-- note file. File names are `{YYYYMMDD}-{lower_snake_case}`.
--
-- ERRORS:
-- Expected failures (unsaved buffer, no git root) return `nil, tag`, where tag
-- is a key of DESTINATION_ERRORS; callers decide whether to notify. The module
-- holds no state between calls.
-- =============================================================================

local img_clip_helpers = {}

-- Directory name under the git root for stored images
local ASSETS_DIRNAME = "assets"

-- os.date format for the basename timestamp prefix (trailing "-" separates the name)
local BASENAME_DATE_FORMAT = "%Y%m%d-"

-- Prompt shown by vim.fn.input before normalising and writing an asset
local INPUT_PROMPT = "Image name: "

-- Markdown image links always use `/` (portable; `\` is an escape in Markdown)
local MD_PATH_SEP = "/"

-- Error tag -> message. A lookup table replaces the earlier if/elseif chain,
-- so adding a tag is a one-line change.
local DESTINATION_ERRORS = {
    unsaved = "Save the file before pasting an image",
    no_git = "No git root found for this buffer",
}
local DESTINATION_ERROR_FALLBACK = "Cannot determine image assets directory"

--- @param err string|nil error tag from assets_dir()/git_root()
--- @return string human-readable message
function img_clip_helpers.destination_error_message(err) return DESTINATION_ERRORS[err] or DESTINATION_ERROR_FALLBACK end

--- @param err string|nil error tag
function img_clip_helpers.notify_destination_error(err) vim.notify(img_clip_helpers.destination_error_message(err), vim.log.levels.ERROR) end

--- @return string|nil path absolute path of the current buffer
--- @return string|nil err "unsaved" when the buffer has no file
local function buffer_path()
    local path = vim.api.nvim_buf_get_name(0)
    if path == "" then return nil, "unsaved" end
    return path
end

--- Git root of the current buffer.
--- @return string|nil root
--- @return string|nil err "unsaved" | "no_git"
function img_clip_helpers.git_root()
    local path, err = buffer_path()
    if not path then return nil, err end

    local root = vim.fs.root(path, ".git")
    if not root then return nil, "no_git" end
    return root
end

--- Absolute path to `<git-root>/assets`.
--- @return string|nil assets
--- @return string|nil err "unsaved" | "no_git"
function img_clip_helpers.assets_dir()
    local root, err = img_clip_helpers.git_root()
    if not root then return nil, err end
    return vim.fs.joinpath(root, ASSETS_DIRNAME)
end

--- Absolute assets dir, or nil after notifying why it is unavailable.
--- @return string|nil
function img_clip_helpers.assets_dir_or_notify()
    local assets, err = img_clip_helpers.assets_dir()
    if not assets then
        img_clip_helpers.notify_destination_error(err)
        return nil
    end
    return assets
end

--- Split a path on either separator. Hoisted out of path_relative_to so it is
--- not re-created on every call.
--- @param path string
--- @return string[]
local function split_path(path)
    local parts = {}
    for part in path:gmatch("[^/\\]+") do
        parts[#parts + 1] = part
    end
    return parts
end

--- Path of `target` relative to directory `start`, with `..` segments as
--- needed. Always joins with `/` so the result is safe in Markdown links.
--- vim.fs.relpath() is not used because it returns nil when target is not
--- inside start, and assets usually sit beside the note, not under it.
--- @param target string
--- @param start string
--- @return string
function img_clip_helpers.path_relative_to(target, start)
    local target_parts = split_path(vim.fs.normalize(vim.fn.fnamemodify(target, ":p")))
    local start_parts = split_path(vim.fs.normalize(vim.fn.fnamemodify(start, ":p")))

    local common = 0
    for i = 1, math.min(#target_parts, #start_parts) do
        if target_parts[i] ~= start_parts[i] then break end
        common = i
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

--- Markdown image link for an img-clip paste, relative to the note. note_dir
--- is passed explicitly (img-clip.lua binds it in a closure per paste) instead
--- of being stashed in a module field, so the template cannot read stale state
--- if focus changes while an image downloads.
--- @param context { file_path: string }|nil img-clip template context
--- @param note_dir string directory of the note being edited
--- @return string|nil
function img_clip_helpers.markdown_image_template(context, note_dir)
    assert(type(note_dir) == "string", "note_dir must be a directory path")
    if type(context) ~= "table" or type(context.file_path) ~= "string" or context.file_path == "" then
        vim.notify("img-clip template missing file_path", vim.log.levels.ERROR)
        return nil
    end

    local absolute = context.file_path
    local is_absolute = absolute:sub(1, 1) == "/" or absolute:match("^[A-Za-z]:[\\/]")
    if not is_absolute then absolute = vim.fs.joinpath(note_dir, absolute) end
    local relative = img_clip_helpers.path_relative_to(absolute, note_dir)
    return "![](" .. relative .. ")"
end

--- Turn a human prompt into a filesystem-safe lower_snake_case slug. gsub
--- returns (string, count); the parentheses on the last call drop the count so
--- this function returns exactly one value.
--- @param name string
--- @return string
local function to_lower_snake_case(name)
    local slug = name:lower()
    slug = slug:gsub("[^%w]+", "_")
    slug = slug:gsub("_+", "_")
    slug = slug:gsub("^_", "")
    return (slug:gsub("_$", ""))
end

--- Prompt for a name and return `{YYYYMMDD}-{snake}` without extension.
--- Returns nil, after notifying, when the destination is unavailable, the
--- input is empty, or an asset with that basename already exists.
--- @return string|nil basename
function img_clip_helpers.prompt_asset_basename()
    local assets = img_clip_helpers.assets_dir_or_notify()
    if not assets then return nil end

    local input = vim.fn.input({ prompt = INPUT_PROMPT })
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

return img_clip_helpers
