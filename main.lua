local debugMode = true
local debugGame = require("src.debugGame")
--local trees = require("src.treeObjects")
--local menuUI = require("src.UI")
--local timer = require("src.timer")
--local playerStats = require("src.playerStats")
local Class = require("lib.middleclass")

local fastmath = require("lib.fastmath")
local Vector3 = require("lib.vector")

local Entity = require("core.entity")
local gameWorld = require("core.world_manager")()
local resources = require("core.resource_loader")()

-- Entities


function love.load()
    love.mouse.setVisible(false)

    resources:loadSprite("data/sprites")
    resources:loadSound("data/sfx")
    resources:loadMusic("data/music")
    resources:loadShader("data/shaders")
    resources:loadFont("data/font")

    resources.musics.main_music:play()
    resources.musics.main_music:setVolume(0.5)
    resources.musics.main_music:setLooping(true)


    gameWorld:load()
end

function love.update(dt)
    gameWorld:update(dt)
end

function love.draw()
    local width, height = love.window.getDesktopDimensions()

    local xscale = 800
    local yscale = 600
    local scale = math.min(xscale, yscale)

    love.graphics.setColor(1, 1, 1, 1)
    gameWorld:draw()

    -- UI DEBUG
    if debugMode then
        debugGame.draw()
    end
end

--#endregion