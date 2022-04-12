-- sauvegarder une image png
function SaveBOB(filename, path, n)
	if filename == nil or filename == "" then return end
	if path == nil or path == "" then return end
	if n < 0 or n > MAX_BOB then return end
	if bob[n] == nil then return end
	
	-- mémoriser le chemin
	local memPath = love.filesystem.getIdentity()
	
	-- établir le bon chemin
	love.filesystem.setIdentity(path)

	-- créer une image data de la même taille que le BOB
	local data = love.image.newImageData(bob[n][1], bob[n][2])

	-- copier les données
	for y = 0, bob[n][2] - 1 do
		for x = 0, bob[n][1] - 1 do
			local i = x + (y * bob[n][1]) + 3
			local c = bob[n][i]
			local r, g, b = scnPal[c][0] / 255, scnPal[c][1] / 255, scnPal[c][2] / 255
			data:setPixel(x, y, r, g, b, 1.0)
		end
	end
	
	data:encode("png", filename)
	
	-- supprimer l'image data
	data:release()

	-- rétablir le chemin
	love.filesystem.setIdentity(memPath)
end

-- charger une image png (avec la palette courante)
function LoadBOB(filename, path, n)
	if filename == nil or filename == "" then return end
	if path == nil or path == "" then return end
	if n < 0 or n > MAX_BOB then return end

	-- vérifier si le fichier existe
	if not GetFileExists(path, filename) then return end

	-- supprimer l'ancienne image
	bob[n] = {}
	
	-- mémoriser le chemin
	local memPath = love.filesystem.getIdentity()
	
	-- établir le bon chemin
	love.filesystem.setIdentity(path)

	-- créer une image data de la même taille
	local data = love.image.newImageData(filename)
	
	bob[n] = {
		data:getWidth(),
		data:getHeight()
	}
	
	for y = 0, data:getHeight() - 1 do
		for x = 0, data:getWidth() - 1 do
			local r, g, b = data:getPixel(x, y)
			r = math.floor(r * 255)
			g = math.floor(g * 255)
			b = math.floor(b * 255)
			local found = false
			local distr = 255
			local distg = 255
			local distb = 255
			local memdistr = 255
			local memdistg = 255
			local memdistb = 255
			local c = 0

			-- trouver la couleur exacte
			for i = 0, 63 do
				if scnPal[i][0] == r and scnPal[i][1] == g and scnPal[i][2] == b then
					c = i
					found = true
					break
				end
			end
			
			-- trouver une valeur approximative
			if not found then
				for i = 0, 63 do
					distr = math.abs(r - scnPal[i][0])
					distg = math.abs(g - scnPal[i][1])
					distb = math.abs(b - scnPal[i][2])

					if distr <= memdistr and distg <= memdistg and distb <= memdistb then
						memdistr = distr
						memdistg = distg
						memdistb = distb
						c = i
						found = true
					end
				end
			end
			
			-- remplacer la couleur par celle trouvée
			if found then
				table.insert(bob[n], c)
			end
		end
	end
	
	-- supprimer l'image data
	data:release()
	
	-- rétablir le chemin
	love.filesystem.setIdentity(memPath)
end

-- charger une image png et le placer en fond d'écran
function LoadImage(filename, path)
	if filename == nil or filename == "" then return end
	if path == nil or path == "" then return end
	
	-- vérifier si le fichier existe
	if not GetFileExists(path, filename) then return end

	-- mémoriser le chemin
	local memPath = love.filesystem.getIdentity()
	
	-- établir le bon chemin
	love.filesystem.setIdentity(path)

	-- créer une image data de la même taille
	local data = love.image.newImageData(filename)
	
	local mgp = gpen
	
	for y = 0, data:getHeight() - 1 do
		for x = 0, data:getWidth() - 1 do
			local r, g, b = data:getPixel(x, y)
			r = math.floor(r * 255)
			g = math.floor(g * 255)
			b = math.floor(b * 255)
			local found = false
			local distr = 255
			local distg = 255
			local distb = 255
			local memdistr = 255
			local memdistg = 255
			local memdistb = 255
			local c = 0

			-- trouver les couleurs exactes
			for i = 0, 63 do
				if scnPal[i][0] == r and scnPal[i][1] == g and scnPal[i][2] == b then
					c = i
					found = true
					break
				end
			end
			
			-- trouver une valeur approximative
			if not found then
				for i = 0, 63 do
					distr = math.abs(r - scnPal[i][0])
					distg = math.abs(g - scnPal[i][1])
					distb = math.abs(b - scnPal[i][2])

					if distr <= memdistr and distg <= memdistg and distb <= memdistb then
						memdistr = distr
						memdistg = distg
						memdistb = distb
						c = i
						found = true
					end
				end
			end
			
			-- remplacer la couleur par celle trouvée
			if found then
				gpen = c
				PlotPixel(x, y)
			end
		end
	end
	
	gpen = mgp
	
	-- supprimer l'image data
	data:release()
	
	-- rétablir le chemin
	love.filesystem.setIdentity(memPath)
end

-- afficher un BOB à l'écran
function PasteBOB(n, x, y)
	if n < 0 or n > MAX_BOB then return end
	if bob[n] == nil then return end
	
	for yp = 0, bob[n][2] - 1 do
		for xp = 0, bob[n][1] - 1 do
			local i = xp + (yp * bob[n][1]) + 3
			local c = bob[n][i]
			
			-- afficher le pixel en transparence
			if c > 0 then
				local mgp = gpen
				gpen = c
				PlotPixel(x + xp, y + yp)
				gpen = mgp
			end
		end
	end
end

-- supprimer un BOB
function FreeBOB(n)
	if n < 0 or n > MAX_BOB then return end

	-- supprimer l'ancienne image
	if bob[n] ~= nil then
		bob[n] = {}
	end
end
