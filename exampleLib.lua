--[[
	Example library that uses the Library Template
--]]

-- Load the library template base class
local LibraryTemplate = require("libraryTemplate")

-- Create a class for our own library by extending the template class
local ExampleLib = LibraryTemplate.inherit()

-- Define "static" fields that all instances will be able to access:

-- Version of the library
ExampleLib.version = "1.0.0"
-- Name of the library for log messages, etc.
ExampleLib.name = "Example Library"
-- Name of the library's internal table, by which it can be found in the global table
ExampleLib.internalTableName = "exampleLib_internal"
-- Minimum version of the mod loader the library requires to work
ExampleLib.modApiVersion = "2.3.0"
-- The root directory where the implementing library's source files are located.
-- The triple dots capture the arguments passed to the function that loaded
-- this file. In other words, the path passed to the require() function.
ExampleLib.rootDirectory = GetParentPath(...)


-- Override public API functions:

--[[
	Constructor called when creating an instance of this library via ExampleLib().
	Most of our use cases are covered by the standard init(), but it might still be
	useful if you ever need to do some stuff before init() is called.
--]]
function ExampleLib:new()
	LibraryTemplate.new(self) -- mandatory callback to parent constructor
end

function ExampleLib:init(mod)
	-- We override the init() function, so we must invoke the parent init() as well
	LibraryTemplate.init(self, mod)

	-- To load some other modules in our library's directory, use the rootDirectory field
	self.someModule = require(self.rootDirectory .. "someModule")

	return self
end

--[[
	Called when the library's internal table is being initialized for the first time,
	or being overridden by a more recent version.
	Perform initialization of this table here.
--]]
function ExampleLib:initInternal()
	exampleLib_internal.someProperty = 5
end

function ExampleLib:load(mod, options, version)
	-- We override the load() function, so we must invoke the parent load() as well
	LibraryTemplate.load(self, mod, options, version)

	modApi:addSomeHook(function() LOG("Some hook that is safe to add for all library versions") end)

	return self
end

--[[
	Variant of load() that is executed only for the most recent version of this library.
--]]
function ExampleLib:mostRecentExclusiveLoad(mod, options, version)
	modApi:addSomeOtherHook(function() LOG("Some other hook that should only be added for the most recent version") end)
end

-- Return a reference to our library's class, so that mods can create instances that they will use.
return ExampleLib
