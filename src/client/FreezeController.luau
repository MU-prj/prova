--!strict
-- Congelamento: il server àncora il personaggio, ma le animazioni sono
-- di proprietà del client — le ferma lui, così il giocatore assume la
-- stessa posa rigida dei manichini NPC.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"))

local player = Players.LocalPlayer
local congelamento = Remotes.get("Congelamento")

congelamento.OnClientEvent:Connect(function(congelato: boolean)
	if typeof(congelato) ~= "boolean" then
		return
	end
	local personaggio = player.Character
	if personaggio == nil then
		return
	end

	local animate = personaggio:FindFirstChild("Animate")
	if animate ~= nil and animate:IsA("LocalScript") then
		animate.Disabled = congelato
	end

	if congelato then
		local umanoide = personaggio:FindFirstChildOfClass("Humanoid")
		if umanoide ~= nil then
			local animatore = umanoide:FindFirstChildOfClass("Animator")
			if animatore ~= nil then
				for _, traccia in animatore:GetPlayingAnimationTracks() do
					traccia:Stop(0)
				end
			end
		end
	end
end)

return true
