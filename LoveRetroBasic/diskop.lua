-- sauvegarder un fichier projet basic dans le répertoire de disque courant
function SaveProject(filename, data)
	if filename == nil then return false end
	
	-- rechercher la dernière ligne de code remplie
	local lim = #data
	
	for i = #data, 1, -1 do
		if data[i] ~= "" and data[i] ~= "\r" and data[i] ~= "\n" and data[i] ~= "\r\n" then
			lim = i
			break
		elseif i == 1 then
			lim = 1
			break
		end
	end
	
	local file = io.open(filename, "w")

	for i = 1, lim do
		d = data[i]
		if d:sub(#d) == "\r" then
			d = d:sub(1, #d - 1)
		end
		if d:sub(#d) == "\n" then
			d = d:sub(1, #d - 1)
		end
		if lim ~= 1 or d ~= "" then
			file:write(d .. Chr(LF))
		end
	end
	
	file:close()

	return true
end

-- charger un fichier projet basic depuis le répertoire de disque courant
function LoadProject(filename)
	if filename == nil then return end

	-- vider la mémoire code
	ram = {}

	-- charger le code source
	for line in io.lines(filename) do
		table.insert(ram, line)
	end
	
	-- déterminer le numéro de la dernière ligne
	local lim = #ram
	local memLim = lim

	-- remplir les autres lignes de LineFeeds
	for i = #ram + 1, MAX_RAM - 1 do
		ram[i] = ""
	end

	-- déterminer quelle ligne de code doit être en haut de l'écran
	ramLine = lim - 24
	
	-- ce nombre ne doit pas être inférieur à 1
	if ramLine < 1 then	ramLine = 1 end
	
	-- offset vertical de l'éditeur de texte
	editorOffsetY = 0
	
	-- déterminer le nombre de lignes à afficher
	if lim > 25 then
		editorOffsetY = lim - 25
		lim = 25
	end
	
	-- afficher les lignes de code à l'écran
	for i = 1, lim do
		Locate(1, i)
		for j = 1, #ram[ramLine + i - 1] do
			PrintChar(Asc(string.sub(ram[ramLine + i - 1], j, j)), PRINT_NOT_CLIPPED)
		end
	end

	if lim == 25 then
		Locate(#ram[memLim] + 1, 25)
		ramLine = memLim
	else
		Locate(1, lim + 1)
		ramLine = memLim + 1
	end
end

-- charger le fichier de sprites
function LoadSprites(filename)
	if filename == nil then return end

	--
	local w = nil
	local h = nil
	local i = nil
	
	-- effacer la SPRAM
	for i = 0, MAX_SPRAM - 1 do
		spram[i] = 0
	end

	sprImgSize = {}
	sprImgNumber = 0

	-- ouvrir le fichier
	local data = {}

	for line in io.lines(filename) do
		table.insert(data, line)
	end

	i = 1
	for j = 0, MAX_SPRITES_IMAGES - 1 do
		w = Val(data[i])
		h = Val(data[i + 1])

		sprImgSize[j] = {w = w, h = h}
		
		i = i + 2
		
		for y = 0, h - 1 do
			for x = 0, w - 1 do
				spram[(j * MAX_SPRITE_SIZE) + x + (y * w)] = Val(data[i])
				i = i + 1
			end
		end

		sprImgNumber = sprImgNumber + 1
	end
	
	-- créer un sprite vide
	sprImgNumber = 0	
end

-- sauvegarder le fichier de sprites, si il y en a
function SaveSprites(filename)
	if filename == nil then return end

	if sprImgSize == nil then return end

	local file = io.open(filename, "w")

	for i = 0, MAX_SPRITES_IMAGES - 1 do
		local w = sprImgSize[i].w
		local h = sprImgSize[i].h
		file:write(tostring(w) .. Chr(LF))
		file:write(tostring(h) .. Chr(LF))
		for y = 0, h - 1 do
			for x = 0, w - 1 do
				file:write(tostring(spram[(i * MAX_SPRITE_SIZE) + x + (y * w)]) .. Chr(LF))
			end
		end
	end
	file:close()
end

-- créer un disque virtuel
function CreateDisk(f)
	-- le créer s'il n'existe pas
	if love.filesystem.getInfo(f, 'directory') == nil then
		if love.filesystem.createDirectory(f) then
		end
	end
end

-- sélectionner un disque projet et en charger le programme basic
function SelectDisk(f)
	if f == nil then return ERR_DISC_MISSING end
	
	if os.rename(f .. "main.bas", f .. "main.bas") then
		LoadProject(f .. "main.bas")
			
		if os.rename(f .. "sprites.spr", f .. "sprites.spr")~= nil then
			LoadSprites(f .. "sprites.spr")
		end
		
		msg = "Project Loaded !"
	else
		return ERR_DISC_MISSING
	end

	return OK
end

-- chargeur de musique
function LoadMusic(filename)
	if filename == nil then return end

	local file = io.open(filename, "rb")

	-- lire les BPM
	BPM = Asc(file:read(1))
	nextNotes = (60.0 / (4 * BPM))
	countTime = 0
	
	-- lire le type et la vitesse d'arpège pour chaque canal
	for i = 1, 4 do
		arpeggioType[i] = Asc(file:read(1))
		arpeggioSpeed[i] = Asc(file:read(1))
		arpeggioCounter[i] = 1
		nextArp[i] = nextNotes / arpeggioSpeed[i]
	end
	
	-- lire les valeurs d'instruments
	for i = 1, 4 do
		currentSoundsType[i] = Asc(file:read(1))
	end

	-- lire la structure de la musique
	musicLength = Asc(file:read(1))
	for i = 1, musicLength do
		mus[i] = Asc(file:read(1))
	end

	-- lire les données des patterns
	for i = 1, 4 do
		for j = 1, notesPerPattern do
			for k = 1, MAX_PATTERNS do
				pattern[i][j][k] = Asc(file:read(1))
				vol[i][j][k] = Asc(file:read(1))
			end
		end
	end
	
	file:close()

	-- créer les instruments
	for ch = 1, 4 do
		CreateSounds(ch, currentSoundsType[ch])
	end
	
	return OK
end