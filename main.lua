local Duck = require "duck"
local Dog = require "dog"
local Llama
local DeadLlama
local Quads
local Sprites
local ducks = {}
local dogs = {}
local score = 0
local speed = 2
local dead_ducks = 0
local mode = 0
local Sounds
local max_ducks = 3
local cross
local duck_flipped
local score_display = {}
local stock_flight = require "Data.data"
local mountain
local mountain_quads
local stock_duck_x = 0
local counter = 0
local circ = 5
local stock_heights = {}

local function spawn_duck()
	local d = Duck:new()
	math.randomseed(love.timer.getTime())
	d.pos_y = math.random(300)
	table.insert(ducks,d)
end

local function death_animation(d,k)
	if love.timer.getTime() - d.dead_time > 0.3 then
		d:move(3)
	elseif love.timer.getTime() - d.dead_time < 0.1 then
		love.graphics.rectangle("fill", d.pos_x, d.pos_y, 32*3, 32*3) -- hit animation
	end

	if d.pos_y >= 152*3 then -- dead hitting bushes, remove from game
		dead_ducks = dead_ducks + 1
		ducks[k] = nil
	end
end

local function dog_animation()
	if dead_ducks >= 2 then
		dead_ducks = 0
		dog_catch = true
		local d = Dog:new()
		table.insert(dogs,d)
		Sounds[2]:play()
	end
	if #dogs > 0 then
		love.graphics.draw(Sprites, Quads[11], dogs[1].pos_x, dogs[1].pos_y,0,3,3)
		dogs[1]:move()
		if dogs[1].animation == 'stop' then
			table.remove(dogs,1)
		end
	end
end

local function drawCross()
	love.mouse.setVisible( false )
	x, y = love.mouse.getPosition()
	love.graphics.draw(cross, x-20, y-20,0,0.1,0.1)
end

local function update_score_display()
	for k,v in pairs(score_display) do
		v[4] = v[4] -1
		if v[4] <= 0 then
			table.remove(score_display,k)
		else
			love.graphics.print(v[1],v[2],v[3])
		end
	end
end

--[[
local function sample_mountain()
	for k,v in pairs(mountain_quads) do
		 	love.graphics.draw(mountain, v, k%mountain:getWidth(),k/mountain:getWidth(),0,1,1)
	end
end
]]

local function calcHeight(x)
	local index = x	
	local val = stock_flight[index]
	local haha =  300-(300*(val or 0.95))
	return haha
end


local function draw_stock()
	local width = math.ceil(256*3/#stock_flight)
	for k,v in pairs(stock_flight) do

		love.graphics.setColor(100,176,255)
		love.graphics.rectangle("fill", (k), 0, 1, 300-(300*v))
		love.graphics.setColor(255,255,255)
		if #stock_heights <= #stock_flight  then
			table.insert(stock_heights,300-(300*v)-16*3)

		end

	end
end

function love.draw()
	update_score_display()
	--stock_duck_x = (stock_duck_x + 1) % (256*3)
	stock_duck_x = (stock_duck_x + 1)% (280*3)
	
	counter = counter +1
	if counter % 8 == 0 then
		if circ == 5 then 
			circ = 6
		elseif circ == 6 then
			circ = 7
		else 
			circ = 5
		end
	end

	for k,d in pairs(ducks) do -- for each duck in game draw and move
		if mode == 0 then
			if d.sprite < 12 then
				love.graphics.draw(Sprites, Quads[d.sprite], d.pos_x, d.pos_y,0,d.scale_x,d.scale_y)
			else
				love.graphics.draw(duck_flipped, Quads[d.sprite], d.pos_x, d.pos_y,0,d.scale_x,d.scale_y)
			end

		elseif mode == 1 then
			if d.frame == 1 then
				love.graphics.rectangle("fill", 0, 0, 256*3, 224*3) -- flash!!!
			end

			if d.status == 'alive' then
				love.graphics.draw(Llama, d.pos_x, d.pos_y,0,0.15,0.15)
			else 
				love.graphics.draw(DeadLlama, d.pos_x, d.pos_y+150,180,0.15,0.15)
			end
		end
		
		if d.status == 'dead' then
			death_animation(d,k)
		elseif mode < 2 then 
			d:move(speed)
		end
	end

	if mode == 2 then
		love.graphics.draw(mountain, 0, 0,0, 1.5, 2)
		draw_stock()
		love.graphics.setColor(100,176,255)
		love.graphics.rectangle("fill", stock_duck_x, 0, 900, 600)
		love.graphics.setColor(255,255,255)
		--love.graphics.draw(Sprites, Quads[5], stock_duck_x, calcHeight(stock_duck_x),0,3,3)
		--love.graphics.draw(Sprites, Quads[5], stock_duck_x,stock_heights[math.ceil(stock_duck_x/#stock_flight)],0,3,3)
		love.graphics.draw(Sprites, Quads[circ], stock_duck_x-45,calcHeight(stock_duck_x)-45,0,3,3)
		love.graphics.setColor(0,0,0)
		love.graphics.print("IBM",360,200)
		love.graphics.setColor(255,255,255)
	
	end


    if (math.random(100) == 1 or #ducks == 0) and #ducks < max_ducks then -- new ducks! (max = 3)
    	spawn_duck()
	end

	dog_animation()

	love.graphics.draw(Sprites, Quads[1], 0,0,0,3,3) -- bushes
    love.graphics.print("SCORE: "..score,570,600)

    love.graphics.print("Mode: "..mode,100,600)

    drawCross()
end

function love.mousepressed(x, y, button)
   	if button == "l" then
   		Sounds[1]:play()

		for _,d in pairs(ducks) do
			if d:over(x,y) then
				d:hit(love.timer.getTime())
				d.frame = 0
				local score_inc = math.floor(1000*speed)
				score = score + score_inc
				speed = speed + 0.1

				--add to score display
				table.insert(score_display, {score_inc,x-25,y,70})
			end
		end
   	end
end

function love.keypressed(key)
	if key == "c" then
		mode = (mode + 1) % 3
	end

	if mode == 1 then
		Sounds[3]:play()
		ducks = {}
		speed = 4
		max_ducks = 5
	else
		Sounds[3]:stop()
		ducks = {}
		speed = 2
		max_ducks = 3
	end

	if mode == 2 then
		stock_duck_x = 0
	end
end

function love.load()
	love.window.setTitle("#TeamDucks")
	love.window.setMode( 256*3, 224*3)
    Sprites = love.graphics.newImage('images/sprites.png')
    Llama = love.graphics.newImage('images/lama2.png')
    DeadLlama = love.graphics.newImage('images/lama3.png')
    cross = love.graphics.newImage('images/cross.png')
    duck_flipped = love.graphics.newImage('images/duck_r.png')
    love.graphics.setBackgroundColor(100,176,255)
    mountain = love.graphics.newImage('images/mountain2.jpg')

    Sounds = {
    	love.audio.newSource("mp3/hit.mp3","static"),
    	love.audio.newSource("mp3/dog_win.mp3","static"),
    	love.audio.newSource("mp3/llama.mp3")
    } 
	

    local font = love.graphics.newFont("font/DisposableDroidBB.otf",24)
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
 		{296,171,32,32}, --blackduck5
 		{333,171,32,32}, --blackduck6
 		{264,210,32,32}, --blackduck7
 		{296,210,32,32}, --blackduck8
 		{324,210,32,32}, --blackduck9
 		{504,309,56,39}, -- dog
	}

	Quads = {}
	for i,info in ipairs(Tiles) do
	  -- info[1] = x, info[2] = y, info[3] = width, info[4] = height
	  Quads[i] = love.graphics.newQuad(info[1], info[2], info[3], info[4], tilesetW, tilesetH)
	end
	
	Quads[12] = love.graphics.newQuad(0,0,32,32, 109, 32)
	Quads[13] = love.graphics.newQuad(37,0,32,32, 109, 32)
	Quads[14] = love.graphics.newQuad(75,0,32,32, 109, 32)


--[[
	mountain_quads = {}
	for i = 1,mountain:getWidth(),1 do
		for j = 1,mountain:getHeight(),1 do
			table.insert(mountain_quads,love.graphics.newQuad(i,j,1,1, mountain:getWidth(), mountain:getHeight()))
		end
	end
	]]

	-- 1st duck in game
	spawn_duck()
end

