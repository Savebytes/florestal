local debugMode = true
local debugGame = require("src.debugGame")
local trees = require("src.treeObjects")
local menuUI = require("src.UI")
local timer = require("src.timer")
local playerStats = require("src.playerStats")

-- Entity
local entity = require("entity")
local worldManager = require("src.world_manager")

-- Components
local rendererComponent = require("internal_components.renderer")
local transformComponent = require("internal_components.transform")
local followMouse = require("components.follow_mouse")

--#region

local objectTransform = {
    x = 0,
    y = 0, 
    width = 5,
    height = 5
}

local gamePaused = false
local tutorial = true

local stats = playerStats

local modes = {
    seedMode = 0,
    normalMode = 1
}
local mouseMode = modes.normalMode

local originX, originY = objectTransform.width * 0.5, objectTransform.height * 0.5
local windowHeight, windowWidth = love.graphics.getHeight(), love.graphics.getWidth()

local goutSprite = love.graphics.newImage("data/sprites/gout.png")
local goutWidth, goutHeight = goutSprite:getDimensions()

local treeSprite = love.graphics.newImage("data/sprites/tree.png")
local treeWidth, treeHeight = treeSprite:getDimensions()

local cloudSprite = love.graphics.newImage("data/sprites/cloud.png")
local cloudWidth, cloudHeight = cloudSprite:getDimensions()

local groundSprite = love.graphics.newImage("data/sprites/ground.png")
local groundWidth, groundHeight = groundSprite:getDimensions()

local backgroundSprite = love.graphics.newImage("data/sprites/background.png")
local backgroundWidth, backgroundHeight = backgroundSprite:getDimensions()

local shootingStarSprite = love.graphics.newImage("data/sprites/star.png")
local shootingStarWidth, shootingStarHeight = shootingStarSprite:getDimensions()

local starsSprite = love.graphics.newImage("data/sprites/stars.png")
local starsWidth, starsHeight = starsSprite:getDimensions()

local mouseSprite = love.graphics.newImage("data/sprites/mouse.png")
local mouseWidth, mouseHeight = mouseSprite:getDimensions()

local mouseAxeSprite = love.graphics.newImage("data/sprites/axe.png")
local mouseAxeWidth, mouseAxeHeight = mouseAxeSprite:getDimensions()

local vignetteSprite = love.graphics.newImage("data/sprites/vignette.png")
local vignetteWidth, vignetteHeight = vignetteSprite:getDimensions()

local tutorialSprite = love.graphics.newImage("data/sprites/tutorial.png")
local tutorialWidth, tutorialHeight = tutorialSprite:getDimensions()



local mouseState = {
    sprite = mouseSprite,
    color = {1, 1, 1, 1}
}

local goutObjects = {}
local cloudObjects = {}
local groundObjects = {}
local backgroundObjects = {}
local starsObjects = {}
local shootingStarObjects = {}

local gameColors = {
    background = {96/255, 156/255, 240/255, 1},
    gout = {0, 0, 0.5, 1},
    cloud = {0.9, 0.9, 0.9, 1},
    cloudRaining = {0.7, 0.7, 0.7, 1}
}

local waterAmount = 0
local waterLevel = 1

local cloudTimer = 3
local leftMouseDown = nil
local mousePressed = nil

local raining = false

local growShader = nil
local positionShader = nil
local windShader = nil

local rainSfx = love.audio.newSource("data/sfx/rain-sfx.ogg", "stream")
local windSfx = love.audio.newSource("data/sfx/wind-sfx.ogg", "stream")
local mainMusic = love.audio.newSource("data/music/main-music.ogg", "stream")
local bushSfx = love.audio.newSource("data/sfx/bush-sfx.wav", "static")
local prohibitedSfx = love.audio.newSource("data/sfx/prohibited.ogg", "static")

local treePlaceholder = nil

--#endregion

--love.graphics.print("Woods: " .. trees.woodAmount, 10 + 5, 10)
local mainWorld = worldManager:createWorld()

function love.load()
    -- tests
    local tutorial = entity.new("tutorial", {55, 0})
    tutorial:addComponent(rendererComponent.new(tutorialSprite))

    local mouse = entity.new("mouse", {300, 0})
    mouse:addComponent(rendererComponent.new(mouseSprite, 0.2))
    mouse:addComponent(followMouse.new(mouse:getComponent("transform")))

    mainWorld:addEntity(tutorial)
    mainWorld:addEntity(mouse)

    mainWorld:start()

    love.mouse.setVisible(false)

    windSfx:play()
    windSfx:setLooping(true)
    windSfx:setVolume(0.3)

    mainMusic:setLooping(true)
    mainMusic:setVolume(0.5)
    mainMusic:play()

    rainSfx:setVolume(0.6)
    rainSfx:setLooping(true)

    timer.newTimer(16, function()
        local randomX = love.math.random(shootingStarWidth, windowWidth)
        local shootingStar = {
            x = randomX,
            y = -(shootingStarHeight),
            width = 1,
            height = 1
        }
        table.insert(shootingStarObjects, shootingStar)
    end)

    local i = 0
    while i < windowWidth do
        local ground = {x = i, y = (windowHeight) - (groundHeight - 40), width = 1, height = 1}
        table.insert(groundObjects, ground)

        i = i + groundWidth
    end

    local j = 0
    while j < windowWidth do
        local background = {x = j, y = (windowHeight) - (backgroundHeight + 50), width = 1, height = 1}
        table.insert(backgroundObjects, background)

        j = j + backgroundWidth
    end

    local z = 0
    while z < windowWidth do
        local star = {x = z, y = -30, width = 1, height = 1}
        table.insert(starsObjects, star)

        z = z + starsWidth
    end

    menuUI.newButton("resume", "Continuar", 10, (windowHeight - 40) + -160, 200, 40, function() 
        prohibitedSfx:play()
        gamePaused = not gamePaused
    end, {1, 1, 1, 1})
    
    menuUI.newButton("restart", "Reiniciar", 10, (windowHeight - 40) + -100, 200, 40, function() 
        prohibitedSfx:play()
        love.timer.sleep(0.1)
        love.event.quit('restart')
    end, {1, 1, 1, 1})

    menuUI.newButton("quit", "Sair", 10, (windowHeight - 40) + -40, 200, 40, function() 
        prohibitedSfx:play()
        love.timer.sleep(0.2)
        love.event.quit()
    end, {1, 1, 1, 1})
    
    menuUI.newText("seeds", "Sementes: " .. stats.waterAmount, 10, 80, 220, 40, {1, 1, 1, 1})
    menuUI.newText("wood", "Madeiras: " .. stats.woodsAmount, 10, 140, 220, 40, {1, 1, 1, 1})
    menuUI.newText("water", "Água: " .. stats.waterAmount, 10, 200, 220, 40, {1, 1, 1, 1})

    growShader = love.graphics.newShader [[
        uniform number size = 0;

        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){
            vec4 pixel = Texel(texture, texture_coords);
            if(texture_coords.y > size){
                return pixel * vec4(1, 1, 1, 1);
            }else{
                return pixel * vec4(1, 1, 1, 0);
            }
        }
    ]]

    positionShader = love.graphics.newShader("data/shaders/positionshader.glsl")
    windShader = love.graphics.newShader("data/shaders/windshader.glsl")

    treePlaceholder = {
        x = 0,
        y = groundObjects[1].y - (treeHeight * 0.2),
        width = 0.2,
        height = 0.2,
        color = {0, 1, 0, 0.0}
    }

    

    -- first cloud :)
    local cloud = {x = -300, y = 0, isRaining = true, width = 1, height = 1}
    table.insert(cloudObjects, cloud)
end

function love.update(dt)
    mainWorld:update(dt)

    if tutorial then
        return
    end

    

    if gamePaused then
        menuUI.update(love.mouse.getX(), love.mouse.getY(), leftMouseDown)
        mouseState.sprite = mouseSprite
        mouseState.color = {1, 1, 1, 1}
        return
    end

    growShader:send("size", love.mouse.getY())

    if mouseMode == modes.normalMode then
        mouseState.sprite = mouseSprite
        mouseState.color = {1, 1, 1, 1}
        treePlaceholder.color = {0, 1, 0, 0}
    elseif mouseMode == modes.seedMode then
        mouseState.color = {1, 1, 1, 0}
        treePlaceholder.x = love.mouse.getX() - 10
        if stats.seedsAmount <= 0 then
            treePlaceholder.color = {1, 0, 0, 0.7}
        else
            treePlaceholder.color = {0, 1, 0, 0.7}
        end
    end


    positionShader:send("time", love.timer.getTime())
    windShader:send("time", love.timer.getTime())
    
      
    --shootingStarObject.y = shootingStarObject.y + 2
    --shootingStarObject.x =  
    --x = 0,
    --y = 0,
    --width = 1,
    -- height = 1
    
    timer.updateTimers(dt)

   -- UI.setTextByName("woodsText", trees.woodAmount)
    menuUI.text["seeds"].text = "Sementes: " .. math.floor(stats.seedsAmount)
    menuUI.text["wood"].text = "Madeiras: " .. stats.woodsAmount
    menuUI.text["water"].text = "Água: " .. roundNumber(stats.waterAmount, 0.01) .. "L"

    if trees.mouseOverTree then
        mouseState.sprite = mouseAxeSprite
    else
        mouseState.sprite = mouseSprite
    end

    if love.mouse.isDown(1) then
        mousePressed = true
    end

    for key, value in pairs(goutObjects) do
        value.y = value.y + love.math.random(300, 400) * dt
        if value.y > windowHeight then
            stats.waterAmount = stats.waterAmount + 0.001
            table.remove(goutObjects, key)
        end
    end

    for key, value in ipairs(shootingStarObjects) do
        value.x = value.x - 340 * dt
        value.y = value.y + 350 * dt

        if value.y > windowHeight then
            table.remove(shootingStarObjects, key)
        end
    end

    local isRainingThisFrame = false

    for key, value in pairs(cloudObjects) do
        value.x = value.x + 30 * dt

        --[[
        local collision = mathUtils.checkCollision(objectTransform.x, objectTransform.y, objectTransform.width, objectTransform.height, value.x, value.y, cloudWidth, cloudHeight)   
        if collision and leftMouseDown then
            value.isRaining = not value.isRaining
        end
        ]]--

        if value.isRaining then
            local gout = {x = value.x + (cloudWidth / 2) + love.math.random(-100, 100), y = value.y + (cloudHeight / 2)}
            isRainingThisFrame = true
            table.insert(goutObjects, gout)    
        else
            if not isRainingThisFrame then
                isRainingThisFrame = false
            end
        end

        if value.x > windowWidth then
            table.remove(cloudObjects, key)
        end
    end

    trees.update(stats, objectTransform, mousePressed, treeWidth, treeHeight, dt, groundObjects[1].y)

    raining = isRainingThisFrame
    if raining and not rainSfx:isPlaying() then
        rainSfx:play()
    elseif not raining and rainSfx:isPlaying() then
        rainSfx:stop()
    end

    if cloudTimer > 0 then
        cloudTimer = cloudTimer - dt
    elseif cloudTimer <= 0 then
        cloudTimer = 10
        
        if love.math.random(0, 1) >= 1 then
            local cloud = {x = -300, y = 0, isRaining = love.math.random(0, 1) >= 1, width = 1, height = 1}
            table.insert(cloudObjects, cloud)
        end
    end


    leftMouseDown = false
    mousePressed = false

    if debugMode then
        debugGame.update() 
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        leftMouseDown = true
        if mouseMode == modes.seedMode then
            plantPlant()
        end
    end
end

function love.mousemoved(x, y)
    objectTransform.x = love.mouse.getX()
    objectTransform.y = love.mouse.getY()
end

function love.keypressed(key)
    if key == "return" then
        tutorial = false
    end
    if tutorial then
        return
    end
    if key == "escape" then
        gamePaused = not gamePaused
    end

    if key == "e" then
        if mouseMode ~= modes.seedMode then
            mouseMode = modes.seedMode
        else
            mouseMode = modes.normalMode
        end
    end
end

function plantPlant() 
    if stats.seedsAmount <= 0 then
        return
    end
    local randomX = love.math.random(treeWidth / 2, windowWidth - (treeWidth / 2))
    local randomTimer = love.math.random(1, 2)
    
    local tree = {
        x = treePlaceholder.x,
        y = groundObjects[1].y - (treeHeight * 0.2),
        width = 0.2,
        height = 0.2,
        selected = false,
        health = 1,
        angle = 0,
        grown = 0,
        growTimer = randomTimer,
        timeBtwGrow = randomTimer,
        canCrop = false,
        color = {1, 1, 1, 1}
    }

    table.insert(trees.objects, tree)
    stats.seedsAmount = stats.seedsAmount - 1

    bushSfx:play()
end

function love.draw()
    love.graphics.setColor(1, 1, 1, 1)
    mainWorld:draw()

    -- UI DEBUG
    if debugMode then
        debugGame.draw()
    end
    --[[ 
    love.graphics.setBackgroundColor(gameColors.background)

    love.graphics.setShader()
    love.graphics.setColor(1, 1, 1, 0.5)
    for _, value in pairs(starsObjects) do
        love.graphics.draw(starsSprite, value.x, value.y, 0, 1, 1)
    end

    love.graphics.setColor(1, 1, 1, 0.5)
    for _, value in pairs(shootingStarObjects) do
        love.graphics.draw(shootingStarSprite, value.x, value.y, 0, 1, 1)
    end

    love.graphics.setShader()
    love.graphics.setColor(1, 1, 1, 1)
    for _, value in pairs(backgroundObjects) do
        love.graphics.draw(backgroundSprite, value.x, value.y, 0, 1, 1)
    end

    trees.draw(treeSprite) 


    love.graphics.setShader()
    love.graphics.setColor(treePlaceholder.color)
    love.graphics.draw(treeSprite, treePlaceholder.x, treePlaceholder.y, 0, treePlaceholder.width, treePlaceholder.height)

    love.graphics.setShader()
    love.graphics.setColor(gameColors.gout)
    for _, value in pairs(goutObjects) do
        love.graphics.draw(goutSprite, value.x, value.y, 0, 0.05, 0.05)
    end

    love.graphics.setShader(positionShader)
    for _, value in pairs(cloudObjects) do
        if value.isRaining == false then
            love.graphics.setColor(gameColors.cloud)
            love.graphics.draw(cloudSprite, value.x, value.y, 0)
        else
            love.graphics.setColor(gameColors.cloudRaining)
            love.graphics.draw(cloudSprite, value.x, value.y, 0)
        end
        
    end

    love.graphics.setShader()
    love.graphics.setColor(1, 1, 1, 1)
    for _, value in pairs(groundObjects) do
        love.graphics.draw(groundSprite, value.x, value.y, 0, 1, 1)
    end
    
    love.graphics.setShader()

    --UI.draw()
    if gamePaused then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, windowWidth, windowHeight)
        menuUI.draw()
    end

    

    love.graphics.setShader()
    love.graphics.setColor(mouseState.color)
    love.graphics.draw(mouseState.sprite, objectTransform.x - originX, objectTransform.y - originY, 0, 0.2, 0.2)

    love.graphics.setColor(1, 1, 1, 1)
    -- fit to screen: windowWidth / spriteWidth
    love.graphics.draw(vignetteSprite, 0, 0, 0, love.graphics.getWidth() / vignetteWidth, love.graphics.getHeight() / vignetteHeight)

    

    ]]--
end

function roundNumber(number, roundBy)
    return math.floor((number/roundBy) + 0.5) * roundBy
end