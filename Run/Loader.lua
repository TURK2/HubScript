local PlaceID = game.PlaceId

local BaseURL = "https://raw.githubusercontent.com/TURK2/HubScript/main/Games/"
local ScriptURL = BaseURL .. PlaceID .. ".lua"

local success,err = pcall(function()
    loadstring(game:HttpGet(ScriptURL))()
end)

if not success then
    warn("Game script not found for PlaceId:", PlaceID)
end