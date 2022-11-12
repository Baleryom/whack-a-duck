x = 0
y = 0
function love.load()
    image = love.graphics.newImage('image.png')
end

function love.update(dt)
    if x < 20 then
        x = x + 1 + (15 * dt)
    end
    if y < 20 then
        y = y + 1 + (15 * dt)
    end
    x = x + 1
    y = y + 1
    if x > 800 then
        x = 0
        love.graphics.clear(love.graphics.getBackgroundColor())
    end

    if y > 600 then
        y = 0
    end

end

function love.draw()
    love.graphics.draw(image, love.math.random(0, x), love.math.random(0, y))
end


function love.run()
    if love.math then
	love.math.setRandomSeed(os.time())
    end

    if love.load then love.load(arg) end

    -- We don't want the first frame's dt to include time taken by love.load.
    if love.timer then love.timer.step() end

    local dt = 0

    -- Main loop time.
    while true do
        -- Process events.
        if love.event then
	    love.event.pump()
	    for name, a,b,c,d,e,f in love.event.poll() do
	        if name == "quit" then
		    if not love.quit or not love.quit() then
		        return a
		    end
	        end
		love.handlers[name](a,b,c,d,e,f)
	    end
        end

	-- Update dt, as we'll be passing it to update
	if love.timer then
	    love.timer.step()
	    dt = love.timer.getDelta()
	end

	-- Call update and draw
	if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

	if love.graphics and love.graphics.isActive() then
	    love.graphics.origin()
            if love.draw then love.draw() end
	    love.graphics.present()
	end

	if love.timer then love.timer.sleep(0.001) end
    end
end