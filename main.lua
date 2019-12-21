require 'util'
collision = require 'collision'
debug = true

player = { x = 200, y = 510, speed = 490
, img = nil }
isAlive = true
score = 0

canShoot = true
canShootTimerMax = 5
canShootTimer = canShootTimerMax
bulletImg = nil
bullets = {}

createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax
enemyImg = nil
enemies = {}

function love.load(arg)
    player.img = love.graphics.newImage('assets/Aircraft_05.png')
    bulletImg = love.graphics.newImage('assets/bullet_orange0004.png')
    enemyImg = love.graphics.newImage('assets/rocket_purple.png')
end

function love.update(dt)
    -- Pressing ESC exits the game
    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end

    -- Player horizontal movement
    if love.keyboard.isDown('left', 'a') then
        if player.x > 0 then
            player.x = player.x - (player.speed * dt)
        end
    elseif love.keyboard.isDown('right', 'd') then
        if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
            player.x = player.x + (player.speed * dt)
        end
    end

    -- Player vertical movement
    if love.keyboard.isDown('up', 'w') then
        if player.y > (love.graphics.getHeight() / 2) then
            player.y = player.y - (player.speed * dt)
        end
    elseif love.keyboard.isDown('down', 's') then
        if player.y < (love.graphics.getHeight() - 55) then
            player.y = player.y + (player.speed * dt)
        end
    end

    canShoot = canShootTimer - (1 * dt)
    if canShootTimer < 0 then
        canShoot = true
    end

    if love.keyboard.isDown('space', 'rctrl', 'lctrl') and canShoot then
        newBullet = { x = player.x + (player.img:getWidth()/2), y = player.y, img = bulletImg }
        table.insert(bullets, newBullet)
        canShoot = true
        canShootTimer = canShootTimerMax
    end

    for i, bullet in ipairs(bullets) do
        bullet.y = bullet.y - (1000 * dt)
        if bullet.y < 10 then
            table.remove(bullets, img)
        end
    end

    -- enemy timer
    createEnemyTimer = createEnemyTimer - (2* dt)
    if createEnemyTimer < 0 then
        createEnemyTimer = createEnemyTimerMax

        -- create an enemy
        randomNumber = math.random( 2, love.graphics.getWidth() - 10)
        newEnemy = { x = randomNumber, y = -2, img = enemyImg }
        table.insert(enemies, newEnemy)
    end

    for i, enemy in ipairs(enemies) do
        enemy.y = enemy.y + (280 * dt)
        if enemy.y > 850 then
            table.remove(enemies, i)
        end
    end

    -- run our collision detection
    -- Since there will be fewer enemies on screen than bullets we'll loop them first
    -- Also, we need to see if the enemies hit our player
    for i, enemy in ipairs(enemies) do
        for j, bullet in ipairs(bullets) do
            if collision.check(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
                table.remove(bullets, j)
                table.remove(enemies, i)
                score = score + 5
            end
        end

        if collision.check(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight())
        and isAlive then
            table.remove(enemies, i)
            isAlive = false
        end
    end

    if not isAlive and love.keyboard.isDown('r') then
        -- remove all our bullets and enemies from screen
        bullets = {}
        enemies = {}

        -- reset timers
        canShootTimer = canShootTimerMax
        createEnemyTimer = createEnemyTimerMax

        -- move player back to default position
        player.x = 200
        player.y = 510

        -- reset our game state
        score = 0
        isAlive = true
    end

    if love.keyboard.isDown('c') then
        print_r(player)
    end
end

function love.draw(dt)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("SCORE: " .. tostring(score), 400, 10)

    if isAlive then
        love.graphics.draw(player.img, player.x, player.y)
    else
        love.graphics.print("Press 'R' to reset", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
    end

    for i, bullet in ipairs(bullets) do
        love.graphics.draw(bullet.img, bullet.x, bullet.y)
    end

    for i, enemy in ipairs(enemies) do
        love.graphics.draw(enemy.img, enemy.x, enemy.y)
    end
end
