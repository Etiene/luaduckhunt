local Quads
local Sprites
local Duck = require "duck"
local ducks = {}
local score = 0
local speed = 1
local dead_ducks = 0

function love.draw()
	for k,d in pairs(ducks) do -- for each duck in game draw and move
		love.graphics.draw(Sprites, Quads[d.sprite], d.pos_x, d.pos_y,0,3,3)
		

		if d.status == 'dead' then
			if love.timer.getTime() - d.dead_time > 0.3 then
				d.sprite = 9
				d:move(3)
			elseif love.timer.getTime() - d.dead_time > 0.1 then

			else
				love.graphics.rectangle("fill", d.pos_x, d.pos_y, 32*3, 32*3) -- hit animation
			end
		else 
			d:move(speed)
		end


		if d.pos_y >= 224*3 then -- dead hitting bottom of the screen, remove from game
			ducks[k] = nil
		end
	end

    love.graphics.draw(Sprites, Quads[1], 0,0,0,3,3) -- bushes
    love.graphics.print("Score: "..score,570,600)

    if (math.random(100) == 1 or #ducks == 0) and #ducks <= 3 then -- new ducks!
    	local d = Duck:new()
    	d.pos_y = math.random(300)
		table.insert(ducks,d)
	end

end

function love.mousepressed(x, y, button)
   	if button == "l" then
		for _,d in pairs(ducks) do
			if d:over(x,y) then
				d:hit(love.timer.getTime())
				dead_ducks = dead_ducks + 1
				score = math.floor(score + 1000*speed)
				speed = speed * 1.1
			end
		end
   	end
end

function love.load()
	love.window.setTitle("#TeamDucks")
	love.window.setMode( 256*3, 224*3)
    Sprites = love.graphics.newImage('images/sprites.png')
    love.graphics.setBackgroundColor(100,176,255)

    local font = love.graphics.newFont(24)
    love.graphics.setFont(font)

    math.randomseed(love.timer.getTime())
  
	local tilesetW, tilesetH = Sprites:getWidth(), Sprites:getHeight()
  
 	local Tiles = {
 		--x and y from top left pixel, width and height
 		{644,136,256,224}, --background
 		{263,136,32,32}, --blackduck1
 		{297,136,32,32}, --blackduck2
 		{331,136,32,32}, --blackduck3
 		{258,171,32,32}, --blackduck4
 		{196,171,32,32}, --blackduck5
 		{333,171,32,32}, --blackduck6
 		{264,210,32,32}, --blackduck7
 		{296,210,32,32}, --blackduck8
 		{324,210,32,32}, --blackduck9
	}

	Quads = {}
	for i,info in ipairs(Tiles) do
	  -- info[1] = x, info[2] = y, info[3] = width, info[4] = height
	  Quads[i] = love.graphics.newQuad(info[1], info[2], info[3], info[4], tilesetW, tilesetH)
	end
	

	-- 1st duck in game
	local d = Duck:new()
	d.pos_y = math.random(300)
	table.insert(ducks,d)

end