-- définir un caractère ASCII
function Symbol(c, list)
	-- il faut 8 ligne...
	if #list > 8 then
		return ERR_TOO_MANY_OPERANDS
	elseif #list < 8 then
		return ERR_OPERAND_MISSING
	end
	
	-- ... de 8 string-bits
	for i = 1, 8 do
		if #list[i] > 8 then
			return ERR_TOO_MANY_OPERANDS
		elseif #list[i] < 8 then
			return ERR_OPERAND_MISSING
		end
	end
	
	-- définir le caractère
	for y = 0, 7 do
		for x = 0, 7 do
			rom[c][x][y] = 0
			if string.sub(list[y + 1], x + 1, x + 1) == '1' then
				rom[c][x][y] = 1
			end
		end
	end
	
	return OK
end

-- changer la position du curseur texte
function Locate(x, y)
	-- gestion des erreurs
	if x < 1 or x > gmode[currentMode][1] / 8 or y < 1 or y > gmode[currentMode][2] / 8 then return ERR_SYNTEX_ERROR end

	-- valeurs de retour
	cursor[1] = x
	cursor[2] = y
	
	return OK
end

-- récupérer la position x du curseur texte
function GetLocationX()
	
	return OK, cursor[1]
end

-- récupérer la position y du curseur texte
function GetLocationY()
	
	return OK, cursor[2]
end

-- changer la transparence du fond de texte
function SetTextTransparent(t)
	textTransparency = t
end

-- afficher un caractère à l'écran avec la couleur du stylo texte
function PrintChar(c, r)
	-- retour si le caractère n'existe pas
	if c == nil then return ERR_OPERAND_MISSING end
	
	local x1 = (cursor[1] - 1) * 8
	local y1 = (cursor[2] - 1) * 8

	SetCanvas(true)

	-- dessiner en mémoire vidéo virtuelle
	for y = y1, y1 + 7 do
		for x = x1, x1 + 7 do
			if x >= 0 and x <= gmode[currentMode][1] - 1 and y >= 0 and y <= gmode[currentMode][2] - 1 then
				if not textTransparency then
					if sym[c][x - x1][y - y1] == nil then
						return OK
					elseif sym[c][x - x1][y - y1] == 1 then
						love.graphics.setColor(scnPal[pen][0], scnPal[pen][1], scnPal[pen][2], scnPalNoAlpha)
						love.graphics.points(x + 0.5, y + 0.5)
					else
						love.graphics.setColor(scnPal[paper][0], scnPal[paper][1], scnPal[paper][2], scnPalNoAlpha)
						love.graphics.points(x + 0.5, y + 0.5)
					end
				else
					if sym[c][x-x1][y-y1] == nil then
						return OK
					elseif sym[c][x-x1][y-y1] == 1 then
						love.graphics.setColor(scnPal[pen][0], scnPal[pen][1], scnPal[pen][2], scnPalNoAlpha)
						love.graphics.points(x + 0.5, y + 0.5)
					end
				end
			end
		end
	end

	SetCanvas(false)

	if r ~= PRINT_NO_FLAGS then
		if r == PRINT_CLIPPED then
			cursor[1] = cursor[1] + 1
			
			if cursor[1] > gmode[currentMode][1] / 8 then
				cursor[1] = 1
				cursor[2] = cursor[2] + 1
				if cursor[2] > gmode[currentMode][2] / 8 then
					ScrollScreenUp()
					cursor[2] = cursor[2] - 1
				end
			end
		elseif r == PRINT_NOT_CLIPPED then
			cursor[1] = cursor[1] + 1
			
			if cursor[1] > gmode[currentMode][1] / 8 then
				ScrollScreenLeft()
				editorOffsetX = editorOffsetX + 1
				cursor[1] = cursor[1] - 1
			end
		elseif r == PRINT_NOT_CLIPPED_NO_SCROLL then
			cursor[1] = cursor[1] + 1
		end
	end
	
	return OK
end

-- afficher un caractère graphique à l'écran, avec la couleur du stylo texte
function GraphPrintChar(c, r)
	-- retour si le caractère n'existe pas
	if c == nil then
		return ERR_OPERAND_MISSING
	end
	
	local x1 = gcursor[1]
	local y1 = gcursor[2]

	SetCanvas(true)

	-- dessiner en mémoire vidéo virtuelle
	for y = y1, y1 + 7 do
		for x = x1, x1 + 7 do
			if x >= 0 and x <= gmode[currentMode][1] - 1 and y >= 0 and y <= gmode[currentMode][2] - 1 then
				if sym[c][x-x1][y-y1] == nil then
					return OK
				elseif sym[c][x-x1][y-y1] == 1 then
					love.graphics.setColor(scnPal[gpen][0], scnPal[gpen][1], scnPal[gpen][2], scnPalNoAlpha)
					love.graphics.points(x + 0.5, y + 0.5)
				end
			end
		end
	end
	
	gcursor[1] = gcursor[1] + 8

	SetCanvas(false)
	
	return OK
end

-- afficher un caractère graphique à l'écran, avec la couleur du stylo texte
function GraphPrintCharEx(c, r)
	-- retour si le caractère n'existe pas
	if c == nil then
		return ERR_OPERAND_MISSING
	end
	
	local x1 = gcursor[1]
	local y1 = gcursor[2]

	-- dessiner en mémoire vidéo virtuelle
	for y = y1, y1 + 7 do
		for x = x1, x1 + 7 do
			if x >= 0 and x <= gmode[currentMode][1] - 1 and y >= 0 and y <= gmode[currentMode][2] - 1 then
				if sym[c][x-x1][y-y1] == nil then
					return OK
				elseif sym[c][x-x1][y-y1] == 1 then
					love.graphics.setColor(scnPal[gpen][0], scnPal[gpen][1], scnPal[gpen][2], scnPalNoAlpha)
					love.graphics.points(x + 0.5, y + 0.5)
				end
			end
		end
	end
	
	gcursor[1] = gcursor[1] + 8
	
	return OK
end

-- afficher un ou plusieurs caractères à l'écran avec la couleur du stylo texte
function PrintString(s)
	-- annuler si la chaîne est vide
	if s == nil then
		return
	end
	
	for i = 1, #s do
		chr = string.sub(s, i, i)
		if Asc(chr) == 13 then
			cursor[1] = 1
			cursor[2] = cursor[2] + 1
			if cursor[2] > 25 then
				ScrollScreenUp()
				cursor[2] = cursor[2] - 1
			end
		elseif Asc(chr) == 7 then
			Beep()
		elseif Asc(chr) < 32 then
			-- TODO ?
		else
			PrintChar(Asc(chr), PRINT_CLIPPED)
		end
	end
end

-- afficher un ou plusieurs caractères graphiques à l'écran avec la couleur du stylo texte
function GraphPrintString(s)
	-- annuler si la chaîne est vide
	if s == nil then
		return
	end
	
	for i = 1, #s do
		chr = string.sub(s, i, i)
		if Asc(chr) == 7 then
			Beep()
		elseif Asc(chr) < 32 then
			-- TODO ?
		else
			GraphPrintChar(Asc(chr), PRINT_CLIPPED)
		end
	end
end

-- afficher un ou plusieurs caractères graphiques sur un canvas avec la couleur du stylo texte
function GraphPrintStringEx(s)
	-- annuler si la chaîne est vide
	if s == nil then
		return
	end
	
	for i = 1, #s do
		chr = string.sub(s, i, i)
		if Asc(chr) == 7 then
			Beep()
		elseif Asc(chr) < 32 then
			-- TODO ?
		else
			GraphPrintCharEx(Asc(chr), PRINT_CLIPPED)
		end
	end
end

-- afficher un texte graphique à l'écran (fonction raccourci pour les UI)
function Text(p, x, y, c, center)
	local memGraphCursor = {gcursor[1], gcursor[2]}
	local memGPen = gpen

	if center then
		gcursor[1] = x - ((p:len() * 8) / 2)
		gcursor[2] = y - 4
	else
		gcursor[1] = x
		gcursor[2] = y
	end
	
	gpen = c

	GraphPrintString(p)

	gcursor[1] = memGraphCursor[1]
	gcursor[2] = memGraphCursor[2]
	gpen = memGPen
end

-- afficher un ou plusieurs caractères à l'écran avec la couleur du stylo texte
-- version de la routine qui ne descend pas à la ligne
function PrintString2(s)
	-- annuler si la chaîne est vide
	if s == nil then
		return
	end
	
	for i = 1, #s do
		chr = string.sub(s, i, i)
		PrintChar(Asc(chr), PRINT_NOT_CLIPPED)
	end
end

-- afficher un ou plusieurs caractères à l'écran avec la couleur du stylo texte
-- et passe à la ligne suivante
function PrintStringN(s)
	PrintString(s)
	LineFeed()
end

-- récupérer une saisie de ligne de texte (TODO!)
function GetTextInput()
	return ""
end

-- afficher une chaîne de caractères d'infos en haut de l'écran, dans le border
function PrintInfosString(s, r, col, offset)
	love.graphics.push()
	love.graphics.setCanvas(renderer[r])

	if offset == nil then offset = 0 end

	-- dessiner tous les caractères en haut de l'écran
	for i = 1, #s do
		c = Asc(string.sub(s, i, i))
		
		-- dessiner dans le renderer infos
		for y = 0, 7 do
			for x = 0, 7 do
				if sym[c][x][y] == nil then
					return OK
				elseif sym[c][x][y] == 1 then
					if col == "red" then
						love.graphics.setColor(1, 0, 0, 1)
					elseif col == "orange" then
						love.graphics.setColor(1, 0.5, 0, 1)
					elseif col == "green" then
						love.graphics.setColor(0, 0.5, 0.1, 1)
					elseif col == "darkblue" then
						love.graphics.setColor(0, 0.25, 0.5, 1)
					elseif col == "blue" then
						love.graphics.setColor(0, 0.5, 1, 1)
					elseif col == "black" then
						love.graphics.setColor(0, 0, 0, 1)
					end
				-- blanc
				else
					love.graphics.setColor(1, 1, 1, 1)
				end

				love.graphics.points(((i - 1) * 8) + x + (offset * 8) + 0.5, y + 0.5)
			end
		end		
	end

	love.graphics.setCanvas()
	love.graphics.pop()	
end

-- stocker en ram et afficher un ou plusieurs caractères à l'écran avec la couleur du stylo texte
function PrintTextToRam(s)
	-- annuler si la chaîne est vide
	if s == nil then
		return
	end

	ShowCursor(false)
	
	ram[ramLine] = s
	ramLine = ramLine + 1
		
	for i = 1, #s do
		if i > 255 then
			Beep()
			return
		end
		
		chr = string.sub(s, i, i)
		
		if Asc(chr) ~= LF then
			PrintChar(Asc(chr), PRINT_NOT_CLIPPED)
		end
	end

	ShowCursor(true)
end

function AppendTextToRam(s)
	local mempen = pen
	local mempaper = paper

	-- annuler si la chaîne est vide
	if s == nil then return end

	ShowCursor(false)
	
	if ram[ramLine] == nil then
		for i = 1, #s do
			if i > 255 then
				Beep()
				
				return
			end
		
			local chr = string.sub(s, i, i)
			
			if i == 1 then
				ram[ramLine] = chr
			else
				ram[ramLine] = ram[ramLine] .. chr
			end
			
			if Asc(chr) ~= LF then
				pen = DEFAULT_PEN
				paper = DEFAULT_PAPER
				
				if hightlightedRamLine == ramLine then pen = DEFAULT_PAPER; paper = DEFAULT_PEN end
				
				PrintChar(Asc(chr), PRINT_NOT_CLIPPED)
			end
		end
	else
		for i = 1, #s do
			if i + #ram[ramLine] > 255 then
				Beep()
				
				return
			end
		
			local chr = string.sub(s, i, i)
			
			ram[ramLine] = ram[ramLine] .. chr
			
			if Asc(chr) ~= LF then
				pen = DEFAULT_PEN
				paper = DEFAULT_PAPER
				
				if hightlightedRamLine == ramLine then pen = DEFAULT_PAPER; paper = DEFAULT_PEN end
				
				PrintChar(Asc(chr), PRINT_NOT_CLIPPED)
			end
		end
	end

	ShowCursor(true)
	
	pen = mempen
	paper = mempaper
end

-- colorier la ligne courante de l'éditeur
function SetEditorTextColor(ln)
	-- ajouter l'offset de l'éditeur
	ln = ln + editorOffsetY
	
	-- récupérer et sauvegarder la position courante du curseur
	local xSafe = cursor[1]
	local ySafe = cursor[2]

	-- rétablir le stylo par défaut
	pen = DEFAULT_PEN

	-- récupérer la ligne courante
	local s = ram[ln]
	
	-- exit si la chaîne est vide
	if s == nil then
		-- rétablir la position du curseur texte
		cursor[1] = xSafe
		cursor[2] = ySafe

		-- rétablir le stylo par défaut
		pen = DEFAULT_PEN

		return		
	end
	
	-- repositionner le curseur texte en début de ligne
	cursor[1] = 1
		
	-- label trouvé ? on remplace la couleur
	local lab = ScanCurrentLabels(s)

	if lab ~= nil then
		pen = DEFAULT_LABELS_PEN
		if hightlightedRamLine == ln then pen = DEFAULT_INSTRUCTIONS_PEN_HIGHLIGHTED; paper = DEFAULT_PEN end
		PrintString2(lab .. ":")
		pen = DEFAULT_PEN
		s = string.sub(s, #lab + 2)
		cursor[1] = #lab + 2
	end

	-- exit si la chaîne est vide
	if s == nil then
		-- rétablir la position du curseur texte
		cursor[1] = xSafe
		cursor[2] = ySafe

		-- rétablir le stylo par défaut
		pen = DEFAULT_PEN		

		return		
	end
	
	-- trouver et colorier les commandes sur la ligne
	local word = "" -- mot en cours d'analyse
	local wpos = 0 -- position de début de mot en cours d'analyse
	local quotes = 0 -- nombre de guillemets
	local flag = true -- drapeau pour activer le dessin du texte colorié
	local startPos = editorOffsetX
	local endPos = math.min(#s, startPos + 39)

	for i = startPos, endPos do
		-- récupérer le caractère en cours d'analyse
		local c = string.lower(string.sub(s, i, i))

		-- comptabliser les guillemets
		if c == "\"" then
			quotes = quotes + 1
			
			if quotes % 2 == 0 then word = ""; wpos = 0 end
		-- comptabliser les caractères pour les commandes
		elseif (c >= "a" and c <= "z") or c == "$" then
			if wpos == 0 then wpos = i end
			
			word = word .. string.sub(s, i, i)
		-- activer le remplacement de couleur si l'on rencontre un autre caractère
		else
			word = ""						
			wpos = 0
		end

		-- remplacer la commande avec la couleur adaptée
		if word ~= "" then
			for j = 1, #commands do
				if string.upper(word) == commands[j] then
					-- si le guillemet trouvé peut être suivi d'un mot...
					if quotes % 2 == 0 then
						local pos = cursor[1]
						cursor[1] = wpos - editorOffsetX
						pen = DEFAULT_INSTRUCTIONS_PEN
						paper = DEFAULT_PAPER
						if hightlightedRamLine == ln then pen = DEFAULT_INSTRUCTIONS_PEN_HIGHLIGHTED; paper = DEFAULT_PEN end
						PrintString2(word)
						pen = DEFAULT_PEN
						cursor[1] = pos
					end
				end
			end
		end
	end
		
	-- commentaire trouvé ? on remplace la couleur
	local com = ScanComments(s)
	
	if com ~= nil then
		local pos = cursor[1]
		cursor[1] = cursor[1] + #s - #com
		pen = DEFAULT_COMMENTS_PEN
		if hightlightedRamLine == ln then pen = DEFAULT_INSTRUCTIONS_PEN_HIGHLIGHTED; paper = DEFAULT_PEN end
		PrintString2(com)
		pen = DEFAULT_PEN
		cursor[1] = pos
	end

	-- rétablir la position du curseur texte
	cursor[1] = xSafe
	cursor[2] = ySafe

	-- rétablir le stylo par défaut
	pen = DEFAULT_PEN
end

function Messagebox(title, message, buttons, fnct)
	changeMsgbox = true
	msgboxTitle = title
	msgboxMessage = message
	msgboxButtons = buttons
	msgboxFunction = fnct
end
