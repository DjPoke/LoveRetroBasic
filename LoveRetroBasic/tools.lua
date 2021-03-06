function HelpManager()
	msg = nil
	
	-- afficher l'entête
	SetPenColor(EDITOR_PEN)
	SetPaperColor(EDITOR_PAPER)
	SetBorderColor(EDITOR_BORDER)

	ClearScreen()

	-- affichage de la page 0 de l'aide
	ClearScreen()
	if helpPage == 0 then
		SetPenColor(EDITOR_MENU)
		Locate(10, 1)
		PrintString("LoveRetroBasic HELP :")
		Locate(10, 2)
		PrintString("---------------------")
		SetPenColor(EDITOR_PEN)
		Locate(10, 6)
		PrintString("1. BASIC Commands")
		Locate(10, 7)
		PrintString("2. Keyboard Shortcuts")
		SetPenColor(EDITOR_UI)
		Locate(10, 11)
		PrintString("ESC : Back To Editor")
	elseif helpPage == 1 then
		SetPenColor(EDITOR_MENU)
		Locate(10, 1)
		PrintString("BASIC Commands :")
		Locate(10, 2)
		PrintString("----------------")
		SetPenColor(EDITOR_PEN)
		Locate(1, 4)
		PrintString("Commands list :")
		LineFeed()
		PrintList(commands)
		LineFeed()
		LineFeed()
		SetPenColor(EDITOR_UI)
		PrintString("ESC : Back To HELP menu")
	elseif helpPage == 2 then
		SetPenColor(EDITOR_MENU)
		Locate(10, 1)
		PrintString("Keyboard Shortcuts :")
		Locate(10, 2)
		PrintString("--------------------")
		SetPenColor(EDITOR_PEN)
		Locate(4, 6)
		PrintString("Up/Down arrowkeys - Page Up/Down")
		Locate(4, 7)
		PrintString("Return - Backspace")
		Locate(4, 9)
		PrintString("F1: Help - F5: Run - F6: Debug")
		Locate(4, 10)
		PrintString("Ctrl-S: Save - Ctrl-L: Load")
		Locate(4, 11)
		PrintString("Ctrl-I: Import to USB")
		Locate(4, 12)
		PrintString("Ctrl-E: Export to USB")
		Locate(4, 13)
		PrintString("Ctrl-D: Change export drive")
		Locate(4, 14)
		PrintString("Ctrl+Del: Clear - Ctrl+Q: Quit")
		SetPenColor(EDITOR_UI)
		Locate(10, 16)
		PrintString("ESC : Back To HELP menu")
	end
end

function SpriteEditor()
	msg = nil
	
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
	SetPenColor(EDITOR_MENU)
	Locate(13, 20)
	PrintStringN("   Keybard Shortcuts:")
	SetPenColor(EDITOR_UI)
	Locate(13, 21)
	PrintStringN("Ctrl-X/C/V/S     DEL ESC")
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
	msg = nil
	
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
	msg = nil
	
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
	msg = nil
	
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
