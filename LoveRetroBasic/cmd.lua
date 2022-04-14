-- commande 'ABS'
cmd["ABS"].fn = function(lst)
	return OK, Abs(lst[1])
end

-- commande 'ASC'
cmd["ASC"].fn = function(lst)
	return OK, tostring(Asc(lst[1]))
end

-- commande 'BIN$'
cmd["BIN$"].fn = function(lst)
	return OK, "\"" .. Bin(lst[1]) .. "\""
end

-- commande 'BORDER'
cmd["BORDER"].fn = function(lst)
	SetBorderColor(lst[1])
	
	return OK
end

-- commande 'CASE'
cmd["CASE"].fn = function(lst)
	return OK
end

-- commande 'CHR$'
cmd["CHR$"].fn = function(lst)
	if lst[1] < 0 or lst[1] > 255 then
		return ERR_OVERFLOW, nil
	end

	return OK, Chr(lst[1])
end

-- commande 'CLS'
cmd["CLS"].fn = function(lst)
	ClearScreen()
	
	return OK
end

-- commande 'DRAW'
cmd["DRAW"].fn = function(lst)
	DrawLine(lst[1], lst[2])
	
	return OK
end

-- commande 'DRAWR'
cmd["DRAWR"].fn = function(lst)		
	DrawLineRelative(lst[1], lst[2])
	
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

-- commande 'END'
cmd["END"].fn = function(lst)
	EndProgram()
	
	return OK
end

-- commande 'FOR'
cmd["FOR"].fn = function(lst)
	-- assigner l'expression à la variable
	local e = AssignToVar(lst[1], lst[2], lst[3])

	return e
end

-- commande 'FREEBOB'
cmd["FREEBOB"].fn = function(lst)
	FreeBOB(lst[1])
	
	return OK
end


-- commande 'GETBORDER'
cmd["GETBORDER"].fn = function(lst)
	local c = GetBorderColor()
	
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
	SetGraphicPenColor(lst[1])
	
	return OK
end

-- commande 'PRINT'
cmd["GRAPHPRINT"].fn = function(lst)
	if #lst > 0 then
		for i = 1, #lst do
			if type(lst[i]) ~= "string" then lst[i] = tostring(lst[i]) end
			
			if lst[i]:sub(1, 1) == "\"" and lst[i]:sub(-1) == "\"" then
				lst[i] = lst[i]:sub(2, -2)
			end
			
			GraphPrintString(lst[i])
		end
	end

	return OK
end


-- commande 'HEX$'
cmd["HEX$"].fn = function(lst)
	return OK, "\"" .. Hex(lst[1]) .. "\""
end

-- commande 'HOTSPOT'
cmd["HOTSPOT"].fn = function(lst)	
	return SetHotspotPosition(lst[1], lst[2])
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
	DrawFullLine(lst[1], lst[2], lst[3], lst[4])
	
	return OK
end

-- commande 'LOADBOB'
cmd["LOADBOB"].fn = function(lst)
	LoadBOB(lst[1], currentRelativeFolder .. imageFolder, lst[2])
	
	return OK
end

-- commande 'LOADIMAGE'
cmd["LOADIMAGE"].fn = function(lst)
	LoadImage(lst[1], currentRelativeFolder .. imageFolder)
	
	return OK
end

-- commande 'LOCATE'
cmd["LOCATE"].fn = function(lst)	
	Locate(lst[1], lst[2])
	
	return OK
end

-- commande 'MODE'
cmd["MODE"].fn = function(lst)
	SetMode(lst[1])
	
	return OK
end

-- commande 'MOVE'
cmd["MOVE"].fn = function(lst)
	MoveGraphicCursor(lst[1], lst[2])
	
	return OK
end

-- commande 'MOVER'
cmd["MOVER"].fn = function(lst)
	MoveGraphicCursorRelative(lst[1], lst[2])
	
	return OK
end

-- commande 'MUSIC'
cmd["MUSIC"].fn = function(lst)
	if musicPlaying then
		cmd["STOPMUSIC"].fn("")
	end
	
	if not GetFileExists(currentRelativeFolder .. musicFolder, "music" .. tostring(lst[1]) .. ".rmu") then
		return ERR_FILE_MISSING
	end
	
	LoadMusic(driveFolder .. diskFolder .. "/" .. "music" .. tostring(lst[1]) .. ".mus")

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
	local cs, row, column, id = "", 0, 0, 0

	for i = #stack, 1, -1 do
		cs = stack[i][1]
		row = stack[i][2]
		column = stack[i][3]
		id = stack[i][4]

		if id == currentLoopCommandID and cs == "FOR" then break end	
	end
	
	--	next sans for
	if cs == "" and row == 0 and column == 0 and id == 0 then return ERR_UNEXPECTED_NEXT end

	-- mauvaise variable indiquée derrière next
	if lst[1] ~= nil then
		if string.upper(lst[1]) ~= string.upper(iterator[row][column][4]) then return ERR_UNEXPECTED_NEXT end
	end
	
	-- si nécessaire...
	if math.abs(iterator[row][column][1] + iterator[row][column][3]) <= math.abs( iterator[row][column][2]) then
		-- incrémenter l'itérateur
		iterator[row][column][1] = iterator[row][column][1] + iterator[row][column][3]

		-- boucler
		JumpToIterator(cs, row, column, id)
	else	-- terminer la boucle
		iterator[row][column] = {0, 0, 0, ""}
		PopIterator(cs, row, column, id)
	end	

	return OK
end

-- commande 'OVAL'
cmd["OVAL"].fn = function(lst)	
	DrawOval(lst[1], lst[2], lst[3], lst[4], lst[5])
	
	return OK
end

-- commande 'PAPER'
cmd["PAPER"].fn = function(lst)
	SetPaperColor(lst[1])
	
	return OK
end

-- commande 'PASTEBOB'
cmd["PASTEBOB"].fn = function(lst)
	PasteBOB(lst[1], lst[2], lst[3])
	
	return OK
end

-- commande 'PEN'
cmd["PEN"].fn = function(lst)
	SetPenColor(lst[1])
	
	return OK
end

-- commande 'PLOT'
cmd["PLOT"].fn = function(lst)
	PlotPixel(lst[1], lst[2])
	
	return OK
end

-- commande 'PLOTR'
cmd["PLOTR"].fn = function(lst)
	PlotPixelRelative(lst[1], lst[2])
	
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

			if lst[i] ~= ";" then
				PrintString(lst[i])

				if i == #lst then LineFeed() end
			end
		end
	end

	return OK
end

-- commande 'RECT'
cmd["RECT"].fn = function(lst)
	DrawRectangle(lst[1], lst[2], lst[3], lst[4], lst[5])
	
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

-- commande 'SAVEBOB'
cmd["SAVEBOB"].fn = function(lst)
	SaveBOB(lst[1], currentRelativeFolder .. imageFolder, lst[2])
	
	return OK
end

-- commande 'SELECT'
cmd["SELECT"].fn = function(lst)
	return OK
end

-- commande 'SGN'
cmd["SGN"].fn = function(lst)
	return OK, Sign(lst[1])
end

-- commande 'SPRITEIMG'
cmd["SPRITEIMG"].fn = function(lst)
	return SetSpriteImage(lst[1], lst[2])
end

-- commande 'SPRITEOFF'
cmd["SPRITEOFF"].fn = function(lst)
	return EnableSprite(lst[1], false)
end

-- commande 'SPRITEON'
cmd["SPRITEON"].fn = function(lst)
	return EnableSprite(lst[1], true)
end

-- commande 'SPRITEPOS'
cmd["SPRITEPOS"].fn = function(lst)
	return SetSpritePosition(lst[1], lst[2], lst[3])
end

-- commande 'SPRITESCALE'
cmd["SPRITESCALE"].fn = function(lst)
	return SetSpriteScale(lst[1], lst[2])
end

-- commande 'SPRITETRANSP'
cmd["SPRITETRANSP"].fn = function(lst)
	return SetSpriteTransparentColor(lst[1], lst[2])
end

-- commande 'STOPMUSIC'
cmd["STOPMUSIC"].fn = function(lst)
	for i = 1, 4 do
		if lastNote[i] ~= 0 then
			if arpLastNote[i] ~= lastNote[i] and arpLastNote[i] ~= 0 then
				Stop(instr[i][arpLastNote[i]])
			else
				Stop(instr[i][lastNote[i]])
			end
			arpLastNote[i] = 0
			lastNote[i] = 0
		end
	end
	
	-- musique en fonction
	musicPlaying = false

	return OK
end

-- commande 'STR$'
cmd["STR$"].fn = function(lst)
	if lst[1] == "" then return OK, "" end

	return OK, tostring(lst[1])
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

-- commande 'WAITKEY'
cmd["WAITKEY"].fn = function(lst)
	WaitKey()

	return OK
end

-- commande 'WAITVBL'
cmd["WAITVBL"].fn = function(lst)
	WaitVBL()
	
	return OK
end

-- commande 'WEND'
cmd["WEND"].fn = function(lst)
	local cs, row, column, id = "", 0, 0, 0

	for i = #stack, 1, -1 do
		if stack[i][1] == "WHILE" then
			cs = stack[i][1]
			row = stack[i][2]
			column = stack[i][3]
			id = stack[i][4]
			
			break
		end
	end
	
	--	wend sans while
	if cs == "" and row == 0 and column == 0 and id == 0 then return ERR_UNEXPECTED_WEND end
		
	-- boucler
	JumpToIterator(cs, row, column, id)

	return OK
end

-- commande 'WHILE'
cmd["WHILE"].fn = function(lst)
	-- zapper la boucle
	if Val(lst[1]) == 0 then
		searchCommand = "WEND"
	end

	return OK
end
