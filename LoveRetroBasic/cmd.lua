-- commande 'ABS'
cmd["ABS"].fn = function(lst)
	return OK, Abs(Val(lst[1]))
end

-- commande 'ASC'
cmd["ASC"].fn = function(lst)
	return OK, Asc(lst[1])
end

-- commande 'BIN$'
cmd["BIN$"].fn = function(lst)
	return OK, "\"" .. Bin(lst[1]) .. "\""
end

-- commande 'BORDER'
cmd["BORDER"].fn = function(lst)
	v, e = EvalInteger(lst[1])
	
	if e ~= OK then return ERR_SYNTAX_ERROR end
	
	SetBorderColor(v)
	
	return OK
end

-- commande 'CASE'
cmd["CASE"].fn = function(lst)
	return OK
end

-- commande 'CHR$'
cmd["CHR$"].fn = function(lst)
	v, e = EvalInteger(lst[1])

	if e ~= OK then return ERR_SYNTAX_ERROR, nil end
	
	if v < 0 or v > 255 then
		return ERR_OVERFLOW, nil
	end

	return OK, "\"" .. Chr(v) .. "\""
end

-- commande 'CLS'
cmd["CLS"].fn = function(lst)
	ClearScreen()
	
	return OK
end

-- commande 'DRAW'
cmd["DRAW"].fn = function(lst)
	x, e = EvalInteger(lst[1])
	
	if e ~= OK then return ERR_SYNTAX_ERROR end

	y, e = EvalInteger(lst[2])
	
	if e ~= OK then return ERR_SYNTAX_ERROR end
	
	DrawLine(x, y)
	
	return OK
end

-- commande 'DRAWR'
cmd["DRAWR"].fn = function(lst)
	x, e = EvalInteger(lst[1])
	
	if e ~= OK then return ERR_SYNTAX_ERROR end
	
	y, e = EvalInteger(lst[2])
	
	if e ~= OK then return ERR_SYNTAX_ERROR end
		
	DrawLineRelative(x, y)
	
	return OK
end

-- commande 'ELSEIF'
cmd["ELSEIF"].fn = function(lst)
	return OK
end

-- commande 'ELSE'
cmd["ELSE"].fn = function(lst)
	return OK
end

-- commande 'ENDIF'
cmd["ENDIF"].fn = function(lst)
	return OK
end

-- commande 'ENDSELECT'
cmd["ENDSELECT"].fn = function(lst)
	return OK
end

-- commande 'END'
cmd["END"].fn = function(lst)
	EndProgram()
	
	return OK
end

-- commande 'FOR'
cmd["FOR"].fn = function(lst)
	return OK
end

-- commande 'GETBORDER'
cmd["GETBORDER"].fn = function(lst)
	c = GetBorderColor()
	
	return OK, c
end

-- commande 'GETGRAPHPEN'
cmd["GETGRAPHPEN"].fn = function(lst)
	c = GetGraphicPenColor()
	
	return OK, c
end

-- commande 'GETLOCX'
cmd["GETLOCX"].fn = function(lst)
	c = GetLocationX()
	
	return OK, c
end


-- commande 'GETLOCY'
cmd["GETLOCY"].fn = function(lst)
	c = GetLocationY()
	
	return OK, c
end

-- commande 'GETPAPER'
cmd["GETPAPER"].fn = function(lst)
	c = GetPaperColor()
	
	return OK, c
end

-- commande 'GETPEN'
cmd["GETPEN"].fn = function(lst)
	c = GetPenColor()
	
	return OK, c
end

-- commande 'GOSUB'
cmd["GOSUB"].fn = function(lst)
	for i = 1, labCount do
		if labels[i] == lst[1] then
			if stackPointer > 0 then
				stackPointer = stackPointer - 1
				stack[stackPointer] = ProgramCounter
				ProgramCounter = labPC[i]
				return OK
			else
				return ERR_STACK_FULL
			end
		end
	end
	
	return ERR_UNDEFINED_LABEL
end

-- commande 'GOTO'
cmd["GOTO"].fn = function(lst)
	for i = 1, labCount do
		if labels[i] == lst[1] then
			ProgramCounter = labPC[i]
			return OK
		end
	end
	
	return ERR_UNDEFINED_LABEL
end

-- commande 'GRAPHPEN'
cmd["GRAPHPEN"].fn = function(lst)
	v, e = EvalInteger(lst[1])
	
	if e ~= OK then return ERR_SYNTAX_ERROR end
	
	SetGraphicPenColor(v)
	
	return OK
end

-- commande 'HEX$'
cmd["HEX$"].fn = function(lst)
	return OK, "\"" .. Hex(lst[1]) .. "\""
end

-- commande 'HOTSPOT'
cmd["HOTSPOT"].fn = function(lst)
	spr, e = EvalInteger(lst[1])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	hsp, e = EvalInteger(lst[2])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end
	
	return SetHotspotPosition(spr, hsp)
end

-- commande 'IF'
cmd["IF"].fn = function(lst)
	return OK
end

-- commande 'INKEY$'
cmd["INKEY$"].fn = function(lst)
	return OK, "\"" .. GetCharacter() .. "\""
end

-- commande 'INPUT'
cmd["INPUT"].fn = function(lst)
	return OK, GetTextInput()
end

-- commande 'LINE'
cmd["LINE"].fn = function(lst)
	x, e = EvalInteger(lst[1])
	
	if e ~= OK then return ERR_SYNTAX_ERROR end
	
	y, e = EvalInteger(lst[2])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end
	
	w, e = EvalInteger(lst[3])
	
	if e ~= OK then return ERR_SYNTAX_ERROR end
	
	h, e = EvalInteger(lst[4])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	DrawFullLine(x, y, w, h, f)
	
	return OK
end

-- commande 'LOCATE'
cmd["LOCATE"].fn = function(lst)
	x, e = EvalInteger(lst[1])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	y, e = EvalInteger(lst[2])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end
	
	Locate(x, y)
	
	return OK
end

-- commande 'MOVE'
cmd["MOVE"].fn = function(lst)
	x, e = EvalInteger(lst[1])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	y, e = EvalInteger(lst[2])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end
	
	MoveGraphicCursor(x, y)
	
	return OK
end

-- commande 'MOVER'
cmd["MOVER"].fn = function(lst)
	x, e = EvalInteger(lst[1])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	y, e = EvalInteger(lst[2])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	MoveGraphicCursorRelative(x, y)
	
	return OK
end

-- commande 'MUSIC'
cmd["MUSIC"].fn = function(lst)
	if musicPlaying then
		cmd["STOPMUSIC"].fn("")
	end
	
	local v, e = EvalInteger(lst[1])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	if not os.rename(defaultFolder .. currentFolder .. "music" .. tostring(v) .. ".mus", defaultFolder .. currentFolder .. "music" .. tostring(v) .. ".mus") then
		return ERR_FILE_MISSING
	end
	
	LoadMusic(defaultFolder .. currentFolder .. "music" .. tostring(v) .. ".mus")

	-- timer musical à zéro
	countTime = 0
	arpTimer = {0, 0, 0, 0}

	-- position de la musique à zéro
	currentNotesLine = 0
	currentPattern = 1
	currentTrack = 1

	-- musique en fonction
	musicPlaying = true
	
	return OK
end

-- commande 'NEXT'
cmd["NEXT"].fn = function(lst)
	return OK
end

-- commande 'OVAL'
cmd["OVAL"].fn = function(lst)
	x, e = EvalInteger(lst[1])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	y, e = EvalInteger(lst[2])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	w, e = EvalInteger(lst[3])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	h, e = EvalInteger(lst[4])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	f, e = EvalInteger(lst[5])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end
	
	DrawOval(x, y, w, h, f)
	
	return OK
end

-- commande 'PAPER'
cmd["PAPER"].fn = function(lst)
	v, e = EvalInteger(lst[1])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	SetPaperColor(v)
	
	return OK
end

-- commande 'PEN'
cmd["PEN"].fn = function(lst)
	v, e = EvalInteger(lst[1])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	SetPenColor(v)
	
	return OK
end

-- commande 'PLOT'
cmd["PLOT"].fn = function(lst)
	x, e = EvalInteger(lst[1])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	y, e = EvalInteger(lst[2])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end
	
	PlotPixel(x, y)
	
	return OK
end

-- commande 'PLOTR'
cmd["PLOTR"].fn = function(lst)
	x, e = EvalInteger(lst[1])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	y, e = EvalInteger(lst[2])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end
	
	PlotPixelRelative(x, y)
	
	return OK
end

-- commande 'PRINT'
cmd["PRINT"].fn = function(lst)
	if #lst == 0 then
		LineFeed()
	else	
		for i = 1, #lst do
			if type(lst[i]) ~= "string" then lst[i] = tostring(lst[i]) end
			
			if lst[i]:sub(1, 1) == "\"" and lst[i]:sub(-1) == "\"" then
				lst[i] = lst[i]:sub(2, -2)
			end
			
			PrintString(lst[i])
			
			if i == #lst then
				if string.sub(lst[i], -1) ~= ";" then
					LineFeed()
				end
			end
		end
	end

	return OK
end

-- commande 'RECT'
cmd["RECT"].fn = function(lst)
	x, e = EvalInteger(lst[1])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	y, e = EvalInteger(lst[2])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	w, e = EvalInteger(lst[3])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	h, e = EvalInteger(lst[4])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	f, e = EvalInteger(lst[5])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end
	
	DrawRectangle(x, y, w, h, f)
	
	return OK
end

-- commande 'REPEAT'
cmd["REPEAT"].fn = function(lst)
	return OK
end

-- commande 'RETURN'
cmd["RETURN"].fn = function(lst)
	if stackPointer < MAX_STACK then
		ProgramCounter = stack[stackPointer]
		stackPointer = stackPointer + 1
		return OK
	else
		return ERR_UNEXPECTED_RETURN
	end
	
	return ERR_UNDEFINED_LABEL
end

-- commande 'SELECT'
cmd["SELECT"].fn = function(lst)
	return OK
end

-- commande 'SGN'
cmd["SGN"].fn = function(lst)
	return OK, Sign(Val(lst[1]))
end

-- commande 'SPRITEIMG'
cmd["SPRITEIMG"].fn = function(lst)
	spr, e = EvalInteger(lst[1])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	img, e = EvalInteger(lst[2])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	return SetSpriteImage(spr, img)
end

-- commande 'SPRITEOFF'
cmd["SPRITEOFF"].fn = function(lst)
	spr, e = EvalInteger(lst[1])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	return EnableSprite(spr, false)
end

-- commande 'SPRITEON'
cmd["SPRITEON"].fn = function(lst)
	spr, e = EvalInteger(lst[1])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end
	
	return EnableSprite(spr, true)
end

-- commande 'SPRITEPOS'
cmd["SPRITEPOS"].fn = function(lst)
	spr, e = EvalInteger(lst[1])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	x, e = EvalInteger(lst[2])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	y, e = EvalInteger(lst[3])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end
	
	return SetSpritePosition(spr, x, y)
end

-- commande 'SPRITESCALE'
cmd["SPRITESCALE"].fn = function(lst)
	spr, e = EvalInteger(lst[1])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	ss, e = EvalInteger(lst[2])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end
	
	return SetSpriteScale(spr, ss)
end

-- commande 'SPRITETRANSP'
cmd["SPRITETRANSP"].fn = function(lst)
	spr, e = EvalInteger(lst[1])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	tc, e = EvalInteger(lst[2])
		
	if e ~= OK then return ERR_SYNTAX_ERROR end

	return SetSpriteTransparentColor(spr, tc)
end

-- commande 'STOPMUSIC'
cmd["STOPMUSIC"].fn = function(lst)
	for i = 1, 4 do
		if lastNote[i] ~= 0 then
			if arpLastNote[i] ~= lastNote[i] and arpLastNote[i] ~= 0 then
				instr[i][arpLastNote[i]]:stop()
			else
				instr[i][lastNote[i]]:stop()
			end
			arpLastNote[i] = 0
			lastNote[i] = 0
		end
	end
	
	-- musique en fonction
	musicPlaying = false

	return OK
end

-- commande 'UNTIL'
cmd["UNTIL"].fn = function(lst)
	return OK
end

-- commande 'VAL'
cmd["VAL"].fn = function(lst)
	if lst[1] == nil or lst[1] == "" then return OK, 0 end

	return OK, Val(lst[1])
end

-- commande 'WAITVBL'
cmd["WAITVBL"].fn = function(lst)
	WaitVBL()
	
	return OK
end

-- commande 'WEND'
cmd["WEND"].fn = function(lst)
	return OK
end

-- commande 'WHILE'
cmd["WHILE"].fn = function(lst)
	return OK
end
