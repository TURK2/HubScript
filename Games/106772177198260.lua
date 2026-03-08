repeat task.wait() until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- toggles
local AutoReel = false
local AutoCollect = false
local AutoRodMutation = false
local AutoSell = false
local AutoPower = false
local AutoCatch = false
local AutoBuyRod = false
local AutoRebirth = false

local DeleteSetting = {
	Uncommon = false,
	Rare = false,
	Epic = false,
	Legendary = false,
	Mythic = false,
	Godly = false,
	Divine = false,
	Secret = false
}

-------------------------------------------------

local Window = Rayfield:CreateWindow({
	Name = "Fishing Hub",
	LoadingTitle = "Auto Farm",
	LoadingSubtitle = "Script",
	ConfigurationSaving = {Enabled = false}
})

local TabEN = Window:CreateTab("Main EN",4483362458)
local TabTH = Window:CreateTab("Main TH",4483362458)

-------------------------------------------------
-- Auto Reel
-------------------------------------------------

task.spawn(function()
	while true do
		if AutoReel then
			ReplicatedStorage.RemoteHandler.Fishing:FireServer("Caught",2)
		end
		task.wait(0.05)
	end
end)

-------------------------------------------------
-- Auto Collect
-------------------------------------------------

task.spawn(function()
	while true do
		if AutoCollect then
			for i = 1,30 do
				ReplicatedStorage.RemoteHandler.Collect:FireServer("Plot"..i)
				task.wait(0.05)
			end
		end
		task.wait(0.2)
	end
end)

-------------------------------------------------
-- Auto Power
-------------------------------------------------

task.spawn(function()
	while true do
		if AutoPower then
			ReplicatedStorage.RemoteHandler.Upgrade:FireServer("power1")
		end
		task.wait(0.1)
	end
end)

-------------------------------------------------
-- Auto Catch
-------------------------------------------------

task.spawn(function()
	while true do
		if AutoCatch then
			ReplicatedStorage.RemoteHandler.Upgrade:FireServer("catch1")
		end
		task.wait(0.1)
	end
end)

-------------------------------------------------
-- Auto Rod Mutation
-------------------------------------------------

task.spawn(function()
	while true do
		if AutoRodMutation then
			for i = 1,7 do
				ReplicatedStorage.RemoteHandler.RodMutation:FireServer("Buy","RodMutation"..i)
				task.wait(0.5)
			end
		end
		task.wait(2)
	end
end)

-------------------------------------------------
-- Auto Buy Rod
-------------------------------------------------

task.spawn(function()
	while true do
		if AutoBuyRod then
			for i = 1,17 do
				ReplicatedStorage.RemoteHandler.FishingRod:FireServer("Buy","FishingRod"..i)
				task.wait(0.5)
			end
		end
		task.wait(3)
	end
end)

-------------------------------------------------
-- Auto Rebirth
-------------------------------------------------

task.spawn(function()
	while true do
		if AutoRebirth then
			ReplicatedStorage.RemoteHandler.Rebirth:FireServer()
		end
		task.wait(1)
	end
end)

-------------------------------------------------
-- Auto Sell
-------------------------------------------------

task.spawn(function()
	while true do
		if AutoSell then
			ReplicatedStorage.RemoteHandler.SellMultiple:FireServer(DeleteSetting)
		end
		task.wait(0.5)
	end
end)

-------------------------------------------------
-- EN UI
-------------------------------------------------

TabEN:CreateDropdown({
	Name = "Fish To Delete",
	Options = {"Uncommon","Rare","Epic","Legendary","Mythic","Godly","Divine","Secret"},
	CurrentOption = {},
	MultipleOptions = true,
	Callback = function(options)

		for k in pairs(DeleteSetting) do
			DeleteSetting[k] = false
		end

		for _,v in pairs(options) do
			DeleteSetting[v] = true
		end

	end
})

TabEN:CreateToggle({
	Name = "Auto Sell Selected Fish",
	CurrentValue = false,
	Callback = function(v)
		AutoSell = v
	end
})

TabEN:CreateToggle({
	Name = "Auto Reel",
	CurrentValue = false,
	Callback = function(v)
		AutoReel = v
	end
})

TabEN:CreateToggle({
	Name = "Auto Collect",
	CurrentValue = false,
	Callback = function(v)
		AutoCollect = v
	end
})

TabEN:CreateToggle({
	Name = "Auto Buy Power",
	CurrentValue = false,
	Callback = function(v)
		AutoPower = v
	end
})

TabEN:CreateToggle({
	Name = "Auto Buy Catch",
	CurrentValue = false,
	Callback = function(v)
		AutoCatch = v
	end
})

TabEN:CreateToggle({
	Name = "Auto Buy RodMutation",
	CurrentValue = false,
	Callback = function(v)
		AutoRodMutation = v
	end
})

TabEN:CreateToggle({
	Name = "Auto Buy FishingRod",
	CurrentValue = false,
	Callback = function(v)
		AutoBuyRod = v
	end
})

TabEN:CreateToggle({
	Name = "Auto Rebirth",
	CurrentValue = false,
	Callback = function(v)
		AutoRebirth = v
	end
})

-------------------------------------------------
-- TH UI
-------------------------------------------------

TabTH:CreateToggle({
	Name = "รีลปลาอัตโนมัติ",
	CurrentValue = false,
	Callback = function(v)
		AutoReel = v
	end
})

TabTH:CreateToggle({
	Name = "เก็บเงิน ออโต้",
	CurrentValue = false,
	Callback = function(v)
		AutoCollect = v
	end
})

TabTH:CreateToggle({
	Name = "ซื้อ Power อัตโนมัติ",
	CurrentValue = false,
	Callback = function(v)
		AutoPower = v
	end
})

TabTH:CreateToggle({
	Name = "ซื้อ Catch อัตโนมัติ",
	CurrentValue = false,
	Callback = function(v)
		AutoCatch = v
	end
})

TabTH:CreateToggle({
	Name = "ซื้อ Mutation เบ็ด",
	CurrentValue = false,
	Callback = function(v)
		AutoRodMutation = v
	end
})

TabTH:CreateToggle({
	Name = "ซื้อเบ็ด ออโต้",
	CurrentValue = false,
	Callback = function(v)
		AutoBuyRod = v
	end
})

TabTH:CreateToggle({
	Name = "รีเบิร์ดอัตโนมัติ",
	CurrentValue = false,
	Callback = function(v)
		AutoRebirth = v
	end
})

TabTH:CreateToggle({
	Name = "ขายปลาอัตโนมัติ",
	CurrentValue = false,
	Callback = function(v)
		AutoSell = v
	end
})