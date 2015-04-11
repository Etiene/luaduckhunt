local Duck = {
}

function Duck:new (obj)
	obj = obj or {status = 'alive', direction_x = 'right', direction_y = nil, pos_x = 0, pos_y = 0}   -- create object if user does not provide one
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

local function randfunc()

end

function Duck:move(speed)
	if self.direction_x == 'right' then
		self.pos_x = self.pos_x+speed
	elseif self.direction_x == 'left' then
		self.pos_x = self.pos_x-speed
	end

	if self.direction_y == 'down' then
		self.pos_y = self.pos_y+speed
	elseif self.direction_y == 'up' then
		self.pos_y = self.pos_y-speed
	end

	if self.pos_x == 256*3 then
		self.pos_x = -32*3
	end

end

function Duck:changeDirection(self)

end

return Duck