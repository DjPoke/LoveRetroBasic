-- montrer (ou cacher le curseur texte)
function ShowCursor(s)
	if s == true then
		if not cursorVisible then
			PrintChar(95, PRINT_NO_FLAGS)
			cursorVisible = true
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
		print(v)
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
function ExecOne(cs, lst, comma)
	-- erreurs sur le nombre de paramètres ?
	if cmd[cs].pmin == 0 and cmd[cs].pmax == 0 and #lst > 0 then
		return ERR_SYNTAX_ERROR, nil
	elseif cmd[cs].pmin >= 0 and #lst < cmd[cs].pmin then
		return ERR_OPERAND_MISSING, nil
	elseif cmd[cs].pmax >= 0 and #lst > cmd[cs].pmax then
		return ERR_TOO_MANY_OPERANDS, nil
	elseif cmd[cs].pmax >= 0 and #lst == cmd[cs].pmax and comma then
		return ERR_SYNTAX_ERROR, nil
	end
			
	return cmd[cs].fn(lst)
end

-- assigne une valeur à une variable
function AssignToVar(var, vType, s)
	for i = 1, #vram do
		if vram[i][1] == string.upper(var) then
			if vType == VAR_INTEGER then
				vram[i][2], e = EvalInteger(s)
			elseif vType == VAR_FLOAT then
				vram[i][2], e = EvalFloat(s)
			else
				vram[i][2], e = EvalString(s, true)
			end
			
			return e
		end
	end
	
	return ERR_TYPE_MISMATCH
end


-- exécuter les instructions basic présentes sur une ligne
function Exec(t, l)
	-- retourner si la table est vide
	if t == nil or #t == 0 then return OK end
		
	-- retourner si le nombre de parenthèses est impair
	local b, ob, cb = 0, 0, 0
	for i = 1, #t do
		if t[i].typ == "openbracket" then
			b = b + 1
			ob = ob + 1
		elseif t[i].typ == "closebracket" then
			cb = cb + 1
			b = b - 1
		end
		
		if b < 0 then return ERR_SYNTAX_ERROR end
	end
	if ob ~= cb then return ERR_SYNTAX_ERROR end

	-- interpréter les morceaux de ligne
	local i = 1
	local c = 0
	local startAction = ""
	local action = ""
	local comma = false
	local cs = ""
	local param = ""
	local lst = {}
	local var = ""
	local varVal = nil
	local varType = nil
	
	while i <= #t do
		-- détecter les erreurs
		if t[i].typ == "err" then
			return ERR_SYNTAX_ERROR
		end
		
		if action == "" then
			if t[i].typ == "command" then
				-- une commande a été trouvée
				startAction = "command"
				action = "find_whitespace" -- on recherche ensuite un symbole 'espace'
				cs = t[i].sym
				-- erreur si une fonction est trouvée en tant que commande, sans assignation à une variable
				if cmd[cs].ret > 0 then
					return ERR_SYNTAX_ERROR
				end
			elseif t[i].typ == "integer" or t[i].typ == "word"  then
				-- une variable integer a peut-être été trouvée,
				-- il faut voir si elle existe en vram ou la créer sinon
				for j = 1, #vram do
					if vram[j][1] == string.upper(t[i].sym) then
						var = t[j].sym
						varVal = vram[j][2]
						varType = VAR_INTEGER
						break
					elseif j == #vram then
						if #vram < MAX_RAM then
							var = t[j].sym
							varVal = 0
							varType = VAR_INTEGER
							table.insert(vram, {string.upper(var), varVal, varType})
							break
						else
							return nil, ERR_MEMORY_FULL
						end
					end
				end
				
				-- si la mémoire de stockage des variables est vide, enregistrer directement
				if #vram == 0 then
					var = t[i].sym
					varVal = 0
					varType = VAR_INTEGER
					table.insert(vram, {string.upper(var), varVal, varType})
				end

				-- chercher ensuite le signe égal pour une assignation
				startAction = "assign"
				action = "find_equal"
				param = ""
			elseif t[i].typ == "float"  then
				-- une variable float a peut-être été trouvée,
				-- il faut voir si elle existe en vram ou la créer sinon
				for j = 1, #vram do
					if vram[j][1] == string.upper(t[i].sym) then
						var = t[j].sym
						varVal = vram[j][2]
						varType = VAR_FLOAT
						break
					elseif j == #vram then
						if #vram < MAX_RAM then
							var = t[j].sym
							varVal = 0.0
							varType = VAR_FLOAT
							table.insert(vram, {string.upper(var), varVal, varType})
							break
						else
							return nil, ERR_MEMORY_FULL
						end
					end
				end
				
				-- si la mémoire de stockage des variables est vide, enregistrer directement
				if #vram == 0 then
					var = t[i].sym
					varVal = 0.0
					varType = VAR_FLOAT
					table.insert(vram, {string.upper(var), varVal, varType})
				end

				-- chercher ensuite le signe égal pour une assignation
				startAction = "assign"
				action = "find_equal"
				param = ""
			elseif t[i].typ == "string" then
				-- une variable string a peut-être été trouvée,
				-- il faut voir si elle existe en vram ou la créer sinon
				for j = 1, #vram do
					if vram[j][1] == string.upper(t[i].sym) then
						var = t[j].sym
						varVal = vram[j][2]
						varType = VAR_STRING
						break
					elseif j == #vram then
						if #vram < MAX_RAM then
							var = t[i].sym
							varVal = ""
							varType = VAR_STRING
							table.insert(vram, {string.upper(var), varVal, varType})
							break
						else
							return nil, ERR_MEMORY_FULL
						end
					end
				end
				
				-- si la mémoire de stockage des variables est vide, enregistrer directement
				if #vram == 0 then
					var = t[i].sym
					varVal = ""
					varType = VAR_STRING
					table.insert(vram, {string.upper(var), varVal, varType})
				end
				
				-- chercher ensuite le signe égal pour une assignation
				startAction = "assign"
				action = "find_equal"
				param = ""
			end
		elseif action == "find_whitespace" then
			if t[i].typ == "whitespace" then
				-- on a trouvé un espace après une commande
				action = "find_first_parameter" -- on cherche maintenant le 1er paramètre éventuel
				param = ""
			elseif t[i].typ == "colon" then
				-- on rencontre deux points après une commande, la commande s'arrête à ce paramètre
				action = ""
				if param ~= nil and param ~= "" then
					local p, e = EvalParam(param, cmd[cs].ptype)
					if e ~= OK then return e end
					table.insert(lst, p)
					param = ""
				end

				e = ExecOne(cs, lst)
				if e ~= OK then return e end
				cs = ""
				lst = {}
			else
				-- on cherche un espace après une commande mais on trouve ni espace ni deux-points
				--
				-- gestion des paramètres 'chaîne de caractère' tout de suite après la commande
				if cmd[cs].ptype == VAR_POLY or cmd[cs].ptype == VAR_STRING then
					if t[i].typ == "poly" then
						action = "find_first_parameter"
						param = t[i].sym
					else
						return ERR_SYNTAX_ERROR
					end
				else
					return ERR_SYNTAX_ERROR
				end
			end
		elseif action == "find_first_parameter" then
			if t[i].typ ~= "comma" and t[i].typ ~= "whitespace" and t[i].typ ~= "colon" then
				-- assemblage du premier paramètre
				param = param .. t[i].sym
			elseif t[i].typ == "comma" then
				-- on rencontre une virgule sans paramètre
				if param == nil or param == "" then
					return ERR_OPERAND_MISSING
				end
				-- on rencontre une virgule, on va chercher le paramètres suivant
				action = "find_next_parameter"
				local p, e = EvalParam(param, cmd[cs].ptype)
				if e ~= OK then return e end
				table.insert(lst, p)
				param = ""
				comma = true
			elseif t[i].typ == "colon" then
				-- on rencontre deux points, la commande s'arrête à ce paramètre
				action = ""
				local p, e = EvalParam(param, cmd[cs].ptype)
				if e ~= OK then return e end
				table.insert(lst, p)
				param = ""

				e = ExecOne(cs, lst)
				if e ~= OK then return e end
				cs = ""
				lst = {}
			else
				-- assemblage du premier paramètre
				param = param .. t[i].sym
			end
		elseif action == "find_next_parameter" then
			if t[i].typ ~= "comma" and t[i].typ ~= "whitespace" and t[i].typ ~= "colon" then
				param = param .. t[i].sym
			elseif t[i].typ == "comma" then
				-- on rencontre une virgule sans paramètre
				if param == nil or param == "" then
					return ERR_OPERAND_MISSING
				end
				-- on rencontre une virgule, on va chercher le paramètres suivant
				local p, e = EvalParam(param, cmd[cs].ptype)
				if e ~= OK then return e end
				table.insert(lst, p)
				param = ""
				comma = true
			else
				action = ""
				local p, e = EvalParam(param, cmd[cs].ptype)
				if e ~= OK then return e end
				table.insert(lst, p)
				param = ""
				
				e = ExecOne(cs, lst)
				if e ~= OK then return e end
				cs = ""
				lst = {}
			end
		elseif action == "find_equal" then
			if t[i].typ ~= "whitespace" and t[i].typ ~= "equal" then
				return ERR_SYNTAX_ERROR
			elseif t[i].typ == "equal" then
				action = "find_expression"
				param = ""
			end
		elseif action == "find_expression" then
			if t[i].typ == "colon" then
				e = AssignToVar(var, varType, param)
				if e ~= OK then return e end
				action = ""
				param = ""
			elseif t[i].typ == "whitespace" then
				-- ne rien faire
			elseif t[i].typ == "plus" then
				param = param .. t[i].sym
			elseif t[i].typ == "integer" or t[i].typ == "word" then
				if varType == VAR_INTEGER or varType == VAR_FLOAT then
					param = param .. t[i].sym
				end
			elseif t[i].typ == "float" then
				if varType == VAR_INTEGER or varType == VAR_FLOAT then
					param = param .. t[i].sym
				end
			elseif t[i].typ == "string" or t[i].typ == "poly" then
				if varType == VAR_STRING then
					param = param .. t[i].sym
				end
			elseif t[i].typ == "minus" or t[i].typ == "mult" or t[i].typ == "div" then
				if varType == VAR_INTEGER or varType == VAR_FLOAT then
					param = param .. t[i].sym
				end
			elseif t[i].typ == "openbracket" or t[i].typ == "closebracket" then
				if varType == VAR_INTEGER or varType == VAR_FLOAT then
					param = param .. t[i].sym
				end
			elseif t[i].typ == "command" then
				-- vérifier que la commande retourne bien le même type que la variable assignée
				if varType == VAR_STRING and cmd[t[i].sym].ret ~= VAR_STRING then return nil, ERR_TYPE_MISMATCH end
				if varType ~= VAR_STRING and cmd[t[i].sym].ret == VAR_STRING then return nil, ERR_TYPE_MISMATCH end

				-- récupérer la commande et ses paramètres
				local c, p, e
				c, p, i, e = GetFunction(t, i)
				if e ~= OK then return nil, e end

				-- quel est le type de paramètres requis par la commande ?
				if cmd[c].ptype == VAR_STRING then
					p, e = EvalString(p)
					if e ~= OK then return nil, e end
					local lst = {Trim(p, "\"")}
					local e, ch = ExecOne(c, lst)
					if e ~= OK then return nil, e end

					param = param .. ch
				elseif cmd[c].ptype == VAR_FLOAT then
					if tostring(Val(p)) ~= p then
						p, e = EvalFloat(p)
						if e ~= OK then return nil, e end
					end
					
					local lst = {tostring(p)}
					local e, ch = ExecOne(c, lst)
					if e ~= OK then return nil, e end
					
					param = param .. ch
				elseif cmd[c].ptype == VAR_INTEGER then
					if tostring(Val(p)) ~= p then
						p, e = EvalInteger(p)
						if e ~= OK then return nil, e end
					end

					local lst = {tostring(p)}
					local e, ch = ExecOne(c, lst)
					if e ~= OK then return nil, e end
					
					param = param .. ch
				elseif cmd[c].ptype == VAR_NUM then
					if tostring(Val(p)) ~= p then
						p, e = EvalFloat(p)
						if e ~= OK then
							p, e = EvalInteger(p)
						end
						if e ~= OK then return nil, e end
					end
					
					local lst = {tostring(p)}
					local e, ch = ExecOne(c, lst)
					if e ~= OK then return nil, e end
					
					param = param .. ch
				end
			elseif t[i].typ == "number" then
				param = param .. t[i].sym
			else
				--TODO return ERR_SYNTAX_ERROR
			end
		end
		
		i = i + 1
		
		-- dernière action à faire sur cette ligne de code
		if i > #t and action ~= "" then
			if startAction == "command" then
				if param ~= "" then
					local p, e = EvalParam(param, cmd[cs].ptype)
					if e ~= OK then return e end
					table.insert(lst, p)
				end
				
				e = ExecOne(cs, lst)
				if e ~= OK then return e end
			elseif startAction == "assign" then
				e = AssignToVar(var, varType, param)
				if e ~= OK then return e end
			end
		end
		
		comma = false
	end

	return OK
end

-- évaluer le paramètres fourni et retourner sa valeur en fonction
function EvalParam(param, typ)
	if typ == VAR_INTEGER then
		l, e = EvalInteger(param)
		return tostring(l), e
	elseif typ == VAR_FLOAT then
		l, e = EvalFloat(param)
		return tostring(l), e
	elseif typ == VAR_NUM then
		-- tous les paramètres numériques sont possibles
		local l, e = EvalFloat(param)
		if e ~= OK then
			l, e = EvalInteger(param)
		end
		return tostring(l), e
	elseif typ == VAR_STRING then
		l, e = EvalString(param)
		return l, e
	elseif typ == VAR_POLY then
		-- tous les paramètres sont possibles
		local l, e = EvalString(param)
		if e ~= OK and e == ERR_TYPE_MISMATCH then
			l, e = EvalFloat(param)
			if e ~= OK then
				l, e = EvalInteger(param)
				-- impossible d'évaluer le paramètre
				if e ~= OK then
					return nil, e
				end
			end
			l = tostring(l)
		elseif e ~= OK then
			return nil, e
		end
		return l, e
	elseif typ == VAR_LABEL then
		l, e = EvalLabel(param)
		return l, e
	-- TODO:
	--elseif typ == VAR_CONDITION then
	--elseif typ == VAR_VAR then
	--elseif typ == VAR_CONSTANT then
	end
	
	return nil, ERR_SYNTAX_ERROR
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

	-- analyser l'expression
	local t = Parser(Lexer(RemoveLabels(s)))
	s = ""
	
	-- vérifier si c'est un simple nombre
	if #t == 1 then
		if t[1].typ == "number" then
			return Val(t[1].sym), OK
		end
	end

	local i = 1
	while i <= #t do
		-- pour chaque commande présente dans l'expression...
		if t[i].typ == "err" then
			-- détecter les erreurs
			return nil, ERR_SYNTAX_ERROR
		elseif t[i].typ == "command" then
			-- vérifier que la commande ne retourne pas une chaîne de caractères
			if cmd[t[i].sym].ret == VAR_STRING then return nil, ERR_TYPE_MISMATCH end

			-- récupérer la commande et ses paramètres
			local c, p, e
			c, p, i, e = GetFunction(t, i)
			if e ~= OK then return nil, e end

			-- quel est le type de paramètres requis par la commande ?
			if cmd[c].ptype == VAR_STRING then
				p, e = EvalString(p)
				if e ~= OK then return nil, e end

				-- remplacer par la valeur
				local lst = {Trim(p, "\"")}
				local e, value = cmd[c].fn(lst)
				if e ~= OK then return nil, e end

				s = s .. tostring(value)
			elseif cmd[c].ptype == VAR_FLOAT then
				if tostring(Val(p)) ~= p then
					p, e = EvalFloat(p)
					if e ~= OK then return nil, e end
				end
				
				-- remplacer par la valeur
				local lst = {tostring(p)}
				local e, value = cmd[c].fn(lst)
				if e ~= OK then return nil, e end
				
				s = s .. tostring(value)
			elseif cmd[c].ptype == VAR_INTEGER then
				if tostring(Val(p)) ~= p then
					p, e = EvalInteger(p)
					if e ~= OK then return nil, e end
				end
				
				-- remplacer par la valeur
				local lst = {tostring(p)}
				local e, value = cmd[c].fn(lst)
				if e ~= OK then return nil, e end
				
				s = s .. tostring(value)
			elseif cmd[c].ptype == VAR_NUM then
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
		elseif t[i].typ == "openbracket" then
			s = s .. t[i].sym
		elseif t[i].typ == "closebracket" then
			s = s .. t[i].sym
		elseif t[i].typ ~= "poly" then
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
	s, e = Calc(s, "*")	
	if e ~= OK then return nil, e end

	s, e = Calc(s, "/")	
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

	-- évaluer la chaîne dans le cadre d'une assignation de valeur à une variable ?
	if assign == nil then assign = false end

	local t = Parser(Lexer(RemoveLabels(s)))
	s = ""
	
	-- ne pas attendre le prochain symbole d'assemblage des chaînes
	local waitsym = false
	
	-- symbole d'assemblage indéfini au départ
	local a = ""
	
	-- ou fixé à '+' si une variable reçoit la chaîne en paramètre
	if assign then a = "+" end
	
	-- assembler les valeurs
	local i = 1
	while i <= #t do
		if t[i].typ == "err" then
			-- détecter les erreurs
			return nil, ERR_SYNTAX_ERROR
		elseif not waitsym then
			if t[i].typ == "poly" then
				s = s .. string.sub(t[i].sym, 2, -2)

				waitsym = true
			elseif t[i].typ == "string" then
				local var = string.upper(t[i].sym)
				local vType = VAR_STRING
				local value, e = GetVarValue(var, vType)

				if e ~= OK then return nil, e end
				
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
				if cmd[c].ptype == VAR_STRING then
					p, e = EvalString(p)
					if e ~= OK then return nil, e end

					local lst = {p}
					local e, ch = ExecOne(c, lst)
					if e ~= OK then return nil, e end
					
					s = s .. ch
					
					waitsym = true
				elseif cmd[c].ptype == VAR_FLOAT then
					p, e = EvalFloat(p)
					if e ~= OK then return nil, e end
					
					local lst = {tostring(p)}
					local e, ch = ExecOne(c, lst)
					if e ~= OK then return nil, e end
					
					s = s .. ch
					
					waitsym = true
				elseif cmd[c].ptype == VAR_INTEGER then
					p, e = EvalInteger(p)
					if e ~= OK then return nil, e end

					local lst = {tostring(p)}
					local e, ch = ExecOne(c, lst)
					if e ~= OK then return nil, e end
					
					s = s .. ch
					
					waitsym = true
				elseif cmd[c].ptype == VAR_NUM then
					p, e = EvalFloat(p)
					if e ~= OK then
						p, e = EvalInteger(p)
					end
					if e ~= OK then return nil, e end

					local lst = {tostring(p)}
					local e, ch = ExecOne(c, lst)
					if e ~= OK then return nil, e end

					s = s .. ch
					
					waitsym = true
				end				
			elseif t[i].typ == "whitespace" then
				-- ne rien faire
			else
				return nil, ERR_TYPE_MISMATCH
			end
		elseif a == ";" and t[i].typ == "plus"  then
			return nil, ERR_SYNTAX_ERROR
		elseif a == "+" and t[i].typ == "semicolon" then
			return nil, ERR_SYNTAX_ERROR
		elseif a == ";" and t[i].typ == "semicolon"  then
			waitsym = false
		elseif a == "+" and t[i].typ == "plus" then
			waitsym = false
		elseif a == "" then
			if t[i].typ == "semicolon" then
				a = ";"
			elseif t[i].typ == "plus" then
				a = "+"
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
		end

		pos = string.find(s, op)
	end
	
	return s, e
end

-- stopper le programme correctement
function StopProgram()
	if err == nil or err == "" then
		err = nil
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
	if err == "Ready" then err = nil end
	
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
	
	m = 1
	mlong = #lst

	ln = ""
	

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
						
						love.graphics.setColor(scnPal[col][0] / 255, scnPal[col][1] / 255, scnPal[col][2] / 255, 1)
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
				
			love.graphics.setColor(scnPal[col][0] / 255, scnPal[col][1] / 255, scnPal[col][2] / 255, 1)
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

-- importer un programme
function ImportProgram()
	local lnk = love.filesystem.getSaveDirectory()

	if love.window.showMessageBox("Info", "Your program can be dropped here:\n" .. lnk .. "\n\nLink copied to clipboard !", "info", true) then
		love.system.setClipboardText(lnk)
	else
		msg = "Runtime error !"
	end
end

-- exporter un programme
function ExportProgram()
	local lnk = love.filesystem.getSaveDirectory()

	if love.window.showMessageBox("Info", "Your program can be taken here:\n" .. lnk .. "\n\nLink copied to clipboard !", "info", true) then
		love.system.setClipboardText(lnk)
	else
		msg = "Runtime error !"
	end
end

-- importer une banque de sprites
function ImportSprites()
	local lnk = love.filesystem.getSaveDirectory() .. spriteFolder .. "/"
	
	if love.window.showMessageBox("Info", "Your sprite bank can be dropped here:\n" .. lnk .. "\n\nLink copied to clipboard !", "info", true) then
		love.system.setClipboardText(lnk)
	else
		msg = "Runtime error !"
	end
end

-- exporter une banque de sprites
function ExportSprites()
	local lnk = love.filesystem.getSaveDirectory() .. spriteFolder .. "/"

	if love.window.showMessageBox("Info", "Your sprite bank be taken here:\n" .. lnk .. "\n\nLink copied to clipboard !", "info", true) then
		love.system.setClipboardText(lnk)
	else
		msg = "Runtime error !"
	end
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
