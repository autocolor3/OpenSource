--[[

    ? Grow a garden ?
    - UI by rayfield
    - @_color3 | everything else

        Excuse the messy code, im half asleep.
        This release is quite buggy, use it as a base.   
           
]]

--// Variables
repeat task.wait(1.5) until game:IsLoaded()
local Players = game:GetService("Players")
local Self = Players.LocalPlayer
local Name = Self.DisplayName ~= "" and Self.DisplayName or Self.Name
local Char = Self.Character
local Humanoid = Char.HumanoidRootPart
local wait = function(d) 
    task.wait(d or .5) 
end
local SellPosition = workspace.MapDecorations:GetChildren()[3].Part.CFrame
local Events = game:GetService("ReplicatedStorage").GameEvents

--// Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Grow A Garden",
   Icon = 0,
   LoadingTitle = "Serotonin",
   LoadingSubtitle = "Public Autofarm",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = Enum.KeyCode.RightShift,
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "Serotonin",
      FileName = "Serotonin"
   },

   Discord = {
      Enabled = true,
      Invite = "fEP84re8mg", 
      RememberJoins = false
   }
})
local elapsed = 0

--// Tabs
local a = Window:CreateTab("Options")
local b = Window:CreateTab("Other")
local one = a:CreateSection("Configuration")
local two = b:CreateSection("Stat Viewer")

--// Stats
local Timer = b:CreateLabel("")
task.spawn(function()
while true do
    task.wait(1)
    elapsed += 1
    Timer:Set("Session duration: " .. elapsed .. "s")
end	
end)

--// Misc
local three = b:CreateSection("Misc")
local ServerHop = b:CreateButton({
    Name = "Server hop",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end,
})
local Rejoin = b:CreateButton({
    Name = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end,
})

--// Find local players farm
local FindFarm = function()
	for _, farm in ipairs(workspace.Farm:GetChildren()) do
		local label = farm.Sign and farm.Sign.Core_Part and farm.Sign.Core_Part.SurfaceGui and farm.Sign.Core_Part.SurfaceGui.TextLabel
		if label and label.Text:find(Name) then
			return farm
		end
	end
	return nil
end
getgenv().farm = FindFarm()

--// Teleport to plot
local GotoPlot = function(plot)
	local locations = farm.Important and farm.Important.Plant_Locations
	if locations then
		local plots = locations:GetChildren()
		local a = plots[1] and plots[1].Position
		local b = plots[2] and plots[2].Position
		if plot == "A" then
			Humanoid.CFrame = CFrame.new(a)
		else
			Humanoid.CFrame = CFrame.new(b)
		end
	end
end
--
local Plot = a:CreateDropdown({
   Name = "Goto plot",
   Options = {"A","B"},
   CurrentOption = {""},
   MultipleOptions = false,
   Flag = "PlotChoice",
   Callback = function(v)
        GotoPlot(type(v) == "table" and v[1] or v)
   end,
})

--// Crop Selection
local CN = a:CreateInput({
   Name = "Plant: ",
   CurrentValue = "",
   PlaceholderText = "",
   RemoveTextAfterFocusLost = false,
   Flag = "CropSelection",
   Callback = function(v)
        SelectedCrop = v
   end,
})

--// Crop amount
local CA = a:CreateInput({
   Name = "Amount: ",
   CurrentValue = "10",
   PlaceholderText = "10",
   RemoveTextAfterFocusLost = false,
   Flag = "CropAmount",
   Callback = function(v)
        CropAmount = v
   end,
})

--// Buy seeds
local BuySeeds = function(type, amount)
    local num = amount or 1
    for i = 1, num do
        wait()
        Events.BuySeedStock:FireServer(type or "Carrot")
    end
end
--
local PurchaseButton = a:CreateButton({
    Name = "Buy seeds",
    Callback = function()
        BuySeeds(SelectedCrop, CropAmount);
    end,
})

--// Plant seeds
local PlantSeeds = function(type, amount)
    local num = amount or 1
    for i = 1, num do
        wait()
        Events.Plant_RE:FireServer(table.unpack({
            Humanoid.Position, 
            type or "Carrot"
        }))
    end
end
--
local PlantButton = a:CreateButton({
    Name = "Plant seeds",
    Callback = function()
        PlantSeeds(SelectedCrop, CropAmount);
    end,
})

--// Harvest crops
local HarvestCrops = function(type)
	local plants = farm.Important and farm.Important.Plants_Physical
	for _, plant in ipairs(plants:GetChildren()) do
		if plant.Name == type then
			for _, part in ipairs(plant:GetDescendants()) do
				if part:IsA("ProximityPrompt") then
					local root = part.Parent:IsA("BasePart") and part.Parent or plant:FindFirstChildWhichIsA("BasePart")
					if root then
						Humanoid.CFrame = CFrame.new(root.Position)
						wait()
						fireproximityprompt(part)
					end
				end
			end
		end
	end
end
--
local HarvestButton = a:CreateButton({
    Name = "Harvest crops",
    Callback = function()
        HarvestCrops(SelectedCrop)
    end,
})

--// Sell inventory
local SellInventory = function()
    local oldPos = Humanoid.CFrame
    Humanoid.CFrame = SellPosition; wait()
    Events.Sell_Inventory:FireServer()
    wait(); Humanoid.CFrame = oldPos
end
--
local SellButton = a:CreateButton({
    Name = "Sell inventory",
    Callback = function()
        SellInventory()
    end,
})
