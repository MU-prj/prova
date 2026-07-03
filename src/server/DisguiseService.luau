--!strict
-- Travestimenti e manichini: applica gli outfit, spawna gli NPC e
-- gestisce il congelamento. Giocatori e NPC ricevono la stessa
-- HumanoidDescription "nuda" (solo colori), quindi sono indistinguibili.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

local Outfits = require(ReplicatedStorage.Shared.Outfits)
local Remotes = require(ReplicatedStorage.Shared.Remotes)

local DisguiseService = {}

local congelamento = Remotes.get("Congelamento")

local NOME_NPC = "ManichinoNpc"
local NOME_CARTELLA_NPC = "Manichini"

local function descrizioneDaOutfit(outfit: Outfits.Outfit): HumanoidDescription
	-- Una descrizione vuota rimuove anche cappelli e vestiti veri del
	-- giocatore: restano solo i colori, il look "manichino".
	local descrizione = Instance.new("HumanoidDescription")
	descrizione.HeadColor = outfit.testa
	descrizione.TorsoColor = outfit.torso
	descrizione.LeftArmColor = outfit.braccia
	descrizione.RightArmColor = outfit.braccia
	descrizione.LeftLegColor = outfit.gambe
	descrizione.RightLegColor = outfit.gambe
	return descrizione
end

local function cartellaNpc(): Folder
	local esistente = Workspace:FindFirstChild(NOME_CARTELLA_NPC)
	if esistente ~= nil and esistente:IsA("Folder") then
		return esistente
	end
	local nuova = Instance.new("Folder")
	nuova.Name = NOME_CARTELLA_NPC
	nuova.Parent = Workspace
	return nuova
end

function DisguiseService.applicaOutfit(player: Player, outfit: Outfits.Outfit)
	local personaggio = player.Character
	if personaggio == nil then
		return
	end
	local umanoide = personaggio:FindFirstChildOfClass("Humanoid")
	if umanoide == nil then
		return
	end
	umanoide:ApplyDescription(descrizioneDaOutfit(outfit))
end

function DisguiseService.spawnManichini(posizioni: { Vector3 })
	local cartella = cartellaNpc()
	local rng = Random.new()
	for _, posizione in posizioni do
		local outfit = Outfits[rng:NextInteger(1, #Outfits)]
		local modello = Players:CreateHumanoidModelFromDescription(
			descrizioneDaOutfit(outfit),
			Enum.HumanoidRigType.R15
		)
		modello.Name = NOME_NPC

		-- Gli NPC non devono muoversi né animarsi: via ogni script.
		for _, discendente in modello:GetDescendants() do
			if discendente:IsA("BaseScript") then
				discendente:Destroy()
			end
		end

		-- In piedi sulla pedana, con rotazione casuale.
		local rotazione = CFrame.Angles(0, math.rad(rng:NextInteger(0, 359)), 0)
		modello:PivotTo(CFrame.new(posizione + Vector3.new(0, 3, 0)) * rotazione)

		local radice = modello:FindFirstChild("HumanoidRootPart")
		if radice ~= nil and radice:IsA("BasePart") then
			radice.Anchored = true
		end

		modello.Parent = cartella
	end
end

function DisguiseService.eManichinoNpc(modello: Model): boolean
	return modello.Name == NOME_NPC and modello:GetAttribute("Abbattuto") ~= true
end

function DisguiseService.abbattiNpc(modello: Model)
	-- L'NPC accusato ingiustamente crolla a terra: è la clip del round.
	modello:SetAttribute("Abbattuto", true)
	for _, discendente in modello:GetDescendants() do
		if discendente:IsA("BasePart") then
			discendente.Anchored = false
		end
	end
	local umanoide = modello:FindFirstChildOfClass("Humanoid")
	if umanoide ~= nil then
		umanoide.Health = 0
	end
	Debris:AddItem(modello, 5)
end

function DisguiseService.rimuoviManichini()
	cartellaNpc():ClearAllChildren()
end

function DisguiseService.congela(player: Player, congelato: boolean)
	local personaggio = player.Character
	if personaggio == nil then
		return
	end
	local radice = personaggio:FindFirstChild("HumanoidRootPart")
	if radice ~= nil and radice:IsA("BasePart") then
		radice.Anchored = congelato
	end
	-- L'idle di default tradirebbe i giocatori: le animazioni le ferma
	-- il client, che è il proprietario dell'Animator.
	congelamento:FireClient(player, congelato)
end

return DisguiseService
