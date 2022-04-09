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
	if x < 1 or x > 40 or y < 1 or y > 25 then return ERR_SYNTEX_ERROR end

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
	if c == nil then
		return ERR_OPERAND_MISSING
	end
	
	local x1 = (cursor[1] - 1) * 8
	local y1 = (cursor[2] - 1) * 8

	SetCanvas(true)

	-- dessiner en mémoire video virtuelle
	for y = y1, y1 + 7 do
		for x = x1, x1 + 7 do
			if x >= 0 and x <= SCN_SIZE_WIDTH - 1 and y >= 0 and y <= SCN_SIZE_HEIGHT - 1 then
				if not textTransparency then
					if sym[c][x - x1][y - y1] == nil then
						return OK
					elseif sym[c][x - x1][y - y1] == 1 then
						love.graphics.setColor(scnPal[pen][0] / 255, scnPal[pen][1] / 255, scnPal[pen][2] / 255, 1)
						love.graphics.points(x + 0.5, y + 0.5)
					else
						love.graphics.setColor(scnPal[paper][0] / 255, scnPal[paper][1] / 255, scnPal[paper][2] / 255, 1)
						love.graphics.points(x + 0.5, y + 0.5)
					end
				else
					if sym[c][x-x1][y-y1] == nil then
						return OK
					elseif sym[c][x-x1][y-y1] == 1 then
						love.graphics.setColor(scnPal[pen][0] / 255, scnPal[pen][1] / 255, scnPal[pen][2] / 255, 1)
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
			
			if cursor[1] > 40 then
				cursor[1] = 1
				cursor[2] = cursor[2] + 1
				if cursor[2] > 25 then
					ScrollScreenUp()
					cursor[2] = cursor[2] - 1
				end
			end
		elseif r == PRINT_NOT_CLIPPED then
			cursor[1] = cursor[1] + 1
			
			if cursor[1] > 40 then
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

-- récupérer une saisie de ligne de texte (TODO)
function GetTextInput()
	return ""
end

-- afficher une chaîne de caractères d'infos en haut de l'écran, dans le border
function PrintInfosString(s, r, col)
	love.graphics.push()
	love.graphics.setCanvas(renderer[r])

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
					elseif col == "blue" then
						love.graphics.setColor(0, 0.5, 1, 1)
					elseif col == "black" then
						love.graphics.setColor(0, 0, 0, 1)
					end
					love.graphics.points(((i - 1) * 8) + x + 0.5, y + 0.5)
				else
					love.graphics.setColor(1, 1, 1, 1)
					love.graphics.points(((i - 1) * 8) + x + 0.5, y + 0.5)
				end
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
	-- annuler si la chaîne est vide
	if s == nil then
		return
	end

	ShowCursor(false)
	
	if ram[ramLine] == nil then
		for i = 1, #s do
			if i > 255 then
				Beep()
				return
			end
		
			chr = string.sub(s, i, i)
			
			if i == 1 then
				ram[ramLine] = chr
			else
				ram[ramLine] = ram[ramLine] .. chr
			end
			
			if Asc(chr) ~= LF then
				PrintChar(Asc(chr), PRINT_NOT_CLIPPED)
			end
		end
	else
		for i = 1, #s do
			if i + #ram[ramLine] > 255 then
				Beep()
				return
			end
		
			chr = string.sub(s, i, i)
			
			ram[ramLine] = ram[ramLine] .. chr
			
			if Asc(chr) ~= LF then
				PrintChar(Asc(chr), PRINT_NOT_CLIPPED)
			end
		end
	end

	ShowCursor(true)
end

-- colorier la ligne courante de l'éditeur
function SetEditorTextColor(ln)
	-- ajouter l'offset de l'éditeur
	ln = ln + editorOffsetY
	
	-- récupérer la position courante du curseur
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
	end
	
	-- repositionner le curseur texte en début de ligne
	cursor[1] = 1
		
	-- label trouvé ? on remplace la couleur
	local lab = ScanCurrentLabels(s)

	if lab ~= nil then
		pen = DEFAULT_LABELS_PEN
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
	end

	-- commentaire trouvé ? on remplace la couleur
	local com = ScanComments(s)
	
	if com ~= nil then
		local pos = cursor[1]
		cursor[1] = cursor[1] + #s - #com
		pen = DEFAULT_COMMENTS_PEN
		PrintString2(com)
		pen = DEFAULT_PEN
		cursor[1] = pos
	end
		
	-- exit si la chaîne est vide
	if s == nil then
		-- rétablir la position du curseur texte
		cursor[1] = xSafe
		cursor[2] = ySafe

		-- rétablir le stylo par défaut
		pen = DEFAULT_PEN		
	end

	-- commande trouvée ? on remplace la couleur
	local g = 0 -- nombre de guillemets trouvés
	local word = "" -- mot trouvé
	local flag = false -- drapeau pour si un mot est complet
	local wpos = 0
	
	for i = 1, #s do
		-- récupérer le caractère en cours
		local c = string.lower(string.sub(s, i, i))
		
		-- si c'est un guillemet, on le comptabilise
		if c == "\"" then
			g = g + 1
			
			-- si un mot était avant le guillemet, et qu'il n'est
			-- pas inclus dans une chaîne de caractères, alors,
			-- déclencher son coloriage
			if #word > 0 and g % 2 == 1 then
				wpos = i - #word
				flag = true
			end
		elseif c >= "a" and c <= "z" then
			word = word .. string.sub(s, i, i)

			if i == #s and g % 2 == 0 then
				wpos = i - #word + 1
				flag = true
			end
		elseif #word > 0 and g % 2 == 0 then
			wpos = i - #word
			flag = true
		end
		
		-- colorier un mot clé
		if flag then
			for j = 1, #commands do
				if string.upper(word) == commands[j] then
					local pos = cursor[1]
					cursor[1] = wpos
					pen = DEFAULT_INSTRUCTIONS_PEN
					PrintString2(word)
					pen = DEFAULT_PEN
					cursor[1] = pos
				end
			end
			
			flag = false
			word = ""
		end
	end

	-- rétablir la position du curseur texte
	cursor[1] = xSafe
	cursor[2] = ySafe

	-- rétablir le stylo par défaut
	pen = DEFAULT_PEN		
end
