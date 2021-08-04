local playerStats = {
    seedsAmount = 1,
    woodsAmount = 0,
    waterAmount = 20
}

function playerStats.increaseStats(stats, amount)
    playerStats[stats] = playerStats[stats] + amount
end

return playerStats