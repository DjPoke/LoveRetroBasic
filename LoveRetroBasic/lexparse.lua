-- tokenizer simplifié
function Lexer(s)
	-- retourner nil si la chaîne est vide ou une chaîne d'espaces
	if s == nil or Trim(s) == "" then return "" end
	
	-- recherche de symboles par priorité
	local tokens = {
		{sym = "\"", typ = "quote"}, -- constantes chaînes de caractères
		{sym = "'", typ = "rem"}, -- remarques
		{sym = ":", typ = "colon"}, -- séparateur de commandes
		{sym = " ", typ = "whitespace"}, -- espace séparateur
		{sym = "(", typ = "openbracket"}, -- parenthèses de fonctions et/ou mathématiques
		{sym = ")", typ = "closebracket"}, -- parenthèses de fonctions et/ou mathématiques
		{sym = ";", typ = "semicolon"}, -- parenthèses de fonctions et/ou mathématiques
		{sym = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz", typ = "letter"}, -- lettre
		{sym = "0123456789.", typ = "digit"}, -- nombre
		{sym = "=", typ = "equal"}, -- assignation de valeur à une variable
		{sym = "!", typ = "integer"}, -- assignation de type à une variable
		{sym = "%", typ = "float"}, -- assignation de type à une variable
		{sym = "$", typ = "string"}, -- assignation de type à une variable
		{sym = ",", typ = "comma"}, -- séparateur de paramètres
		{sym = "*", typ = "mult"}, -- multiplication
		{sym = "/", typ = "div"}, -- division
		{sym = "+", typ = "plus"}, -- addition
		{sym = "-", typ = "minus"} -- soustraction
	}

	-- retourner la table tokenisée
	local t = {}
	
	for j = 1, #s do
		local c0 = string.sub(s, j, j)
		local found = false
		for i = 1, #tokens do
			local c1 = tokens[i].sym
			
			for k = 1, #c1 do
				if c0 == string.sub(c1, k, k) then
					table.insert(t, {sym = c0, typ = tokens[i].typ})
					found = true
					break
				end
			end
			
			if found then break end
		end
		
		if not found then
			table.insert(t, {sym = c0, typ = "symbol"})
		end
	end
	
	return t
end

-- analyseur syntaxique simplifié
function Parser(t)
	-- trouver et assembler toutes les chaînes de caractères
	t = GetConstantStrings(t)
	
	-- supprimer les remarques
	i = 1
	while i <= #t do
		if t[i].typ == "rem" then
			for j = #t, i, -1 do
				table.remove(t)
			end
			break
		end
		i = i + 1
	end
	
	-- assembler les lettres consécutives
	t = Assemble(t, "letter", "word")

	-- assembler les chiffre consécutifs
	t = Assemble(t, "digit", "number")

	-- trouver des erreurs dans les nombres
	local count = 0
	for i = 1, #t do
		if t[i].typ == "number" then
			count = 0
			for j in string.gfind(t[i].sym, "%.") do
				count = count + 1
			end
			if count > 1 or t[i].sym == "." then
				t[i].typ = "err"
				return t
			end
		end
	end
	
	-- assembler les espaces consécutifs
	t = Assemble(t, "whitespace", "whitespace")
	
	-- assembler le symbole ! avec certains mots consécutifs
	t = Assemble2(t, "word", "integer", "word")

	-- assembler le symbole % avec certains mots consécutifs
	t = Assemble2(t, "word", "float", "word")

	-- assembler le symbole $ avec certains mots consécutifs
	t = Assemble2(t, "word", "string", "word")
	
	-- trouver les erreurs de syntaxe liées aux mots clés mélangés aux symboles !, %, $
	for i = 1, #t do
		if t[i].typ == "word" then
			for j = 1, #t[i].sym do
				if (string.sub(t[i].sym, j, j) == "!" or string.sub(t[i].sym, j, j) == "%"or string.sub(t[i].sym, j, j) == "$") and j < #t[i].sym then
					t[i].typ = "err"
					return t
				end
			end
		end
	end

	-- trouver les mots clés du BASIC
	for i = 1, #t do
		if t[i].typ == "word" then
			local w = string.upper(t[i].sym)
			for j = 1, #commands do
				if w == commands[j] then
					t[i] = {sym = commands[j], typ = "command"}
				end
			end
		end
	end
	
	-- trouver les variables ayant un indicateur informant que ce sont des variables
	for i = 1, #t do
		if t[i].typ == "word" then
			if string.sub(t[i].sym, -1) == "!" then
				t[i].typ = "integer"
			elseif string.sub(t[i].sym, -1) == "%" then
				t[i].typ = "float"
			elseif string.sub(t[i].sym, -1) == "$" then
				t[i].typ = "string"
			end
		end
	end

	return t
end

-- assembler des symboles provenant du lexer
function Assemble(t, typ, newtyp)
	local t2 = {}
	local cs, ce = 0, 0
	local s = ""
	
	for i = 1, #t do
		if t[i].typ ~= typ then
			if cs == 0 then
				table.insert(t2, t[i])
			else
				table.insert(t2, {sym = s, typ = newtyp})
				cs = 0
				ce = 0
				table.insert(t2, t[i])
			end
		elseif cs == 0 then
			cs = i
			ce = i
			s = t[i].sym
		else
			ce = ce + 1
			s = s .. t[i].sym
		end
	end
	
	if cs > 0 then
		table.insert(t2, {sym = s, typ = newtyp})
	end
	
	return t2
end

-- assembler deux symboles différents provenant du lexer
function Assemble2(t, typ1, typ2, newtyp)
	local t2 = {}
	local cs, ce = 0, 0
	local s = ""
	
	for i = 1, #t do
		if t[i].typ ~= typ1 and t[i].typ ~= typ2 then
			if cs == 0 then
				table.insert(t2, t[i])
			else
				table.insert(t2, {sym = s, typ = newtyp})
				cs = 0
				ce = 0
				table.insert(t2, t[i])
			end
		elseif cs == 0 then
			cs = i
			ce = i
			s = t[i].sym
		else
			ce = ce + 1
			s = s .. t[i].sym
		end
	end
	
	if cs > 0 then
		table.insert(t2, {sym = s, typ = newtyp})
	end
	
	return t2
end

-- formater les chaînes de caractères constantes
function GetConstantStrings(t2)
	local t = {}
	
	local assembly = false
	local s = ""
	
	for i = 1, #t2 do
		if t2[i].typ ~= "quote" and not assembly then
			table.insert(t, t2[i])
		elseif t2[i].typ == "quote" then
			if not assembly then
				assembly = true
				s = t2[i].sym
			else
				assembly = false
				s = s .. t2[i].sym
				table.insert(t, {sym = s, typ = "poly"})
				s = ""
			end
		elseif t2[i].typ ~= "quote" then
			s = s .. t2[i].sym
		end
	end
	
	if assembly then
		table.insert(t, cs, {sym = s, typ = "err"})
	end
	
	return t
end
