local rendererComponent = {}

function rendererComponent.new(_sprite, size)
    local render = {}
    render.name = "renderer"
    render.sprite = _sprite
    render.size = size or 1

    function render:draw(transform)
        love.graphics.draw(render.sprite, transform.x, transform.y, 0, render.size, render.size) -- love.graphics.draw(sprite,  windowWidth / 2 - tutorialWidth / 2, 10, 0, 1, 1)
    end

    return render
end

return rendererComponent