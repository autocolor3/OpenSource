local replicated_storage = game:GetService("ReplicatedStorage")
local virtual_input = Instance.new("VirtualInputManager")
local players = game:GetService("Players")
local local_player = players.LocalPlayer
local player_gui = local_player.PlayerGui
local remotes = replicated_storage:WaitForChild("Remotes")
local backpack = local_player:WaitForChild("Backpack")
local screen = workspace.CurrentCamera.ViewportSize
local pos = Vector2.new(screen.X / 2, screen.Y / 2)
local x = math.floor(pos.X)
local y = math.floor(pos.Y)

for _, t in backpack:GetChildren() do
	if t:IsA("Instance") and string.find(t.Name, "Shovel") then
		shovel = t
	end
end
pcall(function()
	remotes.Backpack_Equip:FireServer(shovel)
end)
while true do
	virtual_input:SendMouseButtonEvent(x, y, Enum.UserInputType.MouseButton1.Value, true, player_gui, 1)
	virtual_input:SendMouseButtonEvent(x, y, Enum.UserInputType.MouseButton1.Value, false, player_gui, 1)
	task.wait(1.5)
	game:GetService("ReplicatedStorage").Remotes.Dig_Finished:FireServer(0, {})
end
