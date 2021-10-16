local Class = require("lib.middleclass")

local ResourceLoader = Class("ResourceLoader")

function ResourceLoader:initialize()
    self.sprites = {}
    self.sounds = {}
    self.musics = {}
    self.fonts = {}
    self.shaders = {}
end

function ResourceLoader:loadSprite(path)
    local files = love.filesystem.getDirectoryItems(path)
    for key, value in ipairs(files) do
        local file = files[key]
        local fileName = file:match("(.+)%.png$")

        if fileName ~= nil then
            local image = love.graphics.newImage(path .. "/"..file)
            self.sprites[fileName] = image
        end
    end
end

function ResourceLoader:loadSound(path)
    local files = love.filesystem.getDirectoryItems(path)
    for key, value in ipairs(files) do
        local file = files[key]
        local fileName = file:match("(.+)%.wav$") or file:match("(.+)%.ogg$")

        if fileName ~= nil then
            local info = love.filesystem.getInfo(path .. "/" .. file, 'file')
            local staticOrStream = (info and info.size and info.size < 5e5) and "static" or "stream"
            local sound = love.audio.newSource(path .. "/"..file, staticOrStream)
            
            self.sounds[fileName] = sound
        end
    end
end

function ResourceLoader:loadMusic(path)
    local files = love.filesystem.getDirectoryItems(path)
    for key, value in ipairs(files) do
        local file = files[key]
        local fileName = file:match("(.+)%.wav$") or file:match("(.+)%.ogg$")

        if fileName ~= nil then
            local music = love.audio.newSource(path .. "/"..file, "stream")
            self.musics[fileName] = music
        end
    end
end

function ResourceLoader:loadFont(path)
    local files = love.filesystem.getDirectoryItems(path)
    for key, value in ipairs(files) do
        local file = files[key]
        local fileName = file:match("(.+)%.ttf$")

        if fileName ~= nil then
            local font = love.graphics.newFont(path .. "/"..file)
            self.fonts[fileName] = font
        end
    end
end

function ResourceLoader:loadShader(path)
    local files = love.filesystem.getDirectoryItems(path)
    for key, value in ipairs(files) do
        local file = files[key]
        local fileName = file:match("(.+)%.glsl$")

        if fileName ~= nil then
            local shader = love.graphics.newShader(path .. "/"..file)
            self.shaders[fileName] = shader
        end
    end
end

return ResourceLoader