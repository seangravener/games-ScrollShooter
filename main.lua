debug = true

player = { x = 200, y = 710, speed = 150, img = nil }

function love.load(arg)
    player.img = love.graphics.newImage('assets/Aircraft_03.png')
end

function love.update(dt)

end

function love.draw(dt)
  love.graphics.draw(player.img, player.x, player.y)
end
