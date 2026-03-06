-- wait game
if not game:IsLoaded() then
    game.Loaded:Wait()
end

if getgenv().TURK_HUB then
    return
end
getgenv().TURK_HUB = true

local Players = game:GetService("Players")

-- UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- links
local Discord = "https://discord.com/invite/v3dAeMKp4N"
local KeyURL = "https://raw.githubusercontent.com/TURK2/HUB/main/KEY"
local LoaderURL = "https://raw.githubusercontent.com/TURK2/HUB/main/Run/Loader.lua"

pcall(function()
    setclipboard(Discord)
end)

-- get keys
local function GetKeys()

    local data = game:HttpGet(KeyURL)
    local keys = {}

    for line in string.gmatch(data,"[^\r\n]+") do
        table.insert(keys,line)
    end

    return keys
end

local ValidKeys = GetKeys()

-- UI
local Window = Rayfield:CreateWindow({
    Name = "TURK HUB | Key System",
    LoadingTitle = "TURK HUB",
    LoadingSubtitle = "Authentication",
    Theme = "DarkBlue"
})

local Tab = Window:CreateTab("Key","lock")

local UserKey = ""

Tab:CreateInput({
    Name = "Enter Key",
    PlaceholderText = "Paste key here",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        UserKey = text
    end
})

Tab:CreateButton({
    Name = "Submit Key",
    Callback = function()

        local valid = false

        for _,k in pairs(ValidKeys) do
            if UserKey == k then
                valid = true
                break
            end
        end

        if not valid then

            pcall(function()
                setclipboard(Discord)
            end)

            Rayfield:Notify({
                Title = "Invalid Key",
                Content = "Join our Discord to get the key (copied)",
                Duration = 5
            })

            return
        end

        -- key correct
        Rayfield:Notify({
            Title = "Access Granted",
            Content = "Loading...",
            Duration = 3
        })

        wait(1)

        loadstring(game:HttpGet(LoaderURL))()

        Rayfield:Destroy()

    end
})

Tab:CreateButton({
    Name = "Copy Discord",
    Callback = function()

        pcall(function()
            setclipboard(Discord)
        end)

        Rayfield:Notify({
            Title = "Copied",
            Content = "Discord link copied",
            Duration = 3
        })

    end
}) 