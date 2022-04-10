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
	
	bob[n]:encode("png", filename)

	-- rétablir le chemin
	love.filesystem.setIdentity(memPath)
end

-- charger une image png (avec la palette courante)
function LoadBOB(filename, path, n)
	if filename == nil or filename == "" then return end
	if path == nil or path == "" then return end
	if n < 0 or n > MAX_BOB then return end

	-- supprimer l'ancienne image
	if bob[n] ~= nil then
		bob[n]:release()
	end
	
	-- mémoriser le chemin
	local memPath = love.filesystem.getIdentity()
	
	-- établir le bon chemin
	love.filesystem.setIdentity(path)

	-- charger l'image
	bob[n] = love.graphics.newImageData(filename)
	
	for y = 0, bob[n]:getHeight() - 1 do
		for x = 0, bob[n]:getWidth( ) - 1 do
			local r, g, b, a = bob[n]:getPixel(x, y)
			local found = false
			local c1 = r + g + b
			local c2 = 0
			local dist = 0
			local memDist = 256 * 3

			-- trouver la couleur exacte
			for i = 0, 63 do
				if scnPal[i][0] == r and scnPal[i][1] == g and scnPal[i][2] == b then
					found = true
					break
				end
			end

			-- trouver deux valeurs sur trois
			if not found then
				for i = 0, 63 do
					c2 = scnPal[i][0] + scnPal[i][1] + scnPal[i][2]
					dist = math.abs(c1 - c2)
					
					if scnPal[i][0] == r and scnPal[i][1] == g then						
						if dist < memDist then
							memDist = dist
							b = scnPal[i][2]
							found = true
							break
						end
					elseif scnPal[i][0] == r and scnPal[i][2] == b then
						if dist < memDist then
							memDist = dist
							g = scnPal[i][1]
							found = true
							break
						end
					elseif scnPal[i][1] == g and scnPal[i][2] == b then
						if dist < memDist then
							memDist = dist
							r = scnPal[i][0]
							found = true
							break
						end
					end
				end
			end
			
			-- trouver une valeur sur trois
			if not found then
				for i = 0, 63 do
					c2 = scnPal[i][0] + scnPal[i][1] + scnPal[i][2]
					dist = math.abs(c1 - c2)

					if scnPal[i][0] == r then
						if dist < memDist then
							memDist = dist
							g = scnPal[i][1]
							b = scnPal[i][2]
							found = true
							break
						end
					elseif scnPal[i][1] == g then
						if dist < memDist then
							memDist = dist
							r = scnPal[i][0]
							b = scnPal[i][2]
							found = true
							break
						end
					elseif scnPal[i][2] == b then
						if dist < memDist then
							memDist = dist
							r = scnPal[i][0]
							g = scnPal[i][1]
							found = true
							break
						end
					end
				end
			end

			-- trouver une valeur sur trois
			if not found then
				for i = 0, 63 do
					c2 = scnPal[i][0] + scnPal[i][1] + scnPal[i][2]
					dist = math.abs(c1 - c2)

					if dist < memDist then
						memDist = dist
						r = scnPal[0]
						g = scnPal[i][1]
						b = scnPal[i][2]
						found = true
						break
					end
				end
			end
			
			-- remplacer la couleur par celle trouvée
			if found then
				bob[n]:setPixel(x, y, r, g, b, a)
			end
		end
	end
	
	-- rétablir le chemin
	love.filesystem.setIdentity(memPath)

	return bob[n]
end

-- afficher un BOB à l'écran
function PasteBOB(n, x, y)
	if bob[n] == nil then return end
	
	for yp = 0, bob[n]:getHeight() - 1 do
		for xp = 0, bob[n]:getWidth( ) - 1 do
			local r, g, b, a = bob[n]:getPixel(xp, yp)
			
			-- scanner la bonne couleur
			for i = 0, 63 do
				if scnPal[i][0] == r and scnPal[i][1] == g and scnPal[i][2] == b then
					break
				end
			end
			
			-- erreur d'importation de fichier
			if i == 64 then RuntimeError("Wrong BOB file !") end
			
			-- afficher le pixel en transparence
			if i > 0 then
				local memGPen = gpen
				gpen = i
				PlotPixel(x, y)			
				gpen = memGPen
			end
		end
	end
end

-- supprimer un BOB
function FreeBOB(n)
	if n < 0 or n > MAX_BOB then return end

	-- supprimer l'ancienne image
	if bob[n] ~= nil then
		bob[n]:release()
	end
end
