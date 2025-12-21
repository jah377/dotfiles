-- `gl` to open diagnostic at point
-- `grn` to rename object at point
-- `gra` to go to code actions
-- `grr` to go to reference
-- `gri` to go to implementation
-- `grd` to go to definition
-- `grD` to go to declaration
-- `gO`  to see document symbols
-- `gW`  to open workspace symbols
-- `grt` to go to type definition
-- `CTRL-T` to return to point

local function hello(object)
  print("Hello " .. object)
end

hello("world")

hello("amsterdam")
