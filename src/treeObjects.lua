local mathUtils = require("src.mathUtils")

local treeObjects = {}
treeObjects.objects = {}
treeObjects.mouseOverTree = false

local woodSounds = {
    woodSound1 = love.audio.newSource("data/sfx/wood-sfx-1.ogg", "static")
}

local fallingSfx = love.audio.newSource("data/sfx/falling-tree.ogg", "static")
local powSfx = love.audio.newSource("data/sfx/pow-sfx.ogg", "static")

fallingSfx:setVolume(0.4)
woodSounds.woodSound1:setVolume(0.7)

local selectedShader = love.graphics.newShader("data/shaders/selectedshader.glsl")

local windowHeight = love.graphics.getHeight()

local cooldownBtwActions = 0.3
local cooldownTimer = cooldownBtwActions
local canCut = true

function treeObjects.update(stats, objectTransform, mousePressed, treeWidth, treeHeight, dt, height)
    local mouseOverThisFrame = false
    local mouseOverThisFrameCrop = false
    for key, value in pairs(treeObjects.objects) do
        local collision = mathUtils.checkCollision(objectTransform.x, objectTransform.y, objectTransform.width, objectTransform.height, value.x, value.y, treeWidth*value.width, treeHeight)
        if collision and mousePressed and not woodSounds.woodSound1:isPlaying() and value.health > 0 and value.canCrop then
            value.health = value.health - 1
            woodSounds.woodSound1:play()
            mouseOverThisFrame = true
        elseif collision then
            value.selected = true
            mouseOverThisFrame = true
            if value.canCrop then
                value.color = {79/255, 224/255, 79/255, 1}
            else
                value.color = {224/255, 52/255, 52/255, 1}
            end
        else
            value.selected = false
            value.color = {1, 1, 1, 1}
            if not mouseOverThisFrame then
                mouseOverThisFrame = false
            end
        end

        if value.health <= 0 then
            value.y = value.y + 0.4
            if value.grown >= 10 and value.canCrop then
                fallingSfx:play()
                value.canCrop = false
            end
            
            if value.y > height then
                if not powSfx:isPlaying() then
                    powSfx:play()
                    powSfx:play()
                end
                stats.woodsAmount = stats.woodsAmount + 2
                stats.seedsAmount = stats.seedsAmount + 2
                table.remove(treeObjects.objects, key)
            end
        end

        if value.growTimer > 0 then
            value.growTimer = value.growTimer - dt
        elseif value.growTimer <= 0 then
            value.growTimer = value.timeBtwGrow
            if stats.waterAmount <= 1 then
                return
            end
            
            if value.health > 0 and value.width <= 1 then
                value.width = value.width + 0.05
                value.height = value.height + 0.05
                value.x = value.x - 3
                value.y = height - (treeHeight * value.width)
                value.health = value.health + 0.5  
                value.grown = value.grown + 1

                stats.waterAmount = stats.waterAmount - value.timeBtwGrow / 10
            end
        end

        if value.grown >= 10 then
            value.canCrop = true
        end
    end

    if cooldownTimer > 0 then
        cooldownTimer = cooldownTimer - dt
    elseif cooldownTimer <= 0 then
        cooldownTimer = cooldownBtwActions
        canCut = true
    end

    treeObjects.mouseOverTree = mouseOverThisFrame
end

function treeObjects.draw(treeSprite)
    for key, value in pairs(treeObjects.objects) do
        if value.selected then
            love.graphics.setColor(value.color)
            love.graphics.draw(treeSprite, value.x, value.y, value.angle, value.width, value.height)
        else
            love.graphics.setColor(value.color)
            love.graphics.draw(treeSprite, value.x, value.y, value.angle, value.width, value.height)
        end
        

        --love.graphics.setColor(0, 0, 0, 1)
        --love.graphics.print("pine", value.x, value.y, 0, value.width, value.height)
    end
end

return treeObjects