local Duck = {
}

function Duck:new (obj)
	obj = obj or {status = 'alive', direction = 'right', pos_x = 0, pos_y = 0}   -- create object if user does not provide one
	setmetatable(obj, self)
	self.__index = self
	return obj
end

--[[
	directions = {
		'upright',
		'upleft',
		'left',
		'right',
		'up',
		'down',
		'downright',
		'downleft'

	}
]]
return Duck