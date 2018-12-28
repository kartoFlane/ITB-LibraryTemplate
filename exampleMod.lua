--[[
	Example mod that uses the Example Library
--]]

-- Load the ExampleLib source file, and save reference to the class in a local var
local ExampleLib = require("exampleLib")
-- Create an instance of the library by invoking the ExampleLib class' constructor
-- Whether you use a local var or global is up to you
local exampleLib = ExampleLib()

-- Alternatively use the more compact, but slightly less readable notation:
-- local exampleLib = require("exampleLib")()

-- Follow up with standard init and load

local function init(mod)
	exampleLib:init(mod)
end

local function load(mod, options, version)
	exampleLib:load(mod, options, version)
end

return {
	id = "exampleMod",
	name = "Example Mod",
	version = "1.0.0",
	requirements = {},
	init = init,
	load = load
}
