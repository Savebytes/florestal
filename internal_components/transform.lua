local transformComponent = {}

function transformComponent.new(x, y)
    local transform = {}
    transform.name = "transform"
    transform.x = x
    transform.y = y

    function transform.start()
        
    end

    return transform
end

return transformComponent