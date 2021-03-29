GAMEMODE_MENU = 1
GAMEMODE_PLAYING = 2

function love.load()
    love.window.setTitle("Shooting Gallery")
    love.window.setMode(love.graphics:getWidth(), love.graphics:getHeight())

    target = {}
    target.x = 300
    target.y = 300
    target.radius = 50

    score = 0
    timer = 0
    gameState = GAMEMODE_MENU

    gameFont = love.graphics.newFont(40)

    sprites = {}
    sprites.sky = love.graphics.newImage('assets/img/sky.jpg')
    sprites.target = love.graphics.newImage('assets/img/target.png')
    sprites.crosshair = love.graphics.newImage('assets/img/crosshair.png')
    
    love.mouse.setVisible(false)

    sounds = {}
    sounds.hit = love.audio.newSource("assets/sounds/hit.mp3", "static")
end

function love.update(dt)
    if timer > 0 then
        timer = timer - dt
    end
    
    if timer < 0 then
        timer = 0
        gameState = GAMEMODE_MENU
    end
end

function love.draw()
    love.graphics.draw(sprites.sky, 0, 0, 0, love.graphics.getWidth() / sprites.sky:getWidth(), love.graphics.getHeight() / sprites.sky:getHeight())

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(gameFont)
    love.graphics.printf("Score: " .. score, 5, 5, love.graphics.getWidth(), "left")
    love.graphics.printf("Time: " .. math.ceil(timer), 0, 5, love.graphics.getWidth(), "right")
    
    if gameState == 1 then
        love.graphics.printf("Click anywhere to begin!", 0, 250, love.graphics.getWidth(), "center")
    end

    if gameState == 2 then
        love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
    end
    
    love.graphics.draw(sprites.crosshair, love.mouse.getX() - sprites.crosshair:getWidth() / 2, love.mouse.getY() - sprites.crosshair:getHeight() / 2)
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 and gameState == 2 then
        local mouseToTarget = distanceBetween(x, y, target.x, target.y)
        if mouseToTarget < target.radius then
            score = score + 1
            sounds.hit:seek(0)
            sounds.hit:play()
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
        end
    elseif button == 1 and gameState == 1 then
        gameState = GAMEMODE_PLAYING
        timer = 10
        score = 0
    end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end
