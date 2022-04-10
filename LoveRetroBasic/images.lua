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

	-- supprimer l'ancienne image
	bob[n] = {}
	
	-- mémoriser le chemin
	local memPath = love.filesystem.getIdentity()
	
	-- établir le bon chemin
	love.filesystem.setIdentity(path)

	-- créer une image data de la même taille
	local data = love.image.newImageData(filename) -- TODO : remplacer par encoded data
	
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
			local c1 = r + g + b
			local c2 = 0
			local dist = 255 * 3
			local memDist = 255 * 3
			local c = 0

			-- trouver la couleur exacte
			for i = 0, 63 do
				if scnPal[i][0] == r and scnPal[i][1] == g and scnPal[i][2] == b then
					c = i
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
							c = i
							found = true
						end
					elseif scnPal[i][0] == r and scnPal[i][2] == b then
						if dist < memDist then
							memDist = dist
							c = i
							found = true
						end
					elseif scnPal[i][1] == g and scnPal[i][2] == b then
						if dist < memDist then
							memDist = dist
							c = i
							found = true
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
							c = i
							found = true
						end
					elseif scnPal[i][1] == g then
						if dist < memDist then
							memDist = dist
							c = i
							found = true
						end
					elseif scnPal[i][2] == b then
						if dist < memDist then
							memDist = dist
							c = i
							found = true
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

	return bob[n]
end

-- afficher un BOB à l'écran
function PasteBOB(n, x, y)
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
