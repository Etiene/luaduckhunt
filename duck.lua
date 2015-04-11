local Duck = {}

function Duck:new (obj)
	obj = obj or {status = 'alive', direction_x = 'right', direction_y = nil, pos_x = 0, pos_y = 0}   -- create object if user does not provide one
	setmetatable(obj, self)
	self.__index = self
	return obj
end

function Duck:move(speed)
	if self.status =='alive' then
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
end

function Duck:changeDirection()
end

function Duck:over(x,y)
	if x >= self.pos_x and x <= self.pos_x+32*3 and y >= self.pos_y and y <= self.pos_y+32*3 then
		return true
	end
	return false
end

function Duck:hit()
	self.status = 'dead'
end

return Duck