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

	local s = ""
	
	for i = 1, lim do
		d = data[i]
		
		if d:sub(#d) == "\r" then
			d = d:sub(1, #d - 1)
		end
		
		if d:sub(#d) == "\n" then
			d = d:sub(1, #d - 1)
		end
		
		if lim ~= 1 or d ~= "" then
			s = s .. d .. Chr(LF)
		end
	end

	SaveFileString(s, currentRelativeFolder, filename)
	
	return true
end

-- charger un fichier projet basic depuis le répertoire de disque courant
function LoadProject(filename)
	if filename == nil then return end

	-- vider la mémoire code
	ram = {}
	
	-- charger le code source
	ram = LoadFileTable(ram, currentRelativeFolder, filename)
	
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
		
		SetEditorTextColor(ramLine + i - 1)
	end

	if lim == 25 then
		Locate(#ram[memLim] + 1, 25)
		ramLine = memLim
	else
		Locate(1, lim + 1)
		ramLine = memLim + 1
	end
	
	ShowCursor(true)
end

-- charger le fichier de sprites
function LoadSprites(filename)
	if filename == nil then return end
	
	-- changer le répertoire courant
	love.filesystem.setIdentity(currentRelativeFolder .. spriteFolder .. "/")
	
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
	data = LoadFileTable(data, currentRelativeFolder .. spriteFolder .. "/", filename)

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

	-- changer le répertoire courant
	love.filesystem.setIdentity(currentRelativeFolder)
end

-- sauvegarder le fichier de sprites, si il y en a
function SaveSprites(filename)
	if filename == nil then return end

	-- changer le répertoire courant
	love.filesystem.setIdentity(currentRelativeFolder .. spriteFolder .. "/")
	
	local s = ""
	
	for i = 0, MAX_SPRITES_IMAGES - 1 do
		local w = SPRITE_WIDTH
		local h = SPRITE_HEIGHT
		s = s .. tostring(w) .. Chr(LF)
		s = s .. tostring(h) .. Chr(LF)
		for y = 0, h - 1 do
			for x = 0, w - 1 do
				s = s .. tostring(spram[(i * MAX_SPRITE_SIZE) + x + (y * w)]) .. Chr(LF)
			end
		end
	end
	
	data = love.filesystem.newFileData(s, filename)
	love.filesystem.write(filename, data)

	-- changer le répertoire courant
	love.filesystem.setIdentity(currentRelativeFolder)
end

-- créer un disque virtuel
function CreateDisk(path, folder)
	-- le créer s'il n'existe pas
	if GetFolderExists(path, folder) == nil then
		local id = love.filesystem.getIdentity()
		
		love.filesystem.setIdentity(path .. folder)

		if not love.filesystem.createDirectory(folder) then
			RuntimeError("Can't create the disk folder !")
		end

		love.filesystem.setIdentity(id)
	end
end

-- sélectionner un disque projet et en charger le programme basic
function LoadDisc(filename)
	if filename == nil then return ERR_DISC_MISSING end

	if GetFileExists(love.filesystem.getIdentity(), "main.bas") then
		LoadProject("main.bas")
			
		if GetFolderExists(currentRelativeFolder, spriteFolder) then
			if GetFileExists(currentRelativeFolder .. spriteFolder, "sprites.spr") then
				LoadSprites("sprites.spr")

				msg = "Project Loaded !"
			end
		else
			return ERR_DISC_MISSING
		end
	else
		return ERR_DISC_MISSING
	end

	return OK
end

-- effacer la musique
function ClearMusic()
	for i = 1, 4 do
		for j = 1, notesPerPattern do
			for k = 1, MAX_PATTERNS do
				pattern[i][j][k] = 0
				vol[i][j][k] = DEFAULT_VOLUME
			end
		end
	end
	
	for i = 1, MAX_MUSIC_LENGTH do
		mus[i] = 1
	end

	currentPattern = 1
end

-- chargeur de musique
function LoadMusic(filename)
	if filename == nil then return end

	-- changer le répertoire courant
	love.filesystem.setIdentity(currentRelativeFolder .. musicFolder .. "/")

	if not GetFileExists(currentRelativeFolder .. musicFolder, filename) then
		-- rétablir le répertoire courant
		love.filesystem.setIdentity(currentRelativeFolder)
		
		return
	end

	-- charger la musique
	local m = {}
	m = LoadFileTable(m, currentRelativeFolder .. musicFolder .. "/", filename)

	local cpt = 1
	-- lire les BPM
	BPM = tonumber(m[cpt])
	nextNotes = (60.0 / (4 * BPM))
	countTime = 0
	
	cpt = cpt + 1
	
	-- lire le type et la vitesse d'arpège pour chaque canal
	for i = 1, 4 do
		arpeggioType[i] = tonumber(m[cpt])
		cpt = cpt + 1
		
		arpeggioSpeed[i] = tonumber(m[cpt])
		cpt = cpt + 1
		
		arpeggioCounter[i] = 1
		nextArp[i] = nextNotes / arpeggioSpeed[i]
	end
	
	-- lire les valeurs d'instruments
	for i = 1, 4 do
		currentSoundsType[i] = tonumber(m[cpt])
		cpt = cpt + 1
	end

	-- lire la structure de la musique
	musicLength = tonumber(m[cpt])
	cpt = cpt + 1

	for i = 1, musicLength do
		mus[i] = tonumber(m[cpt])
		cpt = cpt + 1
	end

	-- lire les données des patterns
	for i = 1, 4 do
		for j = 1, notesPerPattern do
			for k = 1, MAX_PATTERNS do
				pattern[i][j][k] = tonumber(m[cpt])
				cpt = cpt + 1
				vol[i][j][k] = tonumber(m[cpt])
				cpt = cpt + 1
			end
		end
	end

	-- créer les instruments
	for ch = 1, 4 do
		CreateSounds(ch, currentSoundsType[ch])
	end

	-- changer le répertoire courant
	love.filesystem.setIdentity(currentRelativeFolder)

	return OK
end

-- sauvegardeur de musique
function SaveMusic(filename)
	if filename == nil then return end

	-- changer le répertoire courant
	love.filesystem.setIdentity(currentRelativeFolder .. musicFolder .. "/")

	-- écrire les BPM
	s = tostring(BPM) .. Chr(LF)
	
	-- écrire le type d'arpège et la vitesse pour chaque canal
	for i = 1, 4 do
		s = s .. tostring(arpeggioType[i]) .. Chr(LF)
		s = s .. tostring(arpeggioSpeed[i]) .. Chr(LF)
	end

	-- écrire les valeurs d'instruments
	for i = 1, 4 do
		s = s .. tostring(currentSoundsType[i]) .. Chr(LF)
	end

	-- écrire la structure musicale
	s = s .. tostring(musicLength) .. Chr(LF)
	
	for i = 1, musicLength do
		s = s .. tostring(mus[i]) .. Chr(LF)
	end
	
	-- écrire les données des patterns
	for i = 1, 4 do
		for j = 1, notesPerPattern do
			for k = 1,MAX_PATTERNS do
				s = s .. tostring(pattern[i][j][k]) .. Chr(LF)
				s = s .. tostring(vol[i][j][k]) .. Chr(LF)
			end
		end
	end

	data = love.filesystem.newFileData(s, filename)
	success, message = love.filesystem.write(filename, data)

	-- erreur
	if not success then
		msg = "Error ! Can't save the music !"
	end

	-- changer le répertoire courant
	love.filesystem.setIdentity(currentRelativeFolder)
end

-- récupérer les chemins vers le disque
function GetCurrentFolder()
	-- créer un chemin direct pour accéder au disque
	currentRelativeFolder = driveFolder .. "/" .. diskFolder .. "/"
end

-- vérifier si un dossier existe
function GetFolderExists(path, folder)
	-- mémoriser le path courant
	memPath = love.filesystem.getIdentity()
	
	-- choisir le path temporaire
	love.filesystem.setIdentity(path)
	
	-- vérifier si le dossier existe
	retValue = love.filesystem.getInfo(folder, "directory")
	
	-- rétablir le path courant
	love.filesystem.setIdentity(memPath)

	return retValue
end

-- vérifier si un fichier existe
function GetFileExists(path, file)
	-- mémoriser le path courant
	memPath = love.filesystem.getIdentity()
	
	-- choisir le path temporaire
	love.filesystem.setIdentity(path)
	
	-- vérifier si le dossier existe
	retValue = love.filesystem.getInfo(file, "file")
	
	-- rétablir le path courant
	love.filesystem.setIdentity(memPath)

	return retValue
end

-- sauvegarder une chaine de caractères dans un fichier
function SaveFileString(s, path, filename)
	local cp = love.filesystem.getIdentity()
	
	-- changer le répertoire courant
	love.filesystem.setIdentity(path)

	local data = love.filesystem.newFileData(s, filename)
	love.filesystem.write(filename, data)

	-- changer le répertoire courant
	love.filesystem.setIdentity(cp)
end

-- charger un fichier dans un tableau et retourner le tableau
function LoadFileTable(t, path, filename)
	local cp = love.filesystem.getIdentity()

	-- changer le répertoire courant
	love.filesystem.setIdentity(path)

	for line in love.filesystem.lines(filename) do
		table.insert(t, line)
	end

	-- changer le répertoire courant
	love.filesystem.setIdentity(cp)
	
	return t
end

-- sBatchFile = .bat for windows, .sh for x
function CallBatch(sBatchFile)
    local b = package.cpath:match("%p[\\|/]?%p(%a+)")
    if b == "dll" then 
        -- windows
        os.execute('start cmd /k call "'..sBatchFile..'"')
    elseif b == "dylib" then
        -- macos
        os.execute('chmod +x "'..sBatchFile..'"')
        os.execute('open -a Terminal.app "'..sBatchFile..'"')
    elseif b == "so" then
        -- Linux
        os.execute('chmod +x "'..sBatchFile..'"')
        os.execute('xterm -hold -e "'..sBatchFile..'" & ')
    end 
end

-- copier un fichier d'un endroit à un autre
function CopyFile(old_path, new_path)
  local old_file = io.open(old_path, "rb")
  local new_file = io.open(new_path, "wb")
  local old_file_sz, new_file_sz = 0, 0
  if not old_file or not new_file then
    return false
  end
  while true do
    local block = old_file:read(2^13)
    if not block then 
      old_file_sz = old_file:seek( "end" )
      break
    end
    new_file:write(block)
  end
  old_file:close()
  new_file_sz = new_file:seek( "end" )
  new_file:close()
  return new_file_sz == old_file_sz
end

-- vérifier la présence d'un fichier hors du bac à sable de love2d
function GetExtFileExists(filename)
	local f = io.open(filename, "r")
	if f ~= nil then io.close(f) return true else return false end
end

-- check if external folder exists
function GetExtFolderExists(filename)
	return os.rename(filename,filename)
end

-- check if drive is valid
function GetDriveValid(drive)
	local f = io.open(drive .. "/LRB.tst", "w")

	if f == nil then return "Disk error !" end
	
	io.close(f)		
	os.remove(drive .. "/LRB.tst")
	
	return nil
end
