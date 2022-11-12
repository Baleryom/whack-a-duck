x = 0
y = 0
function love.load()
    image = love.graphics.newImage('image.png')
end

function love.update(dt)
    if x < 20 then
        x = x+1 + (15 * dt)
    end
    if y < 20 then
        y = y+1 +(15 * dt)
    end
    x = x+1
    y = y+1
    if x > 800 then
        x = 0
    end

    if y > 600 then
        y = 0
    end

end

function love.draw()
    love.graphics.draw(image, love.math.random(0, x), love.math.random(0, y))
end