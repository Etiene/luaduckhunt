local Dog = {}

function Dog:new (obj)
	obj = obj or {
		pos_x = 300,
		pos_y = 430,
		animation = 'up'
	}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

function Dog:move()
	if self.animation == 'up' then 
		self.pos_y = self.pos_y - 2
	else
		self.pos_y = self.pos_y + 2
	end

	if self.pos_y <= 350 then
		self.animation = 'down'
	end

	if self.animation == 'down' and self.pos_y >=430 then
		self.animation = 'stop'
	end

end

return Dog