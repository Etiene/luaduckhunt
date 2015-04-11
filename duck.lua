local Duck = {}

function Duck:new (obj)
	obj = obj or {
		status = 'alive', 
		direction_x = 'right', 
		direction_y = nil, 
		pos_x = 0, 
		pos_y = 0,
		sprite = 5,
		dead_time = 0,
		frame = 0
	}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

function Duck:move(speed)
	if self.direction_x == 'right' then
		self.pos_x = math.floor(self.pos_x+speed)
	elseif self.direction_x == 'left' then
		self.pos_x = self.pos_x-speed
	end

	if self.direction_y == 'down' then
		self.pos_y = math.floor(self.pos_y+speed)
	elseif self.direction_y == 'up' then
		self.pos_y = math.floor(self.pos_y-speed)
	end

	if self.pos_x >= 256*3 then -- if it hits right end of screen, it goes back to the left beginning 
		self.pos_x = -32*3
	end


	if self.status == 'alive' then
		self:flap(speed)
		if math.random(50) == 1 then
			self:changeDirection()
		end
		if self.pos_y >= 123*3 then
			self.direction_y = 'up'
		elseif self.pos_y <= 5 then
			self.direction_y = 'down'
		end
	else
		self:spin()
	end
end

function Duck:flap(speed)
	if self.frame == math.floor(10-speed) then
		self.sprite = 6
	elseif self.frame == math.floor(20-speed) then
		self.sprite = 7
	elseif self.frame == math.floor(30-speed) then
		self.sprite = 5
		self.frame = 0
	end

	self.frame = self.frame + 1
end

function Duck:spin()
	if self.frame == 7 then
		self.sprite = 9
	elseif self.frame == 14 then
		self.sprite = 10
		self.frame = 0
	end
	self.frame = self.frame + 1
end


function Duck:changeDirection()
	if not self.direction_y and math.random(1,2)==1 then
		self.direction_y = 'up'
	elseif not self.direction_y then
		self.direction_y = 'down'
	elseif self.direction_y then
		self.direction_y = nil
	end
end

function Duck:over(x,y)
	if x >= self.pos_x and x <= self.pos_x+32*3 and y >= self.pos_y and y <= self.pos_y+32*3 then -- if x,y is over duck
		return true
	end
	return false
end

function Duck:hit(time)
	self.status = 'dead'
	self.direction_y = 'down'
	self.direction_x = nil
	self.sprite = 8
	self.dead_time = time
end

return Duck