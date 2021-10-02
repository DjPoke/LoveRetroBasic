-- créer la police de caractères
function InitSymbols()
	-- lire le fichier de redéfinition de caractères
	local list = {}
	local i = 0
	local a = 0
	
	for line in love.filesystem.lines("data/symbols.dat") do
		if i == 0 then
			a = tonumber(line)
		else
			list[i] = line
		end
		
		i = i + 1
		
		if i > 8 then
			i = 0
			
			local ret = Symbol(a, list)
		
			if ret ~= OK then
				return ret, a
			end
		end

	end
	
	return OK, nil
end

-- retour à l'éditeur
function ResetEditor()
	ShowCursor(false)
	
	currentRenderer = 0
	
	kb_buffer = ""

	-- reset des couleurs
	pen = DEFAULT_PEN
	paper = DEFAULT_PAPER
	gpen = DEFAULT_PEN
	border = DEFAULT_PAPER
	SetPaperColor(paper)
	SetPenColor(pen)
	SetGraphicPenColor(gpen)
	SetBorderColor(border)
	
	-- repositionner le curseur graphique
	MoveGraphicCursor(0, 0)
	
	-- effacer l'écran
	ClearScreen()
	
	-- reset des symboles
	for i = 0, 255 do
		for x = 0,7 do
			for y = 0,7 do
				sym[i][x][y] = rom[i][x][y]
			end
		end
	end
	
	ProgramCounter = 1
	
	-- effacer la VRAM
	for i = 1, #vram do
		vram[i] = nil
	end
	
	-- reset des sprites
	hardspr = {}
	for i = 0, MAX_HARD_SPRITES - 1 do
		hardspr[i] = {x = 0.0, y = 0.0, img = 0, hotspot = 0, scale = 0, transp = 0, on = false}
	end
	
	-- texte opaque
	SetTextTransparent(false)
end

-- retracer le contenu de l'éditeur
function RedrawEditor()
	local xc = cursor[1]
	local yc = cursor[2]
	
	ClearScreen()
	
	for y = 1, 25 do
		if ram[y + editorOffsetY] ~= nil then
			Locate(1, y)
			s = ram[y + editorOffsetY]
			if s ~= Chr(LF) then
				x = 0
				while x < 40 do
					local xf = x + editorOffsetX
					if xf <= #s then
						PrintChar(Asc(string.sub(s, xf + 1, xf + 1)), PRINT_NOT_CLIPPED_NO_SCROLL)
					else
						break
					end
					x = x + 1
				end
			end
		else
			return
		end
		
		SetEditorTextColor(y)
	end

	cursor[1] = xc
	cursor[2] = yc
	
	if editorOffsetX == 0 then
		Locate(xc, yc)
	end
end

-- remise à zéro de l'ordinateur virtuel
function Reset()
	ResetEditor()
	
	-- effacer la RAM
	for i = 0, MAX_RAM - 1 do
		ram[i] = ""
	end
	ramLine = 1
	
	-- effacer la VRAM
	for i = 1, #vram do
		vram[i] = nil
	end

	-- effacer la SPRAM
	for i = 0, MAX_SPRAM - 1 do
		spram[i] = 0
	end

	sprImgSize = {}
	for i = 0, MAX_SPRITES_IMAGES - 1 do
		sprImgSize[i] = {w = SPRITE_WIDTH, h = SPRITE_HEIGHT}
	end
	sprImgNumber = 0
	sprImgPage = 0

	-- reset des sprites hardware
	for i = 0, MAX_HARD_SPRITES - 1 do
		hardspr[i] = {x = 0.0, y = 0.0, img = 0, hotspot = 0, scale = 0, transp = 0, on = false}
	end
	
	-- reset du VBL
	gameVBL = DEFAULT_VBL
	VBL = false
	
	-- mettre le curseur texte en haut à gauche
	Locate(1, 1)
end
