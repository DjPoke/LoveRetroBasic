function HelpManager()
	-- affichage de la page 0 de l'aide
	ClearScreen()
	if helpPage == 0 then
		Locate(11, 1)
		PrintString("LoveRetroBasic HELP :")
		Locate(11, 2)
		PrintString("---------------------")
		Locate(10, 6)
		PrintString("1. BASIC Commands")
		Locate(10, 7)
		PrintString("2. Keyboard Shortcuts")
		Locate(10, 11)
		PrintString("ESC : Back To Editor")
	elseif helpPage == 1 then
		Locate(10, 1)
		PrintString("BASIC Commands :")
		Locate(10, 2)
		PrintString("----------------")
		Locate(1, 4)
		PrintString("Commands list :")
		LineFeed()
		PrintList(commands)
		LineFeed()
		LineFeed()
		PrintString("ESC : Back To HELP menu")
	elseif helpPage == 2 then
		Locate(10, 1)
		PrintString("Keyboard Shortcuts :")
		Locate(10, 2)
		PrintString("--------------------")
		Locate(4, 6)
		PrintString("Up/Down arrowkeys - Page Up/Down")
		Locate(4, 7)
		PrintString("Return - Backspace")
		Locate(10, 10)
		PrintString("ESC : Back To HELP menu")
	end
end

function SpriteEditor()
	-- afficher l'entête
	SetPenColor(1)
	SetPaperColor(0)
	SetBorderColor(48)

	ClearScreen()

	Locate(1, 1)
	SetPenColor(DEFAULT_PEN)
	PrintStringN("SPRITE EDITOR")
	PrintString("-------------")
	Locate(1, 4)
	SetPenColor(1)
	PrintStringN("Sprite:" .. tostring(sprImgNumber))
	PrintStringN("Page  :" .. tostring(sprImgPage))
	Locate(1, 7)
	PrintStringN("[C]opy [P]aste")
	PrintString("[S]ave [ESC]")
	Locate(1, 19)
	SetPenColor(DEFAULT_PEN)
	Locate(1, 21)
	PrintString("<=S=> <=P=>")
	
	-- dessiner la palette
	for y = 0, 7 do
		for x = 0, 7 do
			SetGraphicPenColor(x + (y * 8))
			DrawRectangle(x * 8, 72 + (y * 8), 8, 8, 1)
		end
	end

	drawingPen = 1
	drawingPaper = 0
	
	-- dessiner les couleurs courantes
	SetGraphicPenColor(1)
	DrawRectangle(71, 71, 18, 18, 1)
	DrawRectangle(71, 95, 18, 18, 1)

	SetGraphicPenColor(drawingPen)
	DrawRectangle(72, 72, 16, 16, 1)
	
	SetGraphicPenColor(drawingPaper)
	DrawRectangle(72, 96, 16, 16, 1)
	
	RedrawEditedSprite()
	RedrawSpritesLine()
	RedrawCurrentSprite()
end

function LevelEditor()
	-- afficher l'entête
	ClearScreen()
	Locate(1, 1)
	PrintStringN("LEVEL EDITOR")
	PrintString("------------")
	Locate(1, 6)
end

function NoiseEditor()
	-- afficher l'entête
	ClearScreen()
	Locate(1, 1)
	PrintStringN("NOISE EDITOR")
	PrintString("------------")
	Locate(1, 6)
end

function Tracker()
	-- afficher l'entête
	ClearScreen()
	Locate(1, 1)
	PrintStringN("TRACKER")
	PrintString("-------")
	Locate(1, 6)
end
