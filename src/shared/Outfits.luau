--!strict
-- Il guardaroba: ogni outfit è una combinazione di colori applicata sia
-- ai nascosti sia ai manichini NPC, così da renderli indistinguibili.

export type Outfit = {
	nome: string,
	testa: Color3,
	torso: Color3,
	braccia: Color3,
	gambe: Color3,
}

local Outfits: { Outfit } = {
	{
		nome = "Pomodoro",
		testa = Color3.fromRGB(230, 87, 60),
		torso = Color3.fromRGB(196, 40, 28),
		braccia = Color3.fromRGB(196, 40, 28),
		gambe = Color3.fromRGB(105, 26, 20),
	},
	{
		nome = "Puffo",
		testa = Color3.fromRGB(128, 187, 219),
		torso = Color3.fromRGB(13, 105, 172),
		braccia = Color3.fromRGB(13, 105, 172),
		gambe = Color3.fromRGB(255, 255, 255),
	},
	{
		nome = "Banana",
		testa = Color3.fromRGB(245, 205, 48),
		torso = Color3.fromRGB(245, 205, 48),
		braccia = Color3.fromRGB(226, 155, 64),
		gambe = Color3.fromRGB(226, 155, 64),
	},
	{
		nome = "Fantasma",
		testa = Color3.fromRGB(242, 243, 243),
		torso = Color3.fromRGB(242, 243, 243),
		braccia = Color3.fromRGB(205, 205, 205),
		gambe = Color3.fromRGB(205, 205, 205),
	},
	{
		nome = "Menta",
		testa = Color3.fromRGB(177, 229, 166),
		torso = Color3.fromRGB(75, 151, 75),
		braccia = Color3.fromRGB(75, 151, 75),
		gambe = Color3.fromRGB(40, 96, 40),
	},
	{
		nome = "Notte",
		testa = Color3.fromRGB(99, 95, 98),
		torso = Color3.fromRGB(27, 42, 53),
		braccia = Color3.fromRGB(27, 42, 53),
		gambe = Color3.fromRGB(17, 17, 17),
	},
	{
		nome = "Sabbia",
		testa = Color3.fromRGB(215, 197, 154),
		torso = Color3.fromRGB(180, 128, 87),
		braccia = Color3.fromRGB(215, 197, 154),
		gambe = Color3.fromRGB(124, 92, 70),
	},
	{
		nome = "Lava",
		testa = Color3.fromRGB(245, 136, 51),
		torso = Color3.fromRGB(218, 60, 30),
		braccia = Color3.fromRGB(245, 205, 48),
		gambe = Color3.fromRGB(105, 26, 20),
	},
	{
		nome = "Robot",
		testa = Color3.fromRGB(163, 162, 165),
		torso = Color3.fromRGB(99, 95, 98),
		braccia = Color3.fromRGB(163, 162, 165),
		gambe = Color3.fromRGB(27, 42, 53),
	},
	{
		nome = "Confetto",
		testa = Color3.fromRGB(255, 201, 201),
		torso = Color3.fromRGB(255, 102, 204),
		braccia = Color3.fromRGB(255, 201, 201),
		gambe = Color3.fromRGB(170, 0, 170),
	},
	{
		nome = "Alieno",
		testa = Color3.fromRGB(117, 240, 87),
		torso = Color3.fromRGB(58, 125, 21),
		braccia = Color3.fromRGB(117, 240, 87),
		gambe = Color3.fromRGB(58, 125, 21),
	},
	{
		nome = "Regale",
		testa = Color3.fromRGB(215, 197, 154),
		torso = Color3.fromRGB(98, 37, 209),
		braccia = Color3.fromRGB(245, 205, 48),
		gambe = Color3.fromRGB(98, 37, 209),
	},
}

return Outfits
