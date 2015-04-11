local Quads
local Sprites
local Duck = require "duck"
local ducks = {}

function love.draw()
      love.graphics.draw(Sprites, Quads[1], 0,0,0,3,3)
      
      for _,d in pairs(ducks) do
      	love.graphics.draw(Sprites, Quads[5], d.pos_x, d.pos_y,0,3,3)
      	d:move(4)
      end
end

function love.mousepressed(x, y, button)
   	if button == "l" then
		for _,d in pairs(ducks) do
			if d:over(x,y) then
				d:hit()
			end
		end
   	end
end

function love.load()
	love.window.setTitle("#TeamDucks")
	love.window.setMode( 256*3, 224*3)
    Sprites = love.graphics.newImage('images/sprites.png')
  
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
 		{196,210,32,32}, --blackduck8
 		{324,210,32,32}, --blackduck9
	}

	Quads = {}
	for i,info in ipairs(Tiles) do
	  -- info[1] = x, info[2] = y
	  Quads[i] = love.graphics.newQuad(info[1], info[2], info[3], info[4], tilesetW, tilesetH)
	end
	

	local d = Duck:new()
	table.insert(ducks,d)

	test = d.status
end