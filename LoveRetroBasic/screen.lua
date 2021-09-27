-- créer les couleurs de la palette ayant les teintes modifiées
function CreatePalette()
	for x = 0, 15 do
		scnPal[x + 16][0] = math.floor(scnPal[x][0] * 0.75)
		scnPal[x + 16][1] = math.floor(scnPal[x][1] * 0.75)
		scnPal[x + 16][2] = math.floor(scnPal[x][2] * 0.75)

		scnPal[x + 32][0] = math.floor(scnPal[x][0] * 0.5)
		scnPal[x + 32][1] = math.floor(scnPal[x][1] * 0.5)
		scnPal[x + 32][2] = math.floor(scnPal[x][2] * 0.5)

		scnPal[x + 48][0] = math.floor(scnPal[x][0] * 0.25)
		scnPal[x + 48][1] = math.floor(scnPal[x][1] * 0.25)
		scnPal[x + 48][2] = math.floor(scnPal[x][2] * 0.25)
	end

end

-- effacer l'écran dans la couleur désirée
function ClearScreen()
	SetCanvas(true)

	love.graphics.setColor(scnPal[paper][0] / 255, scnPal[paper][1] / 255, scnPal[paper][2] / 255, 1)
	love.graphics.rectangle("fill", 0, 0, SCN_SIZE_WIDTH, SCN_SIZE_HEIGHT)
	
	SetCanvas(false)
end

-- changer la couleur du stylo
function SetPenColor(c)
	-- corriger les erreurs
	if c < 0 or c > 63 or c ~= Round(c) then return ERR_SYNTAX_ERROR end
	
	pen = c
end

-- changer la couleur du papier
function SetPaperColor(c)
	-- corriger les erreurs
	if c < 0 or c > 63 or c ~= Round(c) then return ERR_SYNTAX_ERROR end
	
	paper = c
end

-- changer la couleur du border
function SetBorderColor(c)
	-- corriger les erreurs
	if c < 0 or c > 63 or c ~= Round(c) then return ERR_SYNTAX_ERROR end
	
	border = c
end

-- changer la couleur du stylo graphique
function SetGraphicPenColor(c)
	-- corriger les erreurs
	if c < 0 or c > 63 or c ~= Round(c) then return ERR_SYNTAX_ERROR end
	
	gpen = c
end

-- récupérer la couleur du stylo
function GetPenColor()
	return pen
end

-- récupérer la couleur du papier
function GetPaperColor()
	return paper
end

-- récupérer la couleur du border
function GetBorderColor()
	return border
end

-- récupérer la couleur du stylo graphique
function GetGraphicPenColor()
	return gpen
end

-- repositionner le curseur graphique de manière absolue
function MoveGraphicCursor(x, y)
	gcursor[1] = x
	gcursor[2] = y
end

-- repositionner le curseur graphique de manière relative
function MoveGraphicCursorRelative(x, y)
	gcursor[1] = gcursor[1] + x
	gcursor[2] = gcursor[2] + y
end

-- tracer un point sur l'écran de manière absolue
function PlotPixel(x, y)
	gcursor[1] = x
	gcursor[2] = y
	
	if gcursor[1] >= 0 and gcursor[1] <= 319 and gcursor[2] >= 0 and gcursor[2] <= 199 then
		SetCanvas(true)
		
		love.graphics.setColor(scnPal[gpen][0] / 255, scnPal[gpen][1] / 255, scnPal[gpen][2] / 255, 1)
		love.graphics.points(gcursor[1] + 0.5, gcursor[2] + 0.5)
		
		SetCanvas(false)
	end
end

-- tracer un point sur l'écran de manière relative
function PlotPixelRelative(x, y)
	gcursor[1] = gcursor[1] + x
	gcursor[2] = gcursor[2] + y
	
	if gcursor[1] >= 0 and gcursor[1] <= 319 and gcursor[2] >= 0 and gcursor[2] <= 199 then
		SetCanvas(true)
		
		love.graphics.setColor(scnPal[gpen][0] / 255, scnPal[gpen][1] / 255, scnPal[gpen][2] / 255, 1)
		love.graphics.points(gcursor[1] + 0.5, gcursor[2] + 0.5)
		
		SetCanvas(false)
	end
end

-- tracer un segment sur l'écran de manière absolue
function DrawLine(x1, y1)
	local x0 = gcursor[1]
	local y0 = gcursor[2]

	gcursor[1] = x1
	gcursor[2] = y1
	
	DrawFullLine(x0, y0, x1, y1)
end

-- tracer un segment sur l'écran de manière relative
function DrawLineRelative(x1, y1)
	local x0 = gcursor[1]
	local y0 = gcursor[2]
	
	gcursor[1] = x0 + x1
	gcursor[2] = y0 + y1
	
	x1 = gcursor[1]
	y1 = gcursor[2]

	DrawFullLine(x0, y0, x1, y1)
end

-- tracer un rectangle (vide ou plein) sur l'écran de manière absolue
function DrawRectangle(x, y, w, h, f)
	SetCanvas(true)

	love.graphics.setColor(scnPal[gpen][0] / 255, scnPal[gpen][1] / 255, scnPal[gpen][2] / 255, 1)

	if f == 0 then
		love.graphics.rectangle("line", x + 0.5, y + 0.5, w, h)
	else
		love.graphics.rectangle("fill", x + 0.5, y + 0.5, w, h)
	end

	SetCanvas(false)
end

-- dessiner un ovale
function DrawOval(x, y, w, h, f)
	local mode = "line"
	
	if f > 0 then mode = "fill" end
	
	SetCanvas(true)
	
	love.graphics.setColor(scnPal[gpen][0] / 255, scnPal[gpen][1] / 255, scnPal[gpen][2] / 255, 1)
	love.graphics.ellipse(mode, x + 0.5, y + 0.5, w, h)

	SetCanvas(false)
end

-- tracer une ligne
function DrawFullLine(x0, y0, x1, y1)
	SetCanvas(true)
	
	love.graphics.setColor(scnPal[gpen][0] / 255, scnPal[gpen][1] / 255, scnPal[gpen][2] / 255, 1)

	if x0 == x1 and y0 == y1 then
		love.graphics.points(x0 + 0.5, y0 + 0.5)
	else
		love.graphics.line(x0, y0 + 0.5, x1, y1 + 0.5)
	end

	SetCanvas(false)
end

-- faire scroller l'écran vers le haut de 1 caractère
function ScrollScreenUp()
	-- scroller
	local tmpRenderer = love.graphics.newCanvas(renderer[currentRenderer]:getDimensions())
	love.graphics.setCanvas(tmpRenderer)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(renderer[currentRenderer], 0, 0)
	love.graphics.setCanvas(renderer[currentRenderer])
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(tmpRenderer, 0, -8)
		
	-- effacer la ligne du bas
	for y = SCN_SIZE_HEIGHT - 8,SCN_SIZE_HEIGHT - 1 do
		for x = 0,SCN_SIZE_WIDTH - 1 do
			love.graphics.setColor(scnPal[paper][0] / 255, scnPal[paper][1] / 255, scnPal[paper][2] / 255, 1)
			love.graphics.points(x + 0.5, y + 0.5)
		end
	end

	love.graphics.setCanvas()
end

-- faire scroller l'écran vers le bas de 1 caractère
function ScrollScreenDown()
	-- scroller
	local tmpRenderer = love.graphics.newCanvas(renderer[currentRenderer]:getDimensions())
	love.graphics.setCanvas(tmpRenderer)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(renderer[currentRenderer], 0, 0)
	love.graphics.setCanvas(renderer[currentRenderer])
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(tmpRenderer, 0, 8)
	
	-- effacer la ligne du bas
	for y = 0, 7 do
		for x = 0, SCN_SIZE_WIDTH - 1 do
			love.graphics.setColor(scnPal[paper][0] / 255, scnPal[paper][1] / 255, scnPal[paper][2] / 255, 1)
			love.graphics.points(x + 0.5, y + 0.5)
		end
	end

	love.graphics.setCanvas()
end

-- faire scroller l'écran vers la gauche
function ScrollScreenLeft()
	-- scroller
	local tmpRenderer = love.graphics.newCanvas(renderer[currentRenderer]:getDimensions())
	love.graphics.setCanvas(tmpRenderer)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(renderer[currentRenderer], 0, 0)
	love.graphics.setCanvas(renderer[currentRenderer])
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(tmpRenderer, -8, 0)
		
	-- effacer la ligne de droite
	for x = SCN_SIZE_WIDTH - 8,SCN_SIZE_WIDTH - 1 do
		for y = 0,SCN_SIZE_HEIGHT - 1 do
			love.graphics.setColor(scnPal[paper][0] / 255, scnPal[paper][1] / 255, scnPal[paper][2] / 255, 1)
			love.graphics.points(x + 0.5, y + 0.5)
		end
	end

	love.graphics.setCanvas()
end

-- faire scroller l'écran vers la droite de 1 caractère
function ScrollScreenRight()
	-- scroller
	local tmpRenderer = love.graphics.newCanvas(renderer[currentRenderer]:getDimensions())
	love.graphics.setCanvas(tmpRenderer)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(renderer[currentRenderer], 0, 0)
	love.graphics.setCanvas(renderer[currentRenderer])
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(tmpRenderer, 8, 0)
	
	-- effacer la ligne de gauche
	for x = 0, 7 do
		for y = 0, SCN_SIZE_HEIGHT - 1 do
			love.graphics.setColor(scnPal[paper][0] / 255, scnPal[paper][1] / 255, scnPal[paper][2] / 255, 1)
			love.graphics.points(x + 0.5, y + 0.5)
		end
	end

	love.graphics.setCanvas()
end

-- changer la position du sprite
function SetSpritePosition(spr, x, y)
	-- numéro de sprite erroné
	if spr < 0 or spr > MAX_HARD_SPRITES - 1  then return ERR_SYNTAX_ERROR end
	
	hardspr[spr].x = x
	hardspr[spr].y = y
	
	return OK
end

-- changer l'image du sprite
function SetSpriteImage(spr, img)
	-- numéro de sprite erroné
	if spr < 0 or spr > MAX_HARD_SPRITES - 1 then return ERR_SYNTAX_ERROR end
	
	-- numéro d'image erroné
	if img < 0 or img > MAX_SPRITES_IMAGES - 1 then return ERR_SYNTAX_ERROR end

	hardspr[spr].img = img
	
	return OK
end

-- dessiner un sprite à l'écran avec la couleur transparente
function DrawSprite(spr)
	-- numéro de sprite erroné
	if spr < 0 or spr > MAX_HARD_SPRITES - 1 then return ERR_SYNTAX_ERROR end
	
	if not hardspr[spr].on then return end
	
	img = hardspr[spr].img
	ss = hardspr[spr].scale
	tc = hardspr[spr].transp

	if img < 0 or img >= MAX_SPRITES_IMAGES - 1 then return end
	
	SetCanvas(true)

	local x = hardspr[spr].x
	local y = hardspr[spr].y

	w = sprImgSize[img].w
	h = sprImgSize[img].h
	
	local scale = ss + 1
	
	if hardspr[spr].hotspot == 1 or hardspr[spr].hotspot == 4 or hardspr[spr].hotspot == 7 then
		x = x - (math.floor(w / 2) * scale) + 1
	end

	if hardspr[spr].hotspot == 2 or hardspr[spr].hotspot == 5 or hardspr[spr].hotspot == 8 then
		x = x - w + 1
	end

	if hardspr[spr].hotspot == 3 or hardspr[spr].hotspot == 4 or hardspr[spr].hotspot == 5 then
		y = y - (math.floor(h / 2) * scale) + 1
	end

	if hardspr[spr].hotspot == 6 or hardspr[spr].hotspot == 7 or hardspr[spr].hotspot == 8 then
		y = y - h + 1
	end

	for ys = 0, h - 1 do
		for xs = 0, w - 1 do
			local xptemp = x + (xs * scale)
			local yptemp = y + (ys * scale)
			
			for yp = yptemp, yptemp + scale - 1 do
				for xp = xptemp, xptemp + scale - 1 do			
					if xp >= 0 and xp <= 319 and yp >= 0 and yp <= 199 then
						col = spram[(img * MAX_SPRITE_SIZE) + xs + (ys * w)]
				
						if col ~= bit.band(tc, 63) then
							love.graphics.setColor(scnPal[col][0] / 255, scnPal[col][1] / 255, scnPal[col][2] / 255, 1)
							love.graphics.points(xp + 0.5, yp + 0.5)
						end
					end
				end
			end			
		end
	end
		
	SetCanvas(false)
end

-- changer la position du point chaud
function SetHotspotPosition(spr, hsp)
	-- numéro de sprite erroné
	if spr < 0 or spr > MAX_HARD_SPRITES - 1 then return ERR_SYNTAX_ERROR end
	
	-- corriger les erreurs
	if hsp < 0 or hsp > 8 then return ERR_SYNTAX_ERROR end
	
	hardspr[spr].hotspot = hsp
	
	return OK
end

-- change la taille du sprite
function SetSpriteScale(spr, ss)
	-- numéro de sprite erroné
	if spr < 0 or spr > MAX_HARD_SPRITES - 1 then return ERR_SYNTAX_ERROR end
	
	-- corriger les erreurs
	if ss < 0 or ss > 3 then return ERR_SYNTAX_ERROR end
	
	hardspr[spr].scale = ss
	
	return OK
end

-- changer la couleur transparente du sprite
function SetSpriteTransparentColor(spr, tc)
	-- numéro de sprite erroné
	if spr < 0 or spr > MAX_HARD_SPRITES - 1 then return ERR_SYNTAX_ERROR end
	
	-- corriger les erreurs
	if tc < 0 or tc > 63 then return ERR_SYNTAX_ERROR end
	
	hardspr[spr].transp = tc
	
	return OK
end

-- autoriser le sprite à être dessiné
function EnableSprite(spr, e)
	-- numéro de sprite erroné
	if spr < 0 or spr > MAX_HARD_SPRITES - 1 then return ERR_SYNTAX_ERROR end
	
	hardspr[spr].on = e
	
	return OK
end

-- attendre que l'affichage soit fait
function WaitVBL()
	VBL = true
	
	return OK
end