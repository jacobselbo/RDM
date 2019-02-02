local class = {
	["Name"] = "BaseClass"
}

class.New = function(s)
	return setmetatable({}, {
		__index = function(self, k)
			if (rawget(self, k)) then
				return rawget(self, k)
			end

			if (class[k]) then
				return class[k]
			end
		end
	})
end

class.Extend = function(s, ext)
	return setmetatable({}, {
		__index = function(self, k)
			if (rawget(self, k)) then
				return rawget(self, k)
			end

			if (ext[k]) then
				return ext[k]
			end

			if (s[k]) then
				return s[k]
			end
		end
	})
end

class.Lock = function(self)
	return setmetatable({}, {
		__index = function(_, k)
			return self[k]
		end,

		__newindex = function()
			return error("New indexes are locked for this class.")
		end,

		__metatable = "Locked Class!"
	})
end

return setmetatable({}, {
	__index = function(_, k)
		return class[k]
	end,

	__newindex = function()
		return error("New indexes are locked for global BaseClass")
	end
})