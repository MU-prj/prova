--!strict
-- Input del cercatore: durante la Caccia un click (o un tap) accusa il
-- manichino puntato. La validazione vera (raggio, accuse, debounce) è
-- del server: qui si manda solo il bersaglio.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Fasi = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Fasi"))
local Remotes = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Remotes"))

local player = Players.LocalPlayer

local phaseChanged = Remotes.get("PhaseChanged")
local accusa = Remotes.get("Accusa")

local attivo = false

phaseChanged.OnClientEvent:Connect(function(fase: string, dettagli: { [string]: any })
	attivo = fase == Fasi.Caccia and dettagli.cercatore == player.Name
end)

UserInputService.InputBegan:Connect(function(input: InputObject, processato: boolean)
	if processato or not attivo then
		return
	end
	local tipo = input.UserInputType
	if tipo ~= Enum.UserInputType.MouseButton1 and tipo ~= Enum.UserInputType.Touch then
		return
	end

	local camera = Workspace.CurrentCamera
	if camera == nil then
		return
	end
	local raggio = camera:ScreenPointToRay(input.Position.X, input.Position.Y)

	local parametri = RaycastParams.new()
	local personaggio = player.Character
	if personaggio ~= nil then
		parametri.FilterDescendantsInstances = { personaggio }
	end
	parametri.FilterType = Enum.RaycastFilterType.Exclude

	local esito = Workspace:Raycast(raggio.Origin, raggio.Direction * 300, parametri)
	if esito == nil then
		return
	end
	local modello = esito.Instance:FindFirstAncestorOfClass("Model")
	if modello ~= nil then
		accusa:FireServer(modello)
	end
end)

return true
