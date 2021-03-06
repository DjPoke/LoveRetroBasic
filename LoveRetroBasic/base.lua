-- montrer (ou cacher le curseur texte)
function ShowCursor(s)
	if s == true then
		if not cursorVisible then
			PrintChar(95, PRINT_NO_FLAGS)
			cursorVisible = true
		else
			PrintChar(95, PRINT_NO_FLAGS)
		end
	else
		if cursorVisible then
			PrintChar(32, PRINT_NO_FLAGS)
			cursorVisible = false
		end
	end
end

-- gérer le scrolling horizontal
function SetHScroll()
	if cursor[1] < 41 then
		editorOffsetX = 0
	else
		editorOffsetX = cursor[1] - 40
		cursor[1] = 40
	end
	
	RedrawEditor()
end

-- trouve le nombre de fois que le caractère 'c' est présent dans 's'
function CountString(s, c)
	local count = 0
	
	for i = 1, #s do
		if string.sub(s, i, i) == c then
			count = count + 1
		end
	end
	
	return count
end

-- récupérer la valeur absolue du nombre
function Abs(n)
	return math.abs(n)
end

-- récupérer l'arrondi du nombre
function Round(n)
	return n >= 0 and math.floor(n + 0.5) or math.ceil(n - 0.5)
end

-- récupérer le signe du nombre
function Sign(n)
	if n == 0 then return 0 end
	if n < 0 then return -1 else return 1 end
end

-- récupérer la valeur ASCII du caractère
function Asc(c)
	-- retourner une erreur si le caractère est vide ou qu'il y en a plusieurs
	if c == nil or #c > 1 then return nil end
	
	return string.byte(c, 1, 1)
end

-- convertir la valeur ASCII en caractère
function Chr(a)
	-- retourner une erreur en cas de mauvaise valeur ASCII
	if a == nil or a < 0 or a > 255 then
		return nil
	end
	
	return string.char(a)
end

-- supprime le caractère au début et à la fin de la chaîne
function Trim(s, c)
	if s == nil then return nil end
	if c == nil then c = " " end

	-- supprimer côté gauche
	while string.sub(s, 1, 1) == c and #s > 0 do
		s = string.sub(s, 2)
	end
	
	if #s > 0 then
		-- supprimer côté droit
		while string.sub(s, #s, #s) == c and #s > 0 do
			s = string.sub(s, 1, #s - 1)
		end
	end
	
	if s == nil then s = "" end
	
	return s
end

-- convertir la chaîne numérique en nombre
function Val(s)
	local retv = nil

	-- chercher un code hexa
	if #s > 1 then
		if string.sub(s, 1, 1) == "&" and string.sub(s, 2, 2) ~= "x" then
			local v = string.sub(s, 2)

			retv = tonumber("0x" .. v)
			
			-- remplacer nil par zéro
			if retv == nil then retv = 0 end
			
			return retv
		end
	end
	
	-- chercher un code binaire
	if #s > 2 then
		if string.lower(string.sub(s, 1, 2)) == "&x" then
			local v = string.sub(s, 3)

			for i = 1, #v do
				if (string.sub(v, i, i) < "0" or string.sub(v, i, i) > "1") then
					return 0
				end
			end
			
			retv = 0
			
			for i = #v, 1, -1 do
				local bit = string.sub(v, i, i)
				
				if bit == "1" then
					retv = retv + (2 ^ (#v - i))
				end
			end
			
			return retv
		end
	end

	-- calculer la valeur décimale du résultat
	retv = tonumber(s)
	
	-- remplacer nil par zéro
	if retv == nil then retv = 0 end
	
	return retv
end

-- convertir un nombre en chaîne hexadécimale
function Hex(h)
	return string.format("%x", h)
end

-- convertir un nombre en chaîne binaire
function Bin(b)
	local s = string.format("%x", b)
	
	local a = {
	 "0000","0001","0010","0011",
	 "0100","0101","0110","0111",
	 "1000","1001","1010","1011",
	 "1100","1101","1110","1111"
	}
	
	local r = ""
	
	for i = 1, #s do
		local nibble = string.sub(s, i, i)
		local v = Val("&" .. nibble)
		r = r .. a[v + 1]
	end
	
	while r ~= nil and r ~= "" do
		if string.sub(r, 1, 1) == "0" then
			r = string.sub(r, 2)
		else
			break
		end
	end
	
	return r
end

-- émettre un bip
function Beep()
	love.audio.stop(beepSound)
	love.audio.play(beepSound)
end

-- émettre un son de validation
function Sound()
	love.audio.stop(validateSound)
	love.audio.play(validateSound)
end


-- supprimer les commentaires d'une ligne de code
function RemoveComments(s)
	-- retourner nil si la chaîne est vide
	if s == nil then return nil, OK end
	
	-- trouver la première apostrophe
	local pos = string.find(s, "'")
	
	if pos ~= nil then
		-- compter les guillemets précédents
		local sg = string.sub(s, 1, pos - 1)
		local _, count = string.gsub(sg, "\"", "")
		if count % 2 == 1 then return s, OK end
	
		-- retourner la chaîne sans l'apostrophe
		if pos > 1 then
			if string.sub(s, pos - 1, pos - 1) ~= " " then
				return nil, ERR_SYNTAX_ERROR
			end
			
			return string.sub(s, 1, pos - 2), OK
		else
			return nil, OK
		end
	end
	
	return s, OK
end

-- trouver les commentaires d'une ligne de code
function ScanComments(s)
	-- retourner nil si la ligne est vide
	if s == nil or s == "" then return nil end
		
	-- trouver la première apostrophe
	local pos = string.find(s, "'")
	
	if pos ~= nil then
		-- compter les guillemets précédents
		local sg = string.sub(s, 1, pos - 1)
		local _, count = string.gsub(sg, "\"", "")
		if count % 2 == 1 then return nil end

		-- retourner la chaîne sans l'apostrophe
		return string.sub(s, pos)
	end
	
	return nil
end

-- scanner tous les labels présents dans le code
function ScanLabels()
	-- vider les précédents labels
	labels = {}
	labCount = 0
	
	-- puis, détecter et stocker les labels
	for i = 1, #ram do	
		-- retourner nil si la chaîne est vide
		if ram[i] ~= nil then
			s = RemoveComments(ram[i])
		
			if s ~= nil then
				local l = string.find(s, ":")
				if l ~= nil then
					-- détection d'erreurs
					if l == 1 then goto continue end
					if l > 9 then goto continue end
					
					-- vérifier la syntaxe de l'éventuel label trouvé
					for j = 1, l - 1 do
						local c = string.lower(string.sub(s, j, j))
						if (c < "a" or c > "z") and (c < "0" or c > "9") and c ~= "-" and c ~= "_" and c ~= "@" then
							goto continue
						end
					end
					
					-- vérifier que le label ne soit pas un mot clé
					for j = 1, #commands do
						if commands[j] == string.upper(string.sub(s, 1, l - 1)) then
							goto continue							
						end
					end
					
					-- vérifier que le label ne commence pas par un chiffre
					if string.sub(s, 1, 1) >= "0" and string.sub(s, 1, 1) <= "9" then
						return ERR_SYNTAX_ERROR, i
					end
					
					-- label correct trouvé
					labCount = labCount + 1
					labels[labCount] = string.sub(s, 1, l - 1)
					labPC[labCount] = i
					
					-- saut ici si label non trouvé
					::continue::
				end
			end
		end
	end
	
	-- chercher les doublons éventuels
	for i = 1, labCount do
		if labels[i] ~= nil then
			for j = i + 1, labCount do
				if labels[j] ~= nil then
					if string.lower(labels[i]) == string.lower(labels[j]) then
						return ERR_DUPLICATE_LABEL, j
					end
				end
			end
		end
	end
	
	return OK, nil
end

-- scanner le label éventuellement présent sur une ligne de code
function ScanCurrentLabels(s)
	-- rechercher un label éventuel
	if s ~= nil then
		s = RemoveComments(s)
		
		if s ~= nil then
			local l = string.find(s, ":")
			if l ~= nil then
				-- détection d'erreurs
				if l == 1 then goto continue end
				if l > 9 then goto continue end
				
				-- vérifier la syntaxe des labels
				for j = 1, l - 1 do
					local c = string.lower(string.sub(s, j, j))
					if (c < "a" or c > "z") and (c < "0" or c > "9") and c ~= "-" and c ~= "_" and c ~= "@" then
						goto continue
					end
				end
					
				-- vérifier que le label ne soit pas un mot clé
				for j = 1, #commands do
					if commands[j] == string.upper(string.sub(s, 1, l - 1)) then
						goto continue							
					end
				end
				
				-- le label ne doit pas commencer par un nombre
				if string.sub(s, 1, 1) >= "0" and string.sub(s, 1, 1) <= "9" then
					return nil
				else
					-- label correct trouvé
					return string.sub(s, 1, l - 1)
				end
					
				-- saut ici si label non trouvé
				::continue::
			end
		end
	end
	
	return nil
end

function RemoveLabels(s)
	-- retourner nil si la ligne est vide
	if s == nil or s == "" then return nil end

	for i = 1, labCount do
		if labels[i] .. ":" == string.sub(s, 1, #labels[i] + 1) then
			-- supprimer l'éventuel label de la ligne
			s = Trim(string.sub(s, #labels[i] + 2))
			break
		end
	end
	
	return s
end

-- exécuter une seule commande
function ExecuteOneTime(cs, lst)
	paramsCount = #lst
	
	-- erreurs sur le nombre de paramètres ?
	if cmd[cs].pmin == 0 and cmd[cs].pmax == 0 and paramsCount > 0 then
		return ERR_SYNTAX_ERROR, nil
	elseif cmd[cs].pmin >= 0 and paramsCount < cmd[cs].pmin then
		return ERR_OPERAND_MISSING, nil
	elseif cmd[cs].pmax >= 0 and paramsCount > cmd[cs].pmax then
		return ERR_TOO_MANY_OPERANDS, nil
	end
	
	local e, value = cmd[cs].fn(lst)

	return e, value
end

-- assigne une expression à une variable
function AssignToVar(var, vType, s)
	local pointer = 0
	local e = 0
	
	-- voir si la variable existe
	for i = 1, #vram do
		if vram[i][1] == string.upper(var) then
			pointer = i

			break
		end
	end
	
	-- si la variable n'existe pas, on l'initialise
	if pointer == 0 then
		if #vram < MAX_RAM then
			local vVal = nil
					
			if vType == VAR_INTEGER then
				vVal = 0
			elseif vType == VAR_FLOAT then
				vVal = 0.0
			elseif vType == VAR_STRING then
				vVal = ""
			end

			table.insert(vram, {string.upper(var), vVal, vType})
			
			pointeur = #vram			
		else
			-- sauf si la mémoire est pleine...
			return ERR_MEMORY_FULL
		end
	end
	
	-- stocker la valeur de l'expression dans la variable
	if vType == VAR_INTEGER then
		vram[pointeur][2], e = EvalInteger(s)
	elseif vType == VAR_FLOAT then
		vram[pointeur][2], e = EvalFloat(s)
	else
		vram[pointeur][2], e = EvalString(s, true)
	end
			
	return e
end

-- exploser la ligne de commande et l'exécuter
function Execute(t, l)
	local cs = nil
	local cs2 = nil
	local cs3 = nil
	local cn = nil
	
	local row = l
	local column = currentCommandColumn
	
	-- retourner si la table est vide
	if t == nil or #t == 0 then return OK end

	-- retourner si le nombre de parenthèses est impair
	local obracket = 0
	local cbracket = 0
	local cln = 0
	local lst = {}
	
	for i = 1, #t do
		if t[i].typ == "openbracket" then
			obracket = obracket + 1
		elseif t[i].typ == "closebracket" then
			cbracket = cbracket + 1
		elseif t[i].typ == "colon" then
			cln = cln + 1
		end
	end
	
	if obracket ~= cbracket then return ERR_SYNTAX_ERROR end
	
	-- supprimer les blancs au début et à la fin de la phrase
	if #t > 0 and t[#t].typ == "whitespace" then table.remove(t, #t) end
	if #t > 0 and t[1].typ == "whitespace" then table.remove(t, 1) end
	
	-- exécuter les morceau de code en fonction des séparateurs 'deux points'
	local t2 = {}
	local e = OK
	
	for i = 1, #t do
		if t[i].typ == "colon" then
			-- exécuter un tronçon de code
			if #t2 > 0 then
				e = Execute(t2, l)

				if e ~= OK then return e end
				
				-- vider le tampon de commandes
				t2 = {}
			end
		elseif t[i].typ ~= "colon" and cln > 0 and i == #t then
			table.insert(t2, t[i])

			-- exécuter un tronçon de code
			if #t2 > 0 then
				e = Execute(t2, l)

				if e ~= OK then return e end
				
				-- vider le tampon de commandes
				t2 = {}
			end			
		else
			table.insert(t2, t[i])
		end
	end

	-- n'exécuter que les morceaux de code unique
	if cln > 0 then return OK end
	
	-- le début du tronçon de texte est une commande ?
	local maxpnum = 0
	local i = 1

	if t[i].typ == "command" then
		-- mémoriser la 1ère commande dans cs
		cs = t[i].sym
		
		-- mémoriser la commande courante pour usage futur
		currentCommand = cs
		
		-- établir le numéro de colonne de la commande
		column = column + 1
		currentCommandColumn = column
		
		-- zapper la commande si nécessaire
		if gotoCommand > 0 then
			if gotoCommand < currentLoopCommandID then return OK end
		end
		
		-- mémoriser la prochaine commande nécessaire
		if t[i].pnext ~= nil then cn = t[i].pnext end
		
		-- erreur si une fonction est trouvée en tant que commande, sans assignation à une variable
		if cmd[cs].ret > 0 then return ERR_SYNTAX_ERROR end
		
		-- vérifier la suite
		i = i + 1
		
		if i <= #t then
			-- vérifier le type de paramètre admis par cette commande
			if #cmd[cs].ptype > 1 then
				-- si c'est une liste de paramètres...
				maxpnum = #cmd[cs].ptype
			else
				-- si c'est une bloc chainé
				maxpnum = cmd[cs].pmax
			end

			if maxpnum < 0 then
				-- si l'expression est un bloc chainé...
				e, lst = EvalExpression(t, tp, i, cs, maxpnum)
				
				if e ~= OK then return e end
			elseif t[i].typ == "whitespace" then
				-- vérifier s'il s'agit bien d'une suite de commandes multiples
				if cmd[cs].cmd == MULTI_COMMAND then
					-- incrémenter le nombre de commandes
					currentLoopCommandID = currentLoopCommandID + 1
					
					currentLoopCommand = currentCommand

					-- si c'est une commande nécessitant d'assigner une variable
					if cmd[cs].ptype[1] == VAR_ASSIGN then
						-- on est dans une boucle itérative ?
						local loopMode = false
												
						-- stocker
						if iterator[row][column][1] == 0 and iterator[row][column][2] == 0 and iterator[row][column][3] == 0 then
							local e = PushIterator(string.upper(cs), row, column, currentLoopCommandID)
							
							if e ~= OK then return e end
						else
							loopMode = true
						end

						i = i + 1
						
						if t[i].typ ~= "word" then return ERR_SYNTAX_ERROR end
						
						local var = t[i].sym
												
						-- vérifier si la variable possède un symbole à la fin
						-- afin de définir le type de variable
						local vType = VAR_INTEGER

						i = i + 1
						-- erreur d'assignation
						if i > #t then return ERR_SYNTAX_ERROR end

						-- vérifier le type de la variable à assigner
						if t[i].typ == "integer" then
							var = var .. "!"

							i = i + 1
							
							-- erreur d'assignation
							if i > #t then return ERR_SYNTAX_ERROR end
						elseif t[i].typ == "float" then
							var = var .. "%"
							vType = VAR_FLOAT

							i = i + 1
							
							-- erreur d'assignation
							if i > #t then return ERR_SYNTAX_ERROR end
						elseif t[i].typ == "string" then
							var = var .. "$"
							vType = VAR_STRING

							i = i + 1
							
							-- erreur d'assignation
							if i > #t then return ERR_SYNTAX_ERROR end
						end

						-- vérifier la présence d'un espace
						if t[i].typ == "whitespace" then i = i + 1 end

						-- erreur d'assignation
						if i > #t then return ERR_SYNTAX_ERROR end

						-- vérifier la présence du symbole égal
						if t[i].typ == "equal" then i = i + 1 end

						-- erreur d'assignation
						if i > #t then return ERR_SYNTAX_ERROR end

						-- vérifier la présence d'un espace
						if t[i].typ == "whitespace" then i = i + 1 end

						-- erreur d'assignation
						if i > #t then return ERR_SYNTAX_ERROR end

						-- on a trouvé la variable sur laquelle travailler
						table.insert(lst, var)

						-- on a trouvé le type de variable sur laquelle travailler
						table.insert(lst, vType)
						
						-- vérifier la présence de données à assigner à la variable
						local s = ""
						local i2 = nil
						
						for j = i, #t do
							if t[j].typ == "whitespace" then
								if j < #t then
									if t[j + 1].typ == "command" then
										i2 = j + 1
										break
									end
								end
							end
							
							s = s .. t[j].sym
						end

						-- prêt à assigner l'expression à la variable
						if not loopMode then 
							table.insert(lst, s)
						-- .. ou à en augmenter la valeur précédente
						else
							table.insert(lst, tostring(iterator[row][column][1]))
						end

						-- exécuter la commande avec ses paramètres
						local e
						e = ExecuteOneTime(cs, lst)

						if e ~= OK then return e end
						
						-- commande incomplète... erreur
						if t[i2].typ ~= "command" then return ERR_SYNTAX_ERROR end

						-- mémoriser la prochaine commande nécessaire
						cn = t[i2].pnext

						-- commande attendue non présente
						if cn ~= t[i2].pnext then return ERR_SYNTAX_ERROR end
						
						-- mémoriser la suite de commande trouvée
						cs2 = t[i2].sym

						-- vérifier s'il s'agit bien d'une suite de commande multiple
						if cmd[cs2].cmd ~= USED_BY_MULTICOMMAND then return ERR_SYNTAX_ERROR end

						i2 = i2 + 1

						-- erreur d'assignation
						if i2 > #t then return ERR_SYNTAX_ERROR end

						-- vérifier la présence d'un espace
						if t[i2].typ == "whitespace" then i2 = i2 + 1 end

						-- erreur d'assignation
						if i2 > #t then return ERR_SYNTAX_ERROR end

						-- vérifier le type de paramètres requis par la deuxième commande
						if cmd[cs2].ptype[1] == VAR_CONSTANT then
							-- paramètres constantes nécessaire
							if t[i2].typ ~= "number" then return ERR_SYNTAX_ERROR end
							
							local it1 = GetVarValue(var, vType)
							local it2 = Val(t[i2].sym)

							-- vérifier la présence d'un espace
							if t[i2].typ == "whitespace" then i2 = i2 + 1 end
	
							-- erreur d'assignation
							if i2 > #t then return ERR_SYNTAX_ERROR end
							
							-- une troisième commande est elle obligatoire ?
							-- TODO!
							-- si oui...

							-- sinon...
							if not loopMode then
								iterator[row][column] = {it1, it2, 1, var}
							end
							
							return OK
						else
							return ERR_SYNTAX_ERROR
						end
					elseif cmd[cs].ptype[1] == VAR_CONDITION then
						-- espace manquant avant les paramètres
						if t[i].typ ~= "whitespace" then return ERR_SYNTAX_ERROR end
						
						i = i + 1
						
						-- paramètre manquant
						if i > #t then return ERR_SYNTAX_ERROR end

						-- assembler les paramètres
						local s = ""
						
						for j = i, #t do						
							s = s .. t[j].sym
						end

						-- ajouter les paramètres à la liste
						table.insert(lst, s)
											
						PushIterator(cs, row, column, currentLoopCommandID)
					else
						return ERR_SYNTAX_ERROR
					end
				elseif cmd[cs].cmd == USED_BY_MULTICOMMAND then
					if i < #t then
						-- vérifier la présence d'un espace
						if t[i].typ == "whitespace" then i = i + 1 end
	
						-- erreur d'assignation
						if i > #t then return ERR_SYNTAX_ERROR end
						
						-- chercher une variable
						if cmd[cs].ptype[1] == VAR_VAR then
							if t[i].typ == "integer" or t[i].typ == "float" or t[i].typ == "string" or t[i].typ == "word" then
								table.insert(lst, t[i].sym)
								
								i = i + 1
								
								-- erreur d'assignation
								if i <= #t then							
									-- vérifier la présence d'un espace
									if t[i].typ ~= "whitespace" then return ERR_SYNTAX_ERROR end
									
									i = i + 1
									
									if i <= #t then return ERR_SYNTAX_ERROR end
								end
							end
						end
					end
				else
					-- si c'est une liste de paramètres
					e, lst = EvalParamList(t, i, cs, maxpnum)
					
					if e ~= OK then return e end
				end
			else
				return ERR_SYNTAX_ERROR
			end
		end
		
		-- si une commande est recherchée...
		if searchCommand ~= "" then
			if searchCommand == cs and searchLoopCommandID == currentLoopCommandID then searchCommand = ""; searchLoopCommandID = 0 end

			return OK
		end
		
		-- si la commande est une fonction de boucle
		if cmd[cs].loopFn then
			PushIterator(cs, row, column, currentLoopCommandID)
		end
				
		-- exécuter la commande avec ses paramètres
		local e = ExecuteOneTime(cs, lst)
		
		-- si la commande est une fonction de boucle
		if cmd[cs].loopFn then
			-- compteur de commandes
			currentLoopCommandID = currentLoopCommandID - 1			
		end

		return e
	-- variable éventuellement trouvée
	elseif t[i].typ == "word" or t[i].typ == "integer" or t[i].typ == "float" or t[i].typ == "string" then
		local var = t[i].sym
		
		-- vérifier si la variable a un autre type qu'integer par défaut
		-- afin de définir le type de variable
		local vType = DEFAULT_VAR_TYPE
		
		if t[i].typ == "integer" then
			vType = VAR_INTEGER
		elseif t[i].typ == "float" then
			vType = VAR_FLOAT
		elseif t[i].typ == "string" then
			vType = VAR_STRING
		end
		
		i = i + 1
		
		-- variable sans assignation... erreur
		if i > #t then return ERR_SYNTAX_ERROR end
		
		if t[i].typ == "whitespace" then i = i + 1 end
		
		-- variable sans assignation... erreur
		if i > #t then return ERR_SYNTAX_ERROR end

		-- vérifier la présence du symbole égal pour l'assignation, sinon erreur...
		if t[i].typ == "equal" then
			i = i + 1
			
			-- variable sans assignation... erreur
			if i > #t then return ERR_SYNTAX_ERROR end			
		else
			return ERR_SYNTAX_ERROR
		end
		
		if t[i].typ == "whitespace" then i = i + 1 end
		
		-- variable sans assignation... erreur
		if i > #t then return ERR_SYNTAX_ERROR end
		
		-- scanner les données à assigner
		local s = ""
		local s1 = ""
		local s2 = ""
		
		for j = i, #t do
			-- récupérer un morceau de ce qu'il faut assigner
			if t[j].typ == "whitespace" then
				-- un espace, non comptabilisé
			elseif t[j].typ == "text" then
				s1 = s1 .. t[j].sym
			elseif t[j].typ == "command" then
				s1 = s1 .. t[j].sym
			elseif t[j].typ == "openbracket" then
				s1 = s1 .. t[j].sym
			elseif t[j].typ == "closebracket" then
				s1 = s1 .. t[j].sym
			elseif t[j].typ == "word" then
				-- vérifier le type de variable pour assignation
				if vType == VAR_INTEGER then
					local n, e = EvalInteger(t[j].sym)
					
					if e ~= OK then return e end
					
					s1 = s1 .. "\"" .. tostring(n) .. "\""
				elseif vType == VAR_FLOAT then
					local n, e = EvalFloat(t[j].sym)		
					
					if e ~= OK then return e end
					
					s1 = s1 .. "\"" .. tostring(n) .. "\""
				else
					s, e = EvalString(t[j].sym)
					
					if e ~= OK then return e end

					s1 = s1 .. "\"" .. s .. "\""
				end
			elseif t[j].typ == "integer" then
				local n, e = EvalInteger(t[j].sym)
			
				if e ~= OK then return e end
			
				s1 = s1 .. "\"" .. tostring(n) .. "\""
			elseif t[j].typ == "float" then
				local n, e = EvalFloat(t[j].sym)
			
				if e ~= OK then return e end
			
				s1 = s1 .. "\"" .. tostring(n) .. "\""
			elseif t[j].typ == "string" then
				s, e = EvalString(t[j].sym)
				
				if e ~= OK then return e end

				s1 = s1 .. "\"" .. s .. "\""
			elseif t[j].typ == "plus" then
				s1 = s1 .. "+"
			else
				return ERR_SYNTAX_ERROR
			end
		end

		-- évaluer la somme des morceaux de chaine
		s2, e = EvalString(s1)
		
		if e ~= OK then return e end

		-- assigner l'expression à la variable
		local e = AssignToVar(var, vType, "\"" .. s2 .. "\"")
		
		return e
	end

	return OK
end

-- assembler un tronçon de chaîne de caractère
function AssembleString(t, cs, lst, sig)
	local i = 1
	
	while i <= #t do
		if t[i].typ == "whitespace" and i == #t then
			-- vérifier la suite
			i = i + 1

			-- dernière commande après un espace
			if i > #t then
				-- mixer tout de suite la chaîne et l'analyser
				local p = ""
				
				for j = 1, #lst do
					p = p .. lst[j]
				end

				p, e = EvalString(p)
				if e ~= OK then return e, lst, sig end

				lst = {p}
			
				-- exécuter la commande
				local e = ExecuteOneTime(cs, lst)
				
				-- erreur ?
				if e ~= OK then return e, nil, sig else return OK, lst, sig end
			end
		-- ajouter les chaînes de caractère à la liste
		elseif t[i].typ == "text" then
			table.insert(lst, t[i].sym)
		-- ajouter les valeurs numériques à un buffer
		elseif t[i].typ == "number" then
			table.insert(lst, t[i].sym)
		-- une commande de fonction est trouvée
		elseif t[i].typ == "command" then
			-- mémoriser la commande dans cs2
			local cs2 = t[i].sym
			local lst2 = {}
			
			-- erreur si une fonction n'est pas trouvée en tant que commande
			if cmd[cs2].ret == 0 then return ERR_SYNTAX_ERROR, nil, sig end
		
			-- vérifier la suite
			i = i + 1
			if i > #t then return ERR_SYNTAX_ERROR, nil, sig end
				
			-- vérifier le type de paramètres admis par cette commande
			if #cmd[cs2].ptype > 1 then
				maxpnum = #cmd[cs2].ptype
			else
				maxpnum = cmd[cs2].pmax
			end
				
			-- si l'expression a une commande en amont...
			if t[i].typ ~= "openbracket" then return ERR_SYNTAX_ERROR, nil, sig end
			if t[#t].typ ~= "closebracket" then return ERR_SYNTAX_ERROR, nil, sig end
					
			-- supprimer les parenthèses
			table.remove(t, #t)
			table.remove(t, i)
			
			-- commande avec paramètres
			if i <= #t then
				-- évaluer l'expression
				e, lst2 = EvalParamList(t, i, cs2, maxpnum)
				
				-- erreur ?
				if e ~= OK then return e, lst, sig end
			end

			-- exécuter la commande
			local e, value = ExecuteOneTime(cs2, lst2)

			-- ajouter le résultat à la liste de retour
			table.insert(lst, "\"" .. value .. "\"")
				
			return e, lst, sig
		-- chercher un symbole de concaténation de chaînes (plus ou point virgule)
		elseif t[i].typ == "plus" then
			-- mélanges de plus et de point-virgule
			if sig == "semicolon" then break end

			sig = "plus"

			-- erreur si la partie suivante est un nombre
			if i + 1 <= #t and t[i + 1].typ == "number" then return ERR_TYPE_MISMATCH, nil, sig end
		elseif t[i].typ == "semicolon" then
			-- éviter les mélanges du plus et du point-virgule
			if sig == "plus" then break end

			sig = "semicolon"
			
			-- erreur si la partie suivante est un nombre
			if i + 1 <= #t and t[i + 1].typ == "number" then return ERR_TYPE_MISMATCH, nil, sig end
			
			-- si point virgule en fin de ligne...
			if i == #t and #t > 1 and t[i - 1].typ == "text" then table.insert(lst, ";") end
		elseif t[i].typ == "word" then
			-- vérifier si c'est un label
			for j = 1, labCount do
				if string.lower(labels[j]) == string.lower(t[i].sym) then
					-- si oui...
					local l, e = EvalLabel(t[i].sym)
			
					table.insert(lst, l)
						
					if e~= OK then return ERR_UNDEFINED_LABEL, nil, sig else return OK, lst, sig end
				end
			end
			
			-- vérifier si c'est une variable existante
			local var = t[i].sym
			local vType = GetVarType(var)
			local value = "0"
			
			if vType == 0 then
				vType = VAR_INTEGER

				e = AssignToVar(var, vType, value)
				
				if e ~= OK then return e, nil end
			-- sinon, récupérer la valeur de la variable
			else
				value, e = GetVarValue(var, vType)
				
				if e ~= OK then return e, nil end
			end

			table.insert(lst, value)
			
			return OK, lst, sig
		elseif t[i].typ == "integer" or t[i].typ == "float" or t[i].typ == "string" then
			-- vérifier si c'est une variable existante
			local var = t[i].sym
			local vType = 0
			
			if t[i].typ == "integer" then
				vType = VAR_INTEGER
			elseif t[i].typ == "float" then
				vType = VAR_FLOAT
			elseif t[i].typ == "string" then
				vType = VAR_STRING
			end

			-- essayer de récupérer la valeur de la variable
			local value, e = GetVarValue(var, vType)
				
			-- si erreur, on assigne à la place
			if e == ERR_TYPE_MISMATCH then
				local value = 0

				e = AssignToVar(var, vType, tostring(value))
				
				if e ~= OK then return e, nil end
			end

			table.insert(lst, value)
			
			return OK, lst, sig
		else
			break
		end
		
		i = i + 1
		
		if i > #t then return OK, lst, sig end
	end

	return ERR_SYNTAX_ERROR, nil, sig
end

-- évaluer toute une expression chaîne de caractère
function EvalExpression(t, tp, i, cs, maxpnum)
	local lst = {}
	local sig = nil

	-- supprimer les espaces de début et de fin
	if t[i].typ == "whitespace" then table.remove(t, i) end
	if t[#t].typ == "whitespace" then table.remove(t, #t) end

	-- erreur si le terme commence ou se termine par une virgule
	if t ~= nil then
		if t[i].typ == "comma" or t[#t].typ == "comma" then
			return ERR_SYNTAX_ERROR, nil
		end
	end
	
	if cmd[cs].ptype[1] ~= VAR_POLY and cmd[cs].ptype[1] ~= VAR_STRING then return ERR_TYPE_MISMATCH, nil end

	-- séparer les morceaux de textes par des virgules
	t2 = {}
	
	for i2 = i, #t do
		if t[i2].typ ~= "comma" and i2 == #t then
			table.insert(t2, t[i2])
					
			-- assembler les morceaux de chaîne entre-eux
			local e, lst, sig = AssembleString(t2, cs, lst, sig)

			-- erreur ?
			if e ~= OK then return e, nill end
					
			i = i2 + 1
			t2 = {}
		elseif t[i2].typ ~= "comma" then
			table.insert(t2, t[i2])
		elseif t[i2].typ == "comma" then
			-- assembler les morceaux de chaîne entre-eux
			local e, lst, sig = AssembleString(t2, cs, lst, sig)

			-- erreur ?
			if e ~= OK then return e, nill end
			
			table.insert(lst, " ")
			
			i = i2 + 1
			t2 = {}
		end
	end
	
	return OK, lst
end

-- évaluer une liste de paramètres et les retourner
function EvalParamList(t, i, cs, maxpnum)
	local lst = {}
	local sig = nil
	local nexp = ""
	local value = ""	
	local cm = false
	local limit = #cmd[cs].ptype

	-- commande sans paramètres
	if maxpnum == 0 then
		-- erreur !
		if t[#t].typ == "comma" then return ERR_SYNTAX_ERROR, nil end
		if t[#t].typ == "whitespace" and #t - 1 > 0 and t[#t - 1].typ == "comma" then return ERR_SYNTAX_ERROR, nil end

		-- paramètres trouvés ?
		while t[i].typ == "whitespace" do
			-- vérifier la suite
			i = i + 1
			
			if i > #t then return OK, lst end
		end
		
		local alt = false
		
		while i <= #t do
			if not alt and t[i].typ ~= "number" then return ERR_SYNTAX_ERROR, nil end
			if alt and t[i].typ ~= "comma" then return ERR_SYNTAX_ERROR, nil end
			
			i = i + 1
			alt = not alt
		end
		
		return ERR_TOO_MANY_OPERANDS, nil
	end
	
	-- scanner les types de paramètres d'entrées nécessaires
	for j = 1, maxpnum do
		local k = math.min(j, limit)
		
		-- ignorer les espaces
		while t[i].typ == "whitespace" do
			-- vérifier la suite
			i = i + 1
			
			if i > #t then return OK, lst end
		end
				
		-- pas de virgule tout de suite après une commande
		-- qui nécessite des paramètres
		if t[i].typ == "comma" then
			if cm == false then
				return ERR_SYNTAX_ERROR, nil
			else
				cm = false
						
				-- vérifier la suite
				i = i + 1
						
				-- virgule à la fin de la ligne
				if i > #t then return ERR_SYNTAX_ERROR, nil end
			end
		end
		
		-- détecter les paramètres numériques entiers
		if cmd[cs].ptype[k] == VAR_INTEGER then
			if t[i].typ == "number" then
				cm = true

				local n, e = EvalInteger(t[i].sym)
				if e ~= OK then return e, nil end

				table.insert(lst, n)

				-- vérifier la suite
				i = i + 1
				
				if i > #t then return OK, lst end
			elseif t[i].typ == "word" then
				cm = true

				local v, e = GetVarValue(t[i].sym, VAR_INTEGER)
								
				if e ~= OK then return e, nil end
				
				table.insert(lst, v)

				-- vérifier la suite
				i = i + 1
				
				if i > #t then return OK, lst end
			else
				return ERR_TYPE_MISMATCH, nil
			end
		-- détecter les paramètres numériques réels
		elseif cmd[cs].ptype[k] == VAR_FLOAT then
			if t[i].typ == "number" then
				cm = true
				
				local n, e = EvalFloat(t[i].sym)
				
				if e ~= OK then return e, nil end
						
				table.insert(lst, n)
						
				-- vérifier la suite
				i = i + 1
				
				if i > #t then return OK, lst end
			elseif t[i].typ == "word" then
				cm = true

				local v, e = GetVarValue(t[i].sym, VAR_FLOAT)
				
				if e ~= OK then return e, nil end
				
				table.insert(lst, v)

				-- vérifier la suite
				i = i + 1
				
				if i > #t then return OK, lst end
			else
				return ERR_TYPE_MISMATCH, nil
			end
		elseif cmd[cs].ptype[k] == VAR_NUM then
			if t[i].typ == "number" then
				cm = true

				local n, e = EvalFloat(t[i].sym)
				if e ~= OK then return e, nil end

				table.insert(lst, n)
						
				-- vérifier la suite
				i = i + 1
				if i > #t then return OK, lst end
			elseif t[i].typ == "word" then
				cm = true

				local v, e = GetVarValue(t[i].sym, VAR_FLOAT)
				
				if e ~= OK then return e, nil end
				
				table.insert(lst, v)

				-- vérifier la suite
				i = i + 1
				
				if i > #t then return OK, lst end
			else
				return ERR_TYPE_MISMATCH, nil
			end
		elseif cmd[cs].ptype[k] == VAR_POLY or cmd[cs].ptype[k] == VAR_STRING then
			if t[i].typ == "string" then
				cm = true

				local s, e = EvalString(t[i].sym)
				
				if e ~= OK then return e, nil end

				table.insert(lst, s)

				-- vérifier la suite
				i = i + 1
				
				if i > #t then return OK, lst end
			elseif t[i].typ == "word" then
				cm = true

				local v, e = GetVarValue(t[i].sym, VAR_STRING)
				
				if e ~= OK then return e, nil end
				
				table.insert(lst, v)

				-- vérifier la suite
				i = i + 1
				
				if i > #t then return OK, lst end
			else
				return ERR_TYPE_MISMATCH, nil
			end
		elseif cmd[cs].ptype[k] == VAR_LABEL then
			local l, e = EvalLabel(t[i].sym)

			table.insert(lst, l)
			
			if e~= OK then return ERR_UNDEFINED_LABEL, nil end
		end
		
		-- erreur !
		if t[#t].typ == "comma" then return ERR_SYNTAX_ERROR, nil end
		if t[#t].typ == "whitespace" and #t - 1 > 0 and t[#t - 1].typ == "comma" then return ERR_SYNTAX_ERROR, nil end

		-- trop de paramètres ?
		if j == maxpnum then
			if i < #t then return ERR_TOO_MANY_OPERANDS, nil end
		end
	end
	
	return OK, lst
end

-- évaluer le type d'une expression numérique
function EvalNumber(s)
	local v, e = EvalInteger(s)

	if e ~= OK then return nil end
	
	-- le nombre est un integer
	if tostring(v) == s then return VAR_INTEGER end

	local v, e = EvalFloat(s)

	if e ~= OK then return nil end

	return VAR_FLOAT
end

-- évaluer une expression integer
function EvalInteger(s)
	if s == nil or s == "" then return nil, ERR_SYNTAX_ERROR end
	
	local v, e = EvalFloat(s)
	
	if e == OK then	return Round(v), OK end

	return nil, e
end

-- évaluer une expression float
function EvalFloat(s)
	if s == nil or s == "" then return nil, ERR_SYNTAX_ERROR end

	local pnum = 1
	
	-- analyser l'expression
	local t = Parser(Lexer(RemoveLabels(s)))
	s = ""
		
	-- vérifier si l'expression est un simple nombre
	if #t == 1 then
		if t[1].typ == "number" then
			return Val(t[1].sym), OK
		end
	end

	for i = 1, #t do	
		if t[i].typ == "operator" then
			if t[i].sym == "AND" then
				t[i].sym = "A"
			elseif t[i].sym == "MOD" then
				t[i].sym = "M"
			elseif t[i].sym == "NOT" then
				t[i].sym = "N"
			elseif t[i].sym == "OR" then
				t[i].sym = "O"
			elseif t[i].sym == "XOR" then
				t[i].sym = "X"
			end			
		end
	end

	local i = 1
	while i <= #t do
		-- pour chaque commande présente dans l'expression...
		if t[i].typ == "error" then
			-- détecter les erreurs
			return nil, ERR_SYNTAX_ERROR
		elseif t[i].typ == "whitespace" then
			--s = s .. t[i].sym
		elseif t[i].typ == "command" then
			-- vérifier que la commande ne retourne pas une chaîne de caractères
			if cmd[t[i].sym].ret == VAR_STRING then return nil, ERR_TYPE_MISMATCH end

			-- récupérer la commande et ses paramètres
			local c, p, e
			c, p, i, e = GetFunction(t, i)
			if e ~= OK then return nil, e end

			-- quel est le type de paramètres requis par la commande ?
			if cmd[c].ptype[pnum] == VAR_STRING then
				pnum = pnum + 1
				
				p, e = EvalString(p)
				if e ~= OK then return nil, e end

				-- remplacer par la valeur
				local lst = {Trim(p, "\"")}
				local e, value = cmd[c].fn(lst)
				if e ~= OK then return nil, e end

				s = s .. tostring(value)
			elseif cmd[c].ptype[pnum] == VAR_FLOAT then
				pnum = pnum + 1

				if tostring(Val(p)) ~= p then
					p, e = EvalFloat(p)
					if e ~= OK then return nil, e end
				end
				
				-- remplacer par la valeur
				local lst = {tostring(p)}
				local e, value = cmd[c].fn(lst)
				if e ~= OK then return nil, e end
				
				s = s .. tostring(value)
			elseif cmd[c].ptype[pnum] == VAR_INTEGER then
				pnum = pnum + 1

				if tostring(Val(p)) ~= p then
					p, e = EvalInteger(p)
					if e ~= OK then return nil, e end
				end
				
				-- remplacer par la valeur
				local lst = {tostring(p)}
				local e, value = cmd[c].fn(lst)
				if e ~= OK then return nil, e end
				
				s = s .. tostring(value)
			elseif cmd[c].ptype[pnum] == VAR_NUM then
				pnum = pnum + 1

				if tostring(Val(p)) ~= p then
					p, e = EvalFloat(p)
					if e ~= OK then
						p, e = EvalInteger(p)
					end
					if e ~= OK then return nil, e end
				end

				-- remplacer par la valeur
				local lst = {tostring(p)}
				local e, value = cmd[c].fn(lst)
				if e ~= OK then return nil, e end

				s = s .. tostring(value)
			end
			
			i = i + 1
		-- assembler avec des nombres et opérateurs
		elseif t[i].typ == "number" then
			s = s .. t[i].sym
		elseif t[i].typ == "float" then
			-- variable float trouvée
			s = s .. t[i].sym
		elseif t[i].typ == "integer" then
			-- variable integer trouvée
			s = s .. t[i].sym
		elseif t[i].typ == "word" then
			-- variable sans type trouvée
			s = s .. t[i].sym
		elseif t[i].typ == "plus" then
			s = s .. t[i].sym
		elseif t[i].typ == "minus" then
			s = s .. t[i].sym
		elseif t[i].typ == "mult" then
			s = s .. t[i].sym
		elseif t[i].typ == "div" then
			s = s .. t[i].sym
		elseif t[i].typ == "operator" then
			s = s .. t[i].sym
		elseif t[i].typ == "openbracket" then
			s = s .. t[i].sym
		elseif t[i].typ == "closebracket" then
			s = s .. t[i].sym
		--elseif t[i].typ == "comma" then -- TODO: à supprimer ?
			--s = s .. t[i].sym
		elseif t[i].typ ~= "text" then
			-- symbole non autorisé ? erreur de syntaxe !
			return nil, ERR_SYNTAX_ERROR
		end
				
		i = i + 1
	end
	
	-- valeur de retour
	local v = 0

	-- compter les parenthèses
	local p1 = 0
	local p2 = 0
	
	for i in string.gfind(s, "%(") do
		p1 = p1 + 1
	end

	for i in string.gfind(s, "%)") do
		p2 = p2 + 1
	end

	-- erreur si le nombre de parenthèses est impair
	if p1 ~= p2 then return nil, ERR_SYNTAX_ERROR end

	-- compter le nombre de niveaux de parenthèses (profondeur)
	p1 = 0
	p2 = 0
	
	for i = 1, #s do
		c = string.sub(s, i, i)

		if c == "(" then
			p2 = p2 + 1
			
			if p2 > p1 then p1 = p2 end
		end

		if c == ")" then p2 = p2 - 1 end
	end

	p2 = 0
	
	-- recalculer les morceaux d'expression entre parenthèses
	local s2 = ""

	if p1 > 0 then
	
		local i1 = 0
		local i2 = 0
		
		-- aller des expressions entre parenthèse les plus prioritaires vers les moins prioritaires
		for j = p1, 1, -1 do
			for i = 1, #s do
				c = string.sub(s, i, i)
			
				if c == "(" then
					p2 = p2 + 1
					
					if p2 == j then
						i1 = i + 1
					elseif p2 < j then
						s2 = s2 .. c
					end
				elseif c == ")" then					
					if p2 < j then
						s2 = s2 .. c
					end

					p2 = p2 - 1
	
					if p2 == j - 1 then

						i2 = i - 1

						local n, e = EvalFloat(string.sub(s, i1, i2))
						
						if e ~= OK then return nil, ERR_SYNTAX_ERROR end
						
						s2 = s2 .. tostring(n)
					end
				elseif p2 < j then
					s2 = s2 .. c
				end
			end

			s = s2
			s2 = ""
		end
	end
			
	-- recalculer les morceaux d'expression dans l'ordre des priorités d'opérations
	s, e = Calc(s, "N")
	if e ~= OK then return nil, e end

	s, e = Calc(s, "*")	
	if e ~= OK then return nil, e end

	s, e = Calc(s, "/")	
	if e ~= OK then return nil, e end

	s, e = Calc(s, "M")
	if e ~= OK then return nil, e end

	s, e = Calc(s, "A")
	if e ~= OK then return nil, e end

	s, e = Calc(s, "OR")
	if e ~= OK then return nil, e end

	s, e = Calc(s, "XOR")
	if e ~= OK then return nil, e end

	s, e = Calc(s, "-")	
	if e ~= OK then return nil, e end

	s, e = Calc(s, "+")	
	if e ~= OK then return nil, e end

	-- scanner pour trouver un nombre ou une variable
	local isVar = nil
	
	for i = 1, #s do
		local c = string.upper(string.sub(s, i, i))
			
		if c == "." and (isVar == nil or not isVar)  then
			isVar = false
		elseif (c >= "A" and c <= "Z") and (isVar == nil or isVar)  then
			isVar = true
		elseif (c == "_" or c == "!" or c == "%") and (isVar == nil or isVar)  then
			isVar = true
		elseif c == "&" and (isVar == nil or isVar)  then
			isVar = false
		end
	end
	
	if isVar then
		-- gestion des erreurs
		if s == "!" or s == "%" then return nil, ERR_SYNTAX_ERROR end
			
		for i = 1, #s - 1 do
			if string.sub(s, i, i) == "!" or string.sub(s, i, i) == "%" then
				return nil, ERR_SYNTAX_ERROR
			end
		end
			
		if string.sub(s, 1, 1) >= "0" and string.sub(s, 1, 1) <= "9" then
			return nil, ERR_SYNTAX_ERROR
		end
			
		-- trouver la variable si elle existe
		for i = 1, #vram do
			if vram[i][1] == string.upper(s) then
				v = vram[i][2]
				break
			elseif i == #vram then
				if #vram < MAX_RAM then
					vType = VAR_INTEGER
					if string.sub(s, -1) == "%" then
						vType = VAR_FLOAT
					end
					table.insert(vram, {string.upper(s), 0, vType})
					break
				else
					return nil, ERR_MEMORY_FULL
				end
			end
		end
	else
		v = Val(s)
	end

	return v, OK
end

-- évaluer une expression chaîne de caractères
function EvalString(s, assign)
	if s == nil or s == "" then return "", OK end
	
	local pnum = 1

	-- évaluer la chaîne dans le cadre d'une assignation de valeur à une variable ?
	if assign == nil then assign = false end

	local t = Parser(Lexer(RemoveLabels(s)))
	s = ""
	
	-- ne pas attendre le prochain symbole d'assemblage des chaînes
	-- si waitsym est à false
	local waitsym = false
	
	-- symbole d'assemblage indéfini au départ
	local asym = ""
	
	-- ou fixé à '+' si une variable reçoit la chaîne en paramètre
	if assign then asym = "+" end
	
	-- assembler les valeurs
	local i = 1
	while i <= #t do
		if t[i].typ == "error" then
			-- détecter les erreurs
			return nil, ERR_SYNTAX_ERROR
		elseif not waitsym then
			if t[i].typ == "text" then
				s = s .. string.sub(t[i].sym, 2, -2)

				waitsym = true
			elseif t[i].typ == "string" then
				local var = string.upper(t[i].sym)
				local vType = VAR_STRING
				local value = ""
				local e = OK
				
				-- la variable n'existe pas...
				if GetVarType(var) == 0 then
					e = AssignToVar(var, vType, "")
					
					value = ""
				else
					value, e = GetVarValue(var, vType)
				end
				
				if e ~= OK then return nil, e end
				
				s = s .. value

				waitsym = true
			elseif t[i].typ == "number" then
				local value = t[i].sym

				s = s .. value
				
				waitsym = true
			elseif t[i].typ == "command" then
				-- vérifier que la commande retourne bien une chaîne de caractères
				if cmd[t[i].sym].ret ~= VAR_STRING then return nil, ERR_TYPE_MISMATCH end

				-- récupérer la commande et ses paramètres
				local c, p, e
				c, p, i, e = GetFunction(t, i)
				if e ~= OK then return nil, e end
				
				-- quel est le type de paramètres requis par la commande ?
				if cmd[c].ptype[pnum] == VAR_STRING then
					pnum = pnum + 1
					
					p, e = EvalString(p)
					if e ~= OK then return nil, e end

					local lst = {p}
					local e, ch = ExecuteOneTime(c, lst)
					if e ~= OK then return nil, e end
					
					s = s .. ch
					
					waitsym = true
				elseif cmd[c].ptype[pnum] == VAR_FLOAT then
					pnum = pnum + 1
					
					p, e = EvalFloat(p)
					if e ~= OK then return nil, e end
					
					local lst = {tostring(p)}
					local e, ch = ExecuteOneTime(c, lst)
					if e ~= OK then return nil, e end
					
					s = s .. ch
					
					waitsym = true
				elseif cmd[c].ptype[pnum] == VAR_INTEGER then
					pnum = pnum + 1
					
					p, e = EvalInteger(p)
					if e ~= OK then return nil, e end

					local lst = {tostring(p)}
					local e, ch = ExecuteOneTime(c, lst)
					if e ~= OK then return nil, e end
					
					s = s .. ch
					
					waitsym = true
				elseif cmd[c].ptype[pnum] == VAR_NUM then
					pnum = pnum + 1
					
					p, e = EvalFloat(p)
					if e ~= OK then
						p, e = EvalInteger(p)
					end
					if e ~= OK then return nil, e end

					local lst = {tostring(p)}
					local e, ch = ExecuteOneTime(c, lst)
					if e ~= OK then return nil, e end

					s = s .. ch
					
					waitsym = true
				end				
			elseif t[i].typ == "whitespace" then
				-- ne rien faire
			else
				return nil, ERR_TYPE_MISMATCH
			end
		elseif asym == ";" and t[i].typ == "plus"  then
			return nil, ERR_SYNTAX_ERROR
		elseif asym == "+" and t[i].typ == "semicolon" then
			return nil, ERR_SYNTAX_ERROR
		elseif asym == ";" and t[i].typ == "semicolon"  then
			waitsym = false
		elseif asym == "+" and t[i].typ == "plus" then
			waitsym = false
		elseif asym == "" then
			if t[i].typ == "semicolon" then
				asym = ";"
			elseif t[i].typ == "plus" then
				asym = "+"
			end
			
			waitsym = false
		end
		
		i = i + 1
	end

	-- si il y a un plus de trop en fin de ligne alors erreur
	if t[#t].typ == "plus" then
		return nil, ERR_SYNTAX_ERROR
	end
	
	return s, OK
end

-- vérifier si le label est fonctionnel
function EvalLabel(s)
	if s == nil or s == "" then return nil, ERR_SYNTAX_ERROR end

	return s, OK
end

-- évaluer une condition TODO!
function EvalCondition(s)
	if s == nil or s == "" then return nil, ERR_SYNTAX_ERROR end

	return true, OK
end

-- récupérer une commande-fonction et ses paramètres
function GetFunction(t, i)
	-- si les parenthèses ou la 1ère parenthèse sont manquantes
	if i == #t or i + 1 == #t then return nil, nil, nil, ERR_SYNTAX_ERROR end

	local c = t[i].sym
	local p = ""

	if t[i + 1].typ ~= "openbracket" then return nil, nil, nil, ERR_SYNTAX_ERROR end
	
	local flag = false
	local ob = 0 -- nombre de parenthèses ouvertes
	local cb = 0 -- nombre de parenthèses fermées

	-- chercher l'indice des paramètres et les paramètres en question
	for j = i + 2, #t do
		if t[j].typ == "closebracket" and ob == cb then
			flag = true
			i = j - 1
			break
		elseif t[j].typ == "closebracket" then
			cb = cb + 1
			p = p .. t[j].sym
		elseif t[j].typ == "openbracket" then
			ob = ob + 1
			p = p .. t[j].sym
		else
			p = p .. t[j].sym
		end
	end
	
	-- trouver les erreurs
	if ob ~= cb then return nil, nil, nil, ERR_SYNTAX_ERROR end
	if not flag then return nil, nil, nil, ERR_SYNTAX_ERROR end

	return c, p, i, OK
end

-- récupère le type d'une variable
function GetVarType(var)
	for j = 1, #vram do
		if vram[j][1] == string.upper(var) then
			return vram[j][3]
		end
	end
	
	return 0
end

-- récupère la valeur d'une variable
function GetVarValue(var, vType)
	for j = 1, #vram do
		if vram[j][1] == string.upper(var) and vram[j][3] == vType then
			return vram[j][2], OK
		end
	end
	
	return nil, ERR_TYPE_MISMATCH
end

-- faire toutes les opérations comportant l'opération 'op' dans la chaîne 's'
function Calc(s, op)
	local e = OK
	
	local p1 = 1
	local p2 = #s

	-- trouver le 1er opérateur dans la chaîne 's'
	local pos = string.find(s, op)
	
	-- si l'opérateur existe et est bien positionné
	while pos ~= nil and pos > 1 do
		p1 = pos - 1
		p2 = pos + 1
		
		local isVar1 = nil
		local isVar2 = nil
				
		while p1 >= 1 do
			local c = string.upper(string.sub(s, p1, p1))
			
			-- scanner à gauche pour trouver un nombre constante ou une variable
			if (c >= "0" and c <= "9") then
				p1 = p1 - 1
			elseif c == "." and (isVar1 == nil or not isVar1)  then
				p1 = p1 - 1

				isVar1 = false
			elseif (c >= "A" and c <= "Z") and (isVar1 == nil or isVar1)  then
				p1 = p1 - 1

				isVar1 = true
			elseif (c == "_" or c == "!" or c == "%") and (isVar1 == nil or isVar1)  then
				p1 = p1 - 1

				isVar1 = true
			else
				p1 = p1 + 1
				break
			end			
		end
		
		if p1 < 1 then p1 = 1 end
		
		while p2 <= #s do
			local c = string.upper(string.sub(s, p2, p2))
			
			-- scanner à droite pour trouver un nombre constante ou une variable
			if (c >= "0" and c <= "9") then
				p2 = p2 + 1
			elseif c == "." and (isVar2 == nil or not isVar2)  then
				p2 = p2 + 1

				isVar2 = false
			elseif (c >= "A" and c <= "Z") and (isVar2 == nil or isVar2)  then
				p2 = p2 + 1

				isVar2 = true
			elseif (c == "_" or c == "!" or c == "%") and (isVar2 == nil or isVar2)  then
				p2 = p2 + 1

				isVar2 = true
			else
				p2 = p2 - 1
				break
			end
		end
		
		if p2 > #s then p2 = #s end

		-- remplacer l'opération par son résultat
		local s1 = string.sub(s, p1, pos - 1)
		local s2 = string.sub(s, pos + 1, p2)
		
		local v1 = 0
		local v2 = 0
		
		-- une variable est potentiellement trouvée
		if isVar1 then
			-- gestion des erreurs
			if s1 == "!" or s1 == "%" then return nil, ERR_SYNTAX_ERROR end
			
			for i = 1, #s1 - 1 do
				if string.sub(s1, i, i) == "!" or string.sub(s1, i, i) == "%" then
					return nil, ERR_SYNTAX_ERROR
				end
			end
			
			if string.sub(s1, 1, 1) >= "0" and string.sub(s1, 1, 1) <= "9" then
				return nil, ERR_SYNTAX_ERROR
			end
			
			-- trouver la variable si elle existe
			for i = 1, #vram do
				if vram[i][1] == string.upper(s1) then
					v1 = vram[i][2]
					break
				elseif i == #vram then
					if #vram < MAX_RAM then
						vType = VAR_INTEGER
						if string.sub(s1, -1) == "%" then
							vType = VAR_FLOAT
						end
						table.insert(vram, {string.upper(s1), 0, vType})
						break
					else
						return nil, ERR_MEMORY_FULL
					end
				end
			end
		else
			v1 = Val(s1)
		end

		-- une variable est potentiellement trouvée
		if isVar2 then
			-- gestion des erreurs
			if s2 == "!" or s2 == "%" then return nil, ERR_SYNTAX_ERROR end
			
			for i = 1, #s2 - 1 do
				if string.sub(s2, i, i) == "!" or string.sub(s2, i, i) == "%" then
					return nil, ERR_SYNTAX_ERROR
				end
			end
			
			if string.sub(s2, 1, 1) >= "0" and string.sub(s2, 1, 1) <= "9" then
				return nil, ERR_SYNTAX_ERROR
			end
			
			-- trouver la variable si elle existe
			for i = 1, #vram do
				if vram[i][1] == string.upper(s2) then
					v2 = vram[i][2]
					break
				elseif i == #vram then
					if #vram < MAX_RAM then
						vType = VAR_INTEGER
						if string.sub(s2, -1) == "%" then
							vType = VAR_FLOAT
						end
						table.insert(vram, {string.upper(s2), 0, vType})
						break
					else
						return nil, ERR_MEMORY_FULL
					end
				end
			end
		else
			v2 = Val(s2)
		end

		-- faire les opérations
		if op == "+" then
			s = string.sub(s, 1, p1 - 1) .. tostring(v1 + v2) .. string.sub(s, p2 + 1)
		elseif op == "-" then
			s = string.sub(s, 1, p1 - 1) .. tostring(v1 - v2) .. string.sub(s, p2 + 1)
		elseif op == "*" then
			s = string.sub(s, 1, p1 - 1) .. tostring(v1 * v2) .. string.sub(s, p2 + 1)
		elseif op == "/" then
			if v2 == 0 then
				return nil, ERR_DIVISION_BY_ZERO
			else
				s = string.sub(s, 1, p1 - 1) .. tostring(v1 / v2) .. string.sub(s, p2 + 1)
			end
		elseif op == "A" then
			s = string.sub(s, 1, p1 - 1) .. tostring(bit.band(v1, v2)) .. string.sub(s, p2 + 1)
		elseif op == "M" then
			s = string.sub(s, 1, p1 - 1) .. tostring(v1 % v2) .. string.sub(s, p2 + 1)
		elseif op == "NOT" then
			s = string.sub(s, 1, p1 - 1) .. tostring(bit.bnot(v1, v2)) .. string.sub(s, p2 + 1)
		elseif op == "OR" then
			s = string.sub(s, 1, p1 - 1) .. tostring(bit.bor(v1, v2)) .. string.sub(s, p2 + 1)
		elseif op == "XOR" then
			s = string.sub(s, 1, p1 - 1) .. tostring(bit.bxor(v1, v2)) .. string.sub(s, p2 + 1)
		end

		pos = string.find(s, op)
	end
	
	return s, e
end

-- stopper le programme correctement
function StopProgram()
	local e = OK
	
	-- erreurs de fin de programme
	if currentLoopCommandID > 0 then
		if currentLoopCommand == "WHILE" then
			e = ERR_WEND_MISSING
		elseif currentLoopCommand == "FOR" then
			e = ERR_NEXT_MISSING
		end
	end
	
	if e ~= OK then errcode = GetError(e, ProgramCounter) end
	
	-- terminer le programme avec erreur ou non
	if errcode == nil or errcode == "" then
		errcode = nil
		
		msg = "Ready"
		appState = READY_MODE
	else
		EndProgram()
	end
end

-- revenir correctement vers l'éditeur
function EndProgram()
	appState = EDIT_MODE
	
	-- rétablir le mode graphique par défaut
	SetMode(DEFAULT_MODE)
	
	-- effacer le message éventuel
	msg = nil
	
	-- effacer le message d'erreur si c'est 'ready'
	if errcode == "Ready" then errcode = nil end
	
	ResetEditor()
	RedrawEditor()
	
	cursor[1] = safeCursor[1]
	cursor[2] = safeCursor[2]
	
	cmd["STOPMUSIC"].fn("")
	
	ShowCursor(true)
end

-- quitter le programme
function QuitProgram()
	love.event.quit()
end

-- afficher une liste à l'écran
function PrintList(lst)
	if lst == nil then return end
	
	local m = 1
	local mlong = #lst
	local ln = ""
	local p = 6

	while m <= mlong do
		while #ln <= 40 do
			if #ln + #lst[m] > 40 then
				break
			else
				ln = ln .. lst[m] .. " "
				m = m + 1
				if m > mlong then break end
			end
		end
	
		if ln ~= "" then
			c = cursor[2]
			
			pen = p
			if p == 6 then p = 5 else p = 6 end
			
			PrintString(ln)
			
			ln = ""
			
			if c ~= cursor[2] then
				cursor[1] = 1
			else
				LineFeed()
			end
		end
	end
	
	LineFeed()
end

-- passer à la ligne de texte suivante
function LineFeed()
	cursor[1] = 1
	cursor[2] = cursor[2] + 1
end

-- redessiner le sprite édité
function RedrawEditedSprite()
	-- dessiner la zone du sprite
	SetGraphicPenColor(0)
	DrawRectangle(128, 0, SPRITE_WIDTH * 8, SPRITE_HEIGHT * 8, 1)
	SetGraphicPenColor(6)
	DrawRectangle(127, 0, 1, SPRITE_HEIGHT * 8, 1)
	DrawRectangle(127, SPRITE_HEIGHT * 8, (SPRITE_WIDTH * 8) + 2, 1, 1)
	DrawRectangle(120 + (SPRITE_WIDTH + 1) * 8, 0, 1, SPRITE_HEIGHT * 8, 1)

	-- dessiner le sprite
	for y = 0, SPRITE_HEIGHT - 1 do
		for x = 0, SPRITE_WIDTH - 1 do
			SetGraphicPenColor(spram[(sprImgNumber * MAX_SPRITE_SIZE) + x + (y * SPRITE_WIDTH)])
			DrawRectangle(128 + (x * 8), y * 8, 8, 8, 1)
		end
	end
end

-- dessiner deux lignes d'images de sprites
function RedrawSpritesLine()
	SetCanvas(true)

	for y = 0, SPRITE_LINE_HEIGHT - 1 do
		for x = 0, SPRITE_LINE_WIDTH - 1 do
			local j = (sprImgPage * (SPRITE_LINE_WIDTH * SPRITE_LINE_HEIGHT)) + x + (y * SPRITE_LINE_WIDTH)
			
			if j < MAX_SPRITES_IMAGES then
				for ys = 0, SPRITE_HEIGHT - 1 do
					for xs = 0, SPRITE_WIDTH - 1 do
						local xp = (x * SPRITE_WIDTH) + xs
						local yp = (y * SPRITE_HEIGHT) + ys + (200 - (SPRITE_HEIGHT * SPRITE_LINE_HEIGHT))
						
						col = spram[(j * MAX_SPRITE_SIZE) + xs + (ys * SPRITE_WIDTH)]
						
						love.graphics.setColor(scnPal[col][0], scnPal[col][1], scnPal[col][2], scnPalNoAlpha)
						love.graphics.points(xp + 0.5, yp + 0.5)
					end
				end
			end
		end
	end

	SetCanvas(false)
end

-- dessiner deux lignes d'images de sprites
function RedrawCurrentSprite()
	SetCanvas(true)
	
	SetGraphicPenColor(1)

	local i = sprImgNumber - (sprImgPage * (SPRITE_LINE_WIDTH * SPRITE_LINE_HEIGHT))
	local x = i % SPRITE_LINE_WIDTH
	local y = (i - x) / SPRITE_HEIGHT

	for ys = 0, SPRITE_HEIGHT - 1 do
		for xs = 0, SPRITE_WIDTH - 1 do
			local xp = (x * SPRITE_WIDTH) + xs
			local yp = (y * SPRITE_HEIGHT) + ys + (200 - (SPRITE_HEIGHT * SPRITE_LINE_HEIGHT))
				
			local col = spram[(sprImgNumber * MAX_SPRITE_SIZE) + xs + (ys * SPRITE_WIDTH)]
				
			love.graphics.setColor(scnPal[col][0], scnPal[col][1], scnPal[col][2], scnPalNoAlpha)
			love.graphics.points(xp + 0.5, yp + 0.5)
		end
	end
				
	-- encadrer le sprite sélectionné
	local xp = (x * SPRITE_WIDTH)
	local yp = (y * SPRITE_HEIGHT) + (200 - (SPRITE_HEIGHT * 2))
					
	DrawRectangle(xp, yp, SPRITE_WIDTH - 1, SPRITE_HEIGHT - 1, 0)

	SetCanvas(false)
end

-- sauvegarder le programme en cours d'édition
function SaveProgram()
	if SaveProject("main.bas", ram) then
		msg = "Program saved !"
	end
end

-- importer une banque de sprites
function ImportSprites()
	if currentDrive == nil then msg = "No USB drive found !"; return end

	-- importer la banque de sprites
	local w = nil
	local h = nil
	local i = nil
	
	-- effacer la SPRAM
	for i = 0, MAX_SPRAM - 1 do
		spram[i] = 0
	end

	sprImgNumber = 0

	-- ouvrir le fichier
	local data = {}
	local filename = "sprites.spr"
	local line = {}
	
	for line in io.lines(currentDrive .. "Sprites/" .. filename) do
		table.insert(data, line)
	end

	i = 1
	for j = 0, MAX_SPRITES_IMAGES - 1 do
		w = tonumber(data[i])
		h = tonumber(data[i + 1])

		i = i + 2
		
		for y = 0, h - 1 do
			for x = 0, w - 1 do
				spram[(j * MAX_SPRITE_SIZE) + x + (y * w)] = tonumber(data[i])
				i = i + 1
			end
		end

		sprImgNumber = sprImgNumber + 1
	end
	
	-- créer un sprite vide
	sprImgNumber = 0	
		
	return
end

-- exporter une banque de sprites
function ExportSprites()
	if currentDrive == nil then msg = "No USB drive found !"; return end

	-- export sprite bank
	local filename = "sprites.spr"
	
	local file = io.open(currentDrive .. "Sprites/" .. filename, "w")
	
	if file == nil then return false end
	
	local s = ""
	
	for i = 0, MAX_SPRITES_IMAGES - 1 do
		local w = SPRITE_WIDTH
		local h = SPRITE_HEIGHT
			

		file:write(tostring(w) .. Chr(LF))
		file:write(tostring(h) .. Chr(LF))
			
		for y = 0, h - 1 do
			for x = 0, w - 1 do
				file:write(tostring(spram[(i * MAX_SPRITE_SIZE) + x + (y * w)]) .. Chr(LF))
			end
		end
	end
	
	io.close(file)
	
	return
end

-- déplacer le curseur clavier vers le haut
function MoveCursorUp()
	ShowCursor(false)

	-- si la première ligne n'est pas vide, on monte
	if ramLine > 1 then
		-- passer à la ligne du dessus
		cursor[2] = cursor[2] - 1
		-- prendre la ligne de code précédente
		ramLine = ramLine - 1
		-- placer le curseur en fin de ligne
		cursor[1] = #ram[ramLine] + 1
		-- gérer le scrolling horizontal
		SetHScroll()
		-- si le curseur doit faire scroller l'écran
		if cursor[2] < 1 then
			-- on scrolle l'écran
			ScrollScreenDown()
			-- on le prend en compte dans l'éditeur
			if editorOffsetY > 0 then
				editorOffsetY = editorOffsetY - 1
			end
			-- on repositionne le curseur virtuellement en début de ligne
			cursor[1] = 1
			cursor[2] = cursor[2] + 1
			-- s'il y a du texte à afficher en haut, alors...
			if ram[ramLine] ~= nil then
				for i = 1, #ram[ramLine] do
					PrintChar(Asc(string.sub(ram[ramLine], i, i)), PRINT_NOT_CLIPPED)
				end
				cursor[1] = #ram[ramLine] + 1
				-- gérer le scrolling horizontal
				SetHScroll()
			end
		end		
	else
		Beep()
	end
	
	ShowCursor(true)
end

-- déplacer le curseur clavier vers le bas
function MoveCursorDown()
	ShowCursor(false)

	-- si la prochaine ligne existe, on descend
	if ramLine < MAX_RAM - 1 then
		-- passer à la ligne du dessous, si possible
		cursor[2] = cursor[2] + 1
		-- prendre la ligne de code suivante
		ramLine = ramLine + 1
		-- si cette ligne de code existe, on descend
		if ramLine < MAX_RAM - 1 then
			-- placer le curseur en fin de ligne
			cursor[1] = #ram[ramLine] + 1
			-- gérer le scrolling horizontal
			SetHScroll()
			-- si le curseur doit faire scroller l'écran
			if cursor[2] > 25 then
				-- on scrolle l'écran
				ScrollScreenUp()
				-- on le prend en compte dans l'éditeur
				editorOffsetY = editorOffsetY + 1
				-- on repositionne le curseur virtuellement en début de ligne
				cursor[1] = 1
				cursor[2] = cursor[2] - 1
				-- s'il y a du texte à afficher en bas, alors...
				for i = 1, #ram[ramLine] do
					PrintChar(Asc(string.sub(ram[ramLine], i, i)), PRINT_NOT_CLIPPED)
				end
				if ram[ramLine] == Chr(LF) then
					cursor[1] = 1
				else
					cursor[1] = #ram[ramLine] + 1
				end
				-- gérer le scrolling horizontal
				SetHScroll()
			end
		else
			cursor[1] = 1
			-- si le curseur doit faire scroller l'écran
			if cursor[2] > 25 then
				-- on scrolle l'écran
				ScrollScreenUp()
				-- on le prend en compte dans l'éditeur
				editorOffsetY = editorOffsetY + 1
				-- on repositionne le curseur virtuellement en début de ligne
				cursor[2] = cursor[2] - 1
			end
		end
	else
		Beep()
	end

	ShowCursor(true)
end

-- activer le dessin sur le canvas
function SetCanvas(f)
	if f then
		love.graphics.push()
		
		-- dessiner dans le buffer caché
		love.graphics.setCanvas(renderer[currentRenderer])
	else
		-- rétablir le canvas par défaut
		love.graphics.setCanvas()

		love.graphics.pop()	
	end
end

-- afficher l'aide
function UI_Help()
	-- remise à zéro d'un éventuel message texte
	msg = nil

	SaveProgram()
	safeCursor[1] = cursor[1]
	safeCursor[2] = cursor[2]
	appState = HELP_MODE
	HelpManager()

	return
end

-- exécuter le programme
function UI_Run()
	-- remise à zéro d'un éventuel message texte
	msg = nil
	
	safeCursor[1] = cursor[1]
	safeCursor[2] = cursor[2]

	stepsMode = false
	SaveProgram()
	
	errcode = GetError(ScanLabels())
	
	if errcode == "Ok" then
		errcode = nil

		paper = DEFAULT_PAPER
		pen = DEFAULT_PEN
		
		hightlightedRamLine = nil
		ClearScreen()
				
		Locate(1, 1)
		
		kb_buffer = ""
		
		for i = 0, MAX_HARD_SPRITES - 1 do
			hardspr[i].x = 0.0
			hardspr[i].y = 0.0
			hardspr[i].img = 0
			hardspr[i].hotspot = 0
			hardspr[i].scale = 0
		end

		execStep = true
		appState = RUN_MODE -- exécuter le code source basic
	end
	
	return
end

-- déboguer le programme
function UI_Debug()
	-- remise à zéro d'un éventuel message texte
	msg = nil

	safeCursor[1] = cursor[1]
	safeCursor[2] = cursor[2]

	stepsMode = true
	
	SaveProgram()
	errcode = GetError(ScanLabels())
	
	if errcode == "Ok" then
		errcode = nil
		
		paper = DEFAULT_PAPER
		pen = DEFAULT_PEN
		
		hightlightedRamLine = nil
		
		ClearScreen()

		Locate(1, 1)
		kb_buffer = ""

		for i = 0, MAX_HARD_SPRITES - 1 do
			hardspr[i].x = 0.0
			hardspr[i].y = 0.0
			hardspr[i].img = 0
			hardspr[i].hotspot = 0
			hardspr[i].scale = 0
		end

		execStep = true
		appState = RUN_MODE -- exécuter le code source basic en mode 'debug'
	end

	return
end

-- sauvegarder le programme
function UI_Save()
	-- remise à zéro d'un éventuel message texte
	msg = nil

	SaveProgram()

	return
end

-- charger le programme
function UI_Load()
	-- remise à zéro d'un éventuel message texte
	msg = nil

	ShowCursor(false)
	ClearScreen()
	LoadDisc(currentRelativeFolder)

	return
end

-- exporter le programme
function UI_Export()
	if currentDrive == nil then msg = "No USB drive found !"; return end

	-- remise à zéro d'un éventuel message texte
	local lnk = love.filesystem.getSaveDirectory()
	
	msg = DriveValid(currentDrive)
	
	if msg ~= nil then return end
	
	CopyFile(lnk .. "/main.bas", currentDrive .. "main.bas")
	
	-- exporter les sprites dans leur dossier d'origine
	if not GetExtFolderExists(currentDrive .. "Sprites") then
		CreateFolder(currentDrive, "Sprites")
	end

	if GetExtFolderExists(currentDrive .. "Sprites") then
		ExportSprites()
	end
	
	msg = "Program exported"
	
	return
end

-- importer le programme
function UI_Import()
	if currentDrive == nil then msg = "No USB drive found !"; return end

	-- remise à zéro d'un éventuel message texte
	local lnk = love.filesystem.getSaveDirectory()
	
	msg = DriveValid(currentDrive)

	if msg ~= nil then return end
	
	if GetExtFileExists(currentDrive .. "main.bas") then
		CopyFile(currentDrive .. "main.bas", lnk .. "/main.bas")
	
		UI_Load()
		
		-- importer les sprites
		if GetExtFolderExists(currentDrive .. "Sprites") then
			ImportSprites()
		end

		msg = "Program imported"
	else
		msg = "BASIC file main.bas not found"
	end
	
	return
end

-- supprimer le programme
function KillProgram()
	-- remise à zéro d'un éventuel message texte
	msg = nil

	Messagebox("Question", "Delete your program ?", {"Yes", "No", "Cancel"}, {"Reset", "Nothing", "Nothing"})

	return
end

-- quitter le programme
function CloseProgram()
	SaveProgram()
	QuitProgram()

	return
end

-- ne rien faire
function Nothing()
end

-- stocker une itération
function PushIterator(cs, l, c, id)
	if #stack == MAX_STACK then return ERR_STACK_FULL end
	
	table.insert(stack, {cs, l, c, id})

	return OK
end

-- dépiler une itération
function PopIterator(cs, l, c, id)
end

-- relire une itération
function WatchIterator(i)
	if i < 1 or i > #stack then return "", 0, 0, 0 end
	
	local cs = stack[i][1]
	local l = stack[i][2]
	local c = stack[i][3]
	local id = stack[i][4]
	
	return cs, l, c, id
end

-- exécuter un saut d'une partie d'une boucle à une autre
function JumpToIterator(cs, l, c, id)
	for i = #stack, 1, -1 do
		local cs2, l2, c2, id2 = WatchIterator(i)

		if id == id2 and c == c2 then
			ProgramCounter = l - 1
			gotoCommand = id

			break
		end
	end
end

-- fonction de split
function Split(s, delimiter)
	if delimiter == nil then delimiter = "%s+" end

    result = {}	
	
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
	
    return result
end
