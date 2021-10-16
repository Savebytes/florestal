function love.conf(t)
    t.window.title = "Game Jaaj 6"
    t.window.fullscreen = false
    t.window.width = 800
    t.window.height = 600
    t.window.vsync = 0
    t.window.resizable = false
    t.window.minwidth = 320
    t.window.minheight = 240 

    t.modules.joystick = false
    t.modules.touch = false
    t.modules.physics = false
    t.modules.thread = false

    t.modules.video = true

    t.identity = "florestal_savedata"
end