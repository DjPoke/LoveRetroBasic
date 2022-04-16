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
	love.filesystem.setIdentity(WPath(PathAsm(currentRelativeFolder, spriteFolder)))
	
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
	data = LoadFileTable(data, WPath(PathAsm(currentRelativeFolder, spriteFolder)), filename)

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
	love.filesystem.setIdentity(PathAsm(currentRelativeFolder, spriteFolder))
	
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
		local p = love.filesystem.getIdentity()
		
		love.filesystem.setIdentity(PathAsm(path, folder))

		if not love.filesystem.createDirectory(folder) then
			RuntimeError("Can't create the disk folder !")
		end

		love.filesystem.setIdentity(p)
	end
end

-- sélectionner un disque projet et en charger le programme basic
function LoadDisc(filename)
	if filename == nil then return ERR_DISC_MISSING end

	if GetFileExists(WPath(love.filesystem.getIdentity()), "main.bas") then
		LoadProject("main.bas")
			
		if GetFolderExists(currentRelativeFolder, spriteFolder) then
			if GetFileExists(WPath(PathAsm(currentRelativeFolder, spriteFolder)), "sprites.spr") then
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

-- chargeur de musique
function LoadMusic(filename)
	if filename == nil then return end

	-- changer le répertoire courant
	love.filesystem.setIdentity(PathAsm(currentRelativeFolder, musicFolder))

	if not GetFileExists(WPath(PathAsm(currentRelativeFolder, musicFolder)), filename) then
		-- rétablir le répertoire courant
		love.filesystem.setIdentity(currentRelativeFolder)
		
		return
	end

	-- charger la musique
	local m = {}
	m = LoadFileTable(m, PathAsm(currentRelativeFolder, musicFolder), filename)

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
	love.filesystem.setIdentity(PathAsm(currentRelativeFolder, musicFolder))

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
	currentRelativeFolder = WPath(PathAsm(driveFolder, diskFolder))
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

-- sauvegarder une chaîne de caractères dans un fichier
function SaveFileString(s, path, filename)
	local memPath = love.filesystem.getIdentity()
	
	-- changer le répertoire courant
	love.filesystem.setIdentity(path)

	local data = love.filesystem.newFileData(s, filename)
	love.filesystem.write(filename, data)

	-- changer le répertoire courant
	love.filesystem.setIdentity(memPath)
end

-- charger un fichier dans un tableau et retourner le tableau
function LoadFileTable(t, path, filename)
	local memPath = love.filesystem.getIdentity()
	
	-- changer le répertoire courant
	love.filesystem.setIdentity(path)

	for line in love.filesystem.lines(filename) do
		table.insert(t, line)
	end

	-- changer le répertoire courant
	love.filesystem.setIdentity(memPath)
	
	return t
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
      old_file_sz = old_file:seek("end")
      break
    end
	
    new_file:write(block)
  end
  
  old_file:close()
  new_file_sz = new_file:seek("end")
  new_file:close()
  
  return new_file_sz == old_file_sz
end

-- vérifier la présence d'un fichier hors du bac à sable de love2d
function GetExtFileExists(filename)
	local f = io.open(filename, "r")
	if f ~= nil then io.close(f) return true else return false end
end

-- vérifier si un dossier externe au bac à sable existe
function GetExtFolderExists(filename)
	return os.rename(filename,filename)
end

-- vérifier si un périphérique de stockage existe
function DriveValid(drive)
	-- écrire un fichier temporaire
	local f = io.open(drive .. "chkdrv.tmp", "w")

	if f == nil then return "Disk error !" end
	
	io.close(f)
	
	-- supprimer le fichier créé
	os.remove(drive .. "chkdrv.tmp")
	
	return nil
end

-- obtenir la liste des périphériques de stockage USB accessibles
function GetUSBDrivesList()
	local driveList = {}
	local currentOS = love.system.getOS()
	
	if currentOS == "Windows" then
		for i = Asc("A"), Asc("Z") do
			local drv = Chr(i) .. ":/"

			if DriveValid(drv) == nil then
				local gds = GetDriveSize(Chr(i))

				if gds > 0 and gds <= MAX_DRIVE_SIZE then
					table.insert(driveList, drv)
				end
			end
		end

		return driveList
	elseif currentOS == "Linux" then
		local sd = love.filesystem.getAppdataDirectory() .. "/love/lnx.tmp"

		-- récupérer la liste des périphériques de Linux dans un fichier temporaire
		local f = io.popen("lsblk >" .. sd, "w")
		f:close()
		
		-- si le fichier existe...
		local text = ""
		
		if GetExtFileExists(sd) then
			-- le lire dans texte
			local file = io.open(sd, "r")
			text = file:read("*a")
			file:close()
			
			-- le supprimer
			os.remove(sd)
		else
			return nil
		end
		
		-- impossible de trouver une clé USB connectée...
		if string.find(text, "media") == nil then return nil end
		
		-- on cherche la première partition
		local i, j = string.find(text, "sda1")
		local t	= {}
		
		text = Trim(string.sub(text, i, #text))

		-- on sépare les lignes
		for line in text:gmatch("([^\n]*)\n?") do
			table.insert(t, line)
		end
		
		-- puis on les cherche toutes
		local d = 1
		local p = 1
		
		for i = 1, #t do
			while p <= 26 do
				-- chercher partion sd'p' numéro 'd'
				local j, k = string.find(t[i], "sd" .. Chr(p + 96) .. Chr(d + 48))
				
				if j ~= nil and k ~= nil then
					local p = string.sub(t[i], j, k)
					
					j2, k2 = string.find(t[i], " part ")
					
					local size = Trim(string.sub(t[i], k + 1, j2 - 1))
					local drv = Trim(string.sub(t[i], k2 + 1, #t[i]))
					
					local t = {}
					
					t = Split(size)
					
					size = t[3]
				
					local w = string.upper(string.sub(size, #size, #size))
					size = string.sub(size, 1, -2)
					size = size:gsub(",", ".")
					local sz = 1
				
					if w == "G" then
						sz = Val(size) * 1024
					elseif w == "M" then
						sz = Val(size)
					end
				
					if DriveValid(drv .. "/") == nil then
						if sz > 0 and sz <= MAX_DRIVE_SIZE then
							table.insert(driveList, drv .. "/")
						end
					end
					
					d = d + 1
					
					if d > 9 then break end
				else
					break
				end
				
				p = p + 1
				d = 1
			end
		end
				
		return driveList
	else	
		msg = "Operating System not handled !"
	end
	
	return nil
end

function ChangeDrive(value)
	-- on recharge l'affichage les disques
	GetUSBDrivesList()
	
	-- si la configuration a changée...
	if #drivesList == 0 then
		msg = "No USB drive found !"
	elseif currentDriveNumber > #drivesList then
		currentDriveNumber = #drivesList
	else
		currentDriveNumber = currentDriveNumber + value

		if currentDriveNumber < 1 then currentDriveNumber = 1 end
		if currentDriveNumber > #drivesList then currentDriveNumber = currentDriveNumber - #drivesList end
		
		currentDrive = drivesList[currentDriveNumber]
		msg = "Current drive: " .. currentDrive
	end
end

-- obtenir la taille des périphériques externes (USB)
function GetDriveSize(driveLetter)
	local text = ""
	local ret = ""
	local script = [[ Get-WmiObject -Class win32_logicaldisk -Filter "DriveType = '2'" | Select-Object -Property DeviceID,Size ]]
		
	local sd = love.filesystem.getAppdataDirectory() .. "/LOVE/LRB.tmp"

	local p = io.popen("powershell -command - >" .. sd, "w")
	p:write(script)
	p:close()
	
	if GetExtFileExists(sd) then
		file = io.open(sd, "rb")
		local text = file:read("*a")
		file:close()

		local l = utf8.len(text)
		
		for i = 1, l do
			local c = string.sub(text, utf8.offset(text, i), utf8.offset(text, i))
			local a = bit.band(c:byte(), 127)

			-- la lettre du drive a été trouvée
			if a == Asc(driveLetter) then
				if i < l then
					c = string.sub(text, utf8.offset(text, i + 1), utf8.offset(text, i + 1))
					a = bit.band(c:byte(), 127)
					
					if Chr(a) == ":" then
						for j = i + 2, l do
							c = string.sub(text, utf8.offset(text, j), utf8.offset(text, j))
							a = bit.band(c:byte(), 127)
							
							if (a >= 48 and a <= 57) then
								ret = ret .. Chr(a)
							elseif a ~= 32 then
								break
							end
						end
					end
					
					if ret ~= "" then break end
				end
			end
		end
		
		os.remove(sd)
	else
		return 0
	end

	return Val(string.sub(ret, 1, -7))
end

-- créer un dossier
function CreateFolder(folder)
	local currentOS = love.system.getOS()
	
	if currentOS == "Windows" then
		local drv = WPath(currentDrive)

		os.execute("mkdir " .. drv .. folder)
	elseif currentOS == "Linux" then
		os.execute("mkdir(" .. WPath(PathAsm(currentDrive, folder)) .. ",0777);")
	end
end

-- fonction qui retourne un chemin compatible windows (si l'o.s est bien windows)
function WPath(p)
	local currentOS = love.system.getOS()
	
	if currentOS == "Windows" then
		p = p:gsub("/", "\\")
	elseif currentOS == "Linux" then
		p = p:gsub("\\", "/")	
	end
	
	return p
end

-- assemble un path
function PathAsm(p1, p2)
	if string.sub(p1, #p1, #p1) ~= "/" and string.sub(p1, #p1, #p1) ~= "\\" then p1 = p1 .. "/" end

	if string.find(p2, ".") == nil then
		if string.sub(p2, #p2, #p2) ~= "/" and string.sub(p2, #p2, #p2) ~= "\\" then p2 = p2 .. "/" end
	end
	
	return p1 .. p2
end