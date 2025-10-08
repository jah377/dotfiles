local A = { setting1 = "setting1", setting2 = "setting2" }
local B = { setting3 = "setting3", setting4 = "setting4" }

local C = vim.tbl_extend("force", A, B)

print(vim.inspect(C))
