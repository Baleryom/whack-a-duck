if pcall(require, "lldebugger") then require("lldebugger").start() end
if pcall(require, "mobdebug") then require("mobdebug").start() end

_G.x = 0
_G.y = 0
_G.paused = false
local duckNumber = 0
function love.load()
    frame = 0
    love.window.setMode(800, 600, { resizable = true, vsync = 1, minheight = 300 })
    image = love.graphics.newImage('image.png')
end

function love.update(dt)
    frame = frame + 1
    print(frame)
    if _G.x < 20 then
        _G.x = _G.x + 1 + (15 * dt)
    end
    if _G.y < 20 then
        _G.y = _G.y + 1 + (15 * dt)
    end
    _G.x = _G.x + 1
    _G.y = _G.y + 1
    if _G.x > 800 then
        _G.x = 0
        duckNumber = 0
        love.graphics.clear(love.graphics.getBackgroundColor())
    end

    if _G.y > 600 then
        _G.y = 0
        love.graphics.clear(love.graphics.getBackgroundColor())
    end
end

function love.keypressed(key)
    if key == "escape" then
        if _G.paused == true then
            _G.paused = false
        else
            _G.paused = true
        end
    end
end

function love.draw()
    love.graphics.draw(image, love.math.random(0, _G.x), love.math.random(0, _G.y))
    duckNumber = duckNumber + 1
    love.window.setTitle("Whack-a-duck count: " .. tostring(duckNumber) .. " FPS: " .. tostring(frame))
end

function love.run()
    if love.math then love.math.setRandomSeed(os.time()) end

    if love.load then love.load(arg) end
    print(arg[3])

    -- Fixed Delta time
    --_G.dt = 1/60

    -- Variable Delta time (same as default love.run)
    _G.dt = 0

    -- We don't want the first frame's dt to include time taken b_G.y love.load.
    if love.timer then
        love.timer.step()
        dt = love.timer.getDelta()
    end

    -- Variable Semi-fixed TImesteep
    -- local dt = 0
    -- upper_dt = 1/60
    --[[
        while _G.dt > 0 do
            local current_dt = math.min(dt, upper_dt)
            if love.update then love.update(current_dt) end
            dt = dt - current_dt
        end
    ]]

    local consecutiveLargeDts = 0
    local nextTime = 0

    -- Main loop time.
    while true do
        -- Process events.
        love.event.pump()
        for name, a, b, c, d, e, f in love.event.poll() do
            if name == "quit" then
                if not love.quit or not love.quit() then
                    return a
                end
            end
            love.handlers[name](a, b, c, d, e, f)
        end

        -- Update dt, as we'll be passing it to update
        nextTime = nextTime + 1 / 60
        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta()
            if dt > 0.5 and consecutiveLargeDts < 3 then
                -- We prefer the game to slow down on large short spikes
                -- so the units don't teleport around
                dt = 0.016
                consecutiveLargeDts = consecutiveLargeDts + 1
            elseif dt <= 0.5 then
                consecutiveLargeDts = 0
            end
        end
        if _G.paused then
            _G.dt = 0
        end

        -- Call update and draw
        if love.update and _G.paused == false then love.update(_G.dt) end -- will pass 0 if love.timer is disabled

        if love.graphics and love.graphics.isActive() then
            love.graphics.origin()
            if love.draw and _G.paused == false then
                love.draw()
            end
            love.graphics.present()
        end

        if love.timer then love.timer.sleep(0.001) end
    end
end
