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
	SetPenColor(EDITOR_PEN)
	SetPaperColor(EDITOR_PAPER)
	SetBorderColor(EDITOR_BORDER)

	ClearScreen()

	Locate(1, 1)
	SetPenColor(EDITOR_MENU)
	PrintStringN("SPRITE EDITOR")
	PrintString("-------------")
	Locate(1, 4)
	SetPenColor(EDITOR_PEN)
	PrintStringN("Sprite:" .. tostring(sprImgNumber))
	PrintStringN("Page  :" .. tostring(sprImgPage))
	Locate(13, 21)
	PrintStringN("Ctrl-X/C/V/S/I/E DEL ESC")
	Locate(1, 21)
	SetPenColor(EDITOR_UI)
	PrintString(Chr(159) .."-S-" .. Chr(160) .. " " .. Chr(159) .. "-P-" .. Chr(160))
	SetPenColor(EDITOR_MENU)
	Locate(3, 21)
	PrintString("S")
	Locate(9, 21)
	PrintString("P")
	
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
	SetGraphicPenColor(EDITOR_UI)
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
	SetPenColor(EDITOR_PEN)
	SetPaperColor(EDITOR_PAPER)
	SetBorderColor(EDITOR_BORDER)

	ClearScreen()

	Locate(1, 1)
	SetPenColor(EDITOR_MENU)
	PrintStringN("LEVEL EDITOR")
	PrintString("------------")
end

function NoiseEditor()
	-- afficher l'entête
	SetPenColor(EDITOR_PEN)
	SetPaperColor(EDITOR_PAPER)
	SetBorderColor(EDITOR_BORDER)

	ClearScreen()

	Locate(1, 1)
	SetPenColor(EDITOR_MENU)
	PrintStringN("NOISE EDITOR")
	PrintString("------------")
end

function Tracker()
	-- afficher l'entête
	SetPaperColor(EDITOR_PAPER)
	SetBorderColor(EDITOR_BORDER)
	
	ClearScreen()

	SetPenColor(EDITOR_MENU)
	Locate(62, 1)
	PrintString("TRACKER")
	Locate(62, 2)
	PrintString("-------")
end
