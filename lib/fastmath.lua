local fastmath = {}

function fastmath.printTable()
    
end

function fastmath.roundNumber(number, roundBy)
    return math.floor((number/roundBy) + 0.5) * roundBy
end

function fastmath.lerp(a,b,t) 
    return (1-t)*a + t*b 
end

function fastmath.checkCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
end

function fastmath.RGBToFloat(color)
    return color / 255
end

return fastmath