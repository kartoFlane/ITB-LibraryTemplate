local LibraryTemplate = Class.new()
-- Version of the library template
LibraryTemplate.TEMPLATE_VERSION = "1.0.0"
-- Default minimum version of the mod loader. Change this in your library, not here.
LibraryTemplate.modApiVersion = "2.3.0"

--[[
	Constructor function, called when creating a new instance of the library.

	When overriding, call LibraryTemplate.new(self) on the first line.
--]]
function LibraryTemplate:new()
	assert(
		type(self.name) == "string",
		"Library has no `name` field defined!"
	)
	assert(
		type(self.internalTableName) == "string",
		string.format("Library '%s' has no `internalTableName` field defined!", self.name)
	)
	assert(
		type(self.version) == "string",
		string.format("Library '%s' has no `version` field defined!", self.name)
	)
end

--[[
	The initialization method of the library.

	When overriding, call LibraryTemplate.init(self, mod) on the first line.
--]]
function LibraryTemplate:init(mod)
	self:checkModLoaderVersion()
	self:setupInternal()

	return self
end

--[[
	Internal function to check for minimum mod loader version the library requires to work.
	Don't override.
--]]
function LibraryTemplate:checkModLoaderVersion()
	if not modApi:isVersion(self.modApiVersion) then
		error(string.format(
			"Library '%s' could not be loaded, because the mod loader is out of date. Installed version: %s, required: %s",
			self.name, modApi.version, self.modApiVersion
		))
	end
end

--[[
	Internal function to setup the library's internal table.
	Don't override. Perform your internal initialization in initInternal().
--]]
function LibraryTemplate:setupInternal()
	local internalTable = _G[self.internalTableName]
	if not internalTable then
		_G[self.internalTableName] = {}
		internalTable = _G[self.internalTableName]
	end

	-- Either initialize (if no mostRecent was previously defined),
	-- or overwrite if we're more recent. Either way, we want to
	-- keep old fields around in case the older version needs them.
	if
		not internalTable.mostRecent or
		self:isVersionGreaterNotEqual(internalTable.mostRecent.version, self.version)
	then
		internalTable.mostRecent = self

		self:initInternal()
	end
end

--[[
	Check whether testVersion is greater than, but not equal to, the savedVersion.
	If savedVersion is nil, this function returns true.
	Don't override.
--]]
function LibraryTemplate:isVersionGreaterNotEqual(savedVersion, testVersion)
	assert(type(savedVersion) == "string")
	assert(type(testVersion) == "string")
	return savedVersion ~= testVersion and modApi:isVersion(savedVersion, testVersion)
end

--[[
	Called when the library's internal table is being initialized for the first time,
	or being overridden by a more recent version.
	Perform initialization of this table here.
--]]
function LibraryTemplate:initInternal()
	error("initInternal not implemeted")
end

--[[
	Internal function to load the library.
	
	When overriding, call LibraryTemplate.load(self, mod, options, version) on the first line.
--]]
function LibraryTemplate:load(mod, options, version)
	modApi:addModsLoadedHook(function()
		if self:isMostRecent() then
			self:mostRecentExclusiveLoad(mod, options, version)
		end
	end)

	return self
end

--[[
	Internal function to check whether this instance is the most recent.
	Don't override.
--]]
function LibraryTemplate:isMostRecent()
	local internalTable = _G[self.internalTableName]

	assert(
		internalTable,
		string.format("Internal table for library '%s' does not exist!", self.name)
	)
	assert(
		internalTable.mostRecent,
		string.format("Internal table for library '%s' does not contain a reference to most recent instance!", self.name)
	)

	return self == internalTable.mostRecent
end

--[[
	Variant of load() that is executed only for the most recent version of this library.
--]]
function LibraryTemplate:mostRecentExclusiveLoad(mod, options, version)
end

return LibraryTemplate
