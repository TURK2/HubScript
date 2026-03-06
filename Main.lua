if not game:IsLoaded() then
    game.Loaded:Wait()
end

local KEY_URL = "https://raw.githubusercontent.com/TURK2/HubScript/main/KEY"
local GAME_URL = "https://raw.githubusercontent.com/TURK2/HubScript/main/Games/"
local DISCORD = "https://discord.com/invite/v3dAeMKp4N"

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local function GetKey()
    local data = game:HttpGet(KEY_URL)
    return data:gsub("%s+","")
end

local CorrectKey = GetKey()

local Window = Rayfield:CreateWindow({
    Name = "TURK HUB | Key System",
    LoadingTitle = "TURK HUB",
    LoadingSubtitle = "Authentication",
    Theme = "DarkBlue",
    DisableRayfieldPrompts = true
})

local Tab = Window:CreateTab("Key","lock")

local UserKey = ""

Tab:CreateInput({
    Name = "Enter Key",
    PlaceholderText = "Paste key",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        UserKey = text
    end
})

Tab:CreateButton({
    Name = "Verify Key",
    Callback = function()

        if UserKey == CorrectKey then

            Rayfield:Notify({
                Title = "Key Correct",
                Content = "Loading script...",
                Duration = 3
            })

            local id = game.PlaceId

            local success,script = pcall(function()
                return game:HttpGet(GAME_URL..id..".lua")
            end)

            if success and script then

                Rayfield:Destroy()

                loadstring(script)()

            else

                game.Players.LocalPlayer:Kick(
                "Game not supported.\nContact Discord: https://discord.com/invite/v3dAeMKp4N \n"..DISCORD
                )

            end

        else

            pcall(function()
                setclipboard(DISCORD)
            end)

            Rayfield:Notify({
                Title = "Invalid Key",
                Content = "Discord copied. Get key there.",
                Duration = 5
            })

        end

    end
})

Tab:CreateButton({
    Name = "Copy Discord",
    Callback = function()

        pcall(function()
            setclipboard(DISCORD)
        end)

        Rayfield:Notify({
            Title = "Copied",
            Content = "Discord copied",
            Duration = 3
        })

    end
})