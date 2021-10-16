local debugMode = true
local debugGame = require("src.debugGame")
--local trees = require("src.treeObjects")
--local menuUI = require("src.UI")
--local timer = require("src.timer")
--local playerStats = require("src.playerStats")

local fastmath = require("lib.fastmath")
local Vector3 = require("lib.vector")

local Entity = require("core.entity")
local resources = require("core.resource_loader")()

function love.load()
    local ent = Entity()
    
    resources:loadSprite("data/sprites")
    resources:loadSound("data/sfx")
    resources:loadMusic("data/music")
    resources:loadShader("data/shaders")
    resources:loadFont("data/font")
end

function love.update(dt)
    
end

function love.draw()
    local width, height = love.window.getDesktopDimensions()

    local xscale = 800
    local yscale = 600
    local scale = math.min(xscale, yscale)

    love.graphics.setColor(1, 1, 1, 1)

    -- UI DEBUG
    if debugMode then
        debugGame.draw()
    end
end

--#endregion