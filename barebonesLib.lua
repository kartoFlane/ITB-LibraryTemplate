--[[
	Barebones library file, ready to copy & paste and appropriate for your library needs.
--]]

local LibraryTemplate = require("libraryTemplate")

local BarebonesLib = LibraryTemplate.inherit()
BarebonesLib.version = ""
BarebonesLib.name = ""
BarebonesLib.internalTableName = ""
BarebonesLib.modApiVersion = "2.3.0"
BarebonesLib.rootDirectory = GetParentPath(...)


function BarebonesLib:new()
	LibraryTemplate.new(self)
end

function BarebonesLib:init(mod)
	LibraryTemplate.init(self, mod)

	return self
end

function BarebonesLib:initInternal()
end

function BarebonesLib:load(mod, options, version)
	LibraryTemplate.load(self, mod, options, version)

	return self
end

function BarebonesLib:mostRecentExclusiveLoad(mod, options, version)
end

return BarebonesLib
