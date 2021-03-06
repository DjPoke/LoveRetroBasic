-- créer les couleurs de la palette
function CreatePalette()
	-- calculer les teintes assombries
	for x = 0, 7 do
		scnPal[x + 8][0] = math.floor(scnPal[x][0] * 0.75)
		scnPal[x + 8][1] = math.floor(scnPal[x][1] * 0.75)
		scnPal[x + 8][2] = math.floor(scnPal[x][2] * 0.75)

		scnPal[x + 16][0] = math.floor(scnPal[x][0] * 0.5)
		scnPal[x + 16][1] = math.floor(scnPal[x][1] * 0.5)
		scnPal[x + 16][2] = math.floor(scnPal[x][2] * 0.5)

		scnPal[x + 24][0] = math.floor(scnPal[x][0] * 0.25)
		scnPal[x + 24][1] = math.floor(scnPal[x][1] * 0.25)
		scnPal[x + 24][2] = math.floor(scnPal[x][2] * 0.25)

		scnPal[x + 40][0] = math.floor(scnPal[x + 32][0] * 0.75)
		scnPal[x + 40][1] = math.floor(scnPal[x + 32][1] * 0.75)
		scnPal[x + 40][2] = math.floor(scnPal[x + 32][2] * 0.75)

		scnPal[x + 48][0] = math.floor(scnPal[x + 32][0] * 0.5)
		scnPal[x + 48][1] = math.floor(scnPal[x + 32][1] * 0.5)
		scnPal[x + 48][2] = math.floor(scnPal[x + 32][2] * 0.5)

		scnPal[x + 56][0] = math.floor(scnPal[x + 32][0] * 0.25)
		scnPal[x + 56][1] = math.floor(scnPal[x + 32][1] * 0.25)
		scnPal[x + 56][2] = math.floor(scnPal[x + 32][2] * 0.25)
	end

	-- calculer les variantes de noir et gris foncé
	for x = 0, 3 do
		scnPal[x * 8][0] = x * 16
		scnPal[x * 8][1] = x * 16
		scnPal[x * 8][2] = x * 16
	end
	
	-- ajuster les couleurs
	for i = 0, 63 do
		scnPal[i][0] = scnPal[i][0] / 255
		scnPal[i][1] = scnPal[i][1] / 255
		scnPal[i][2] = scnPal[i][2] / 255
	end
	
	scnPalNoAlpha = scnPalNoAlpha / 255
end

-- effacer l'écran dans la couleur désirée
function ClearScreen()
	SetCanvas(true)

	love.graphics.setColor(scnPal[paper][0], scnPal[paper][1], scnPal[paper][2], scnPalNoAlpha)
	love.graphics.rectangle("fill", 0, 0, gmode[currentMode][1], gmode[currentMode][2])
	
	SetCanvas(false)

	Locate(1, 1)
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
	
	if gcursor[1] >= 0 and gcursor[1] <= gmode[currentMode][1] - 1 and gcursor[2] >= 0 and gcursor[2] <= gmode[currentMode][2] - 1 then
		SetCanvas(true)
		
		love.graphics.setColor(scnPal[gpen][0], scnPal[gpen][1], scnPal[gpen][2], scnPalNoAlpha)
		love.graphics.points(gcursor[1] + 0.5, gcursor[2] + 0.5)
		
		SetCanvas(false)
	end
end

-- tracer un point sur l'écran de manière relative
function PlotPixelRelative(x, y)
	gcursor[1] = gcursor[1] + x
	gcursor[2] = gcursor[2] + y
	
	if gcursor[1] >= 0 and gcursor[1] <= gmode[currentMode][1] - 1 and gcursor[2] >= 0 and gcursor[2] <= gmode[currentMode][2] - 1 then
		SetCanvas(true)
		
		love.graphics.setColor(scnPal[gpen][0], scnPal[gpen][1], scnPal[gpen][2], scnPalNoAlpha)
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

	love.graphics.setColor(scnPal[gpen][0], scnPal[gpen][1], scnPal[gpen][2], scnPalNoAlpha)

	if f == 0 then
		love.graphics.rectangle("line", x + 0.5, y + 0.5, w, h)
	else
		love.graphics.rectangle("fill", x + 0.5, y + 0.5, w, h)
	end

	SetCanvas(false)
end

-- tracer un rectangle (vide ou plein) sur un canvas
function DrawRectangleEx(x, y, w, h, f)
	love.graphics.setColor(scnPal[gpen][0], scnPal[gpen][1], scnPal[gpen][2], scnPalNoAlpha)

	if f == 0 then
		love.graphics.rectangle("line", x + 0.5, y + 0.5, w, h)
	else
		love.graphics.rectangle("fill", x + 0.5, y + 0.5, w, h)
	end
end

-- dessiner un ovale
function DrawOval(x, y, w, h, f)
	local md = "line"
	
	if f > 0 then md = "fill" end
	
	SetCanvas(true)
	
	love.graphics.setColor(scnPal[gpen][0], scnPal[gpen][1], scnPal[gpen][2], scnPalNoAlpha)
	love.graphics.ellipse(md, x + 0.5, y + 0.5, w, h)

	SetCanvas(false)
end

-- tracer une ligne
function DrawFullLine(x0, y0, x1, y1)
	SetCanvas(true)
	
	love.graphics.setColor(scnPal[gpen][0], scnPal[gpen][1], scnPal[gpen][2], scnPalNoAlpha)

	if x0 == x1 and y0 == y1 then
		love.graphics.points(x0 + 0.5, y0 + 0.5)
	else
		love.graphics.line(x0, y0 + 0.5, x1, y1 + 0.5)
	end
	
	gcursor[1] = x1
	gcursor[2] = y1

	SetCanvas(false)
end

-- tracer une ligne sur un canvas
function DrawFullLineEx(x0, y0, x1, y1)
	love.graphics.setColor(scnPal[gpen][0], scnPal[gpen][1], scnPal[gpen][2], scnPalNoAlpha)

	if x0 == x1 and y0 == y1 then
		love.graphics.points(x0 + 0.5, y0 + 0.5)
	else
		love.graphics.line(x0, y0 + 0.5, x1, y1 + 0.5)
	end
	
	gcursor[1] = x1
	gcursor[2] = y1
end

-- tracer un bouton d'UI
function DrawButton(x, y, w, h, b, c1, c2, c3)
	-- dessiner le fond du bouton virtuel
	memGPen = gpen
	gpen = c1

	DrawRectangle(x, y, w, h, 1)

	-- dessiner le côté foncé du cadre
	gpen = c3
	
	for i = 0, b - 1 do
		DrawRectangle(x + i, y + i, w - (i * 2) - 1, h - (i * 2) - 1, 0)
	end
	
	-- dessiner le côté clair du cadre
	gpen = c2
	
	for i = 0, b - 1 do
		DrawFullLine(x + i, y + i, x + w - i - 1, y + i)
		DrawFullLine(x + w - i, y + i - 1, x + w - i, y - i + h)
	end
	
	gpen = memGPen
end

-- tracer un bouton d'UI sur un canvas
function DrawButtonEx(x, y, w, h, b, c1, c2, c3)
	-- dessiner le fond du bouton virtuel
	memGPen = gpen
	gpen = c1

	DrawRectangleEx(x, y, w, h, 1)

	-- dessiner le côté foncé du cadre
	gpen = c3
	
	for i = 0, b - 1 do
		DrawRectangleEx(x + i, y + i, w - (i * 2) - 1, h - (i * 2) - 1, 0)
	end
	
	-- dessiner le côté clair du cadre
	gpen = c2
	
	for i = 0, b - 1 do
		DrawFullLineEx(x + i, y + i, x + w - i - 1, y + i)
		DrawFullLineEx(x + w - i, y + i - 1, x + w - i, y - i + h)
	end
	
	gpen = memGPen
end


-- dessiner une image matrice
function DrawMatrix(m, x, y, c1, c2)
	local mgpen = gpen
	
	for j = 1, #m do
		for i = 1, #m[j] do
			if string.sub(m[j], i, i) == "1" then
				-- afficher un point de couleur 1
				gpen = c1
			else
				-- afficher un point de couleur 2
				gpen = c2
			end

			PlotPixel(x + i - 1, y + j - 1)
		end
	end
	
	gpen = mgpen
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
	for y = gmode[currentMode][2] - 8,gmode[currentMode][2] - 1 do
		for x = 0,gmode[currentMode][1] - 1 do
			love.graphics.setColor(scnPal[paper][0], scnPal[paper][1], scnPal[paper][2], scnPalNoAlpha)
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
		for x = 0, gmode[currentMode][1] - 1 do
			love.graphics.setColor(scnPal[paper][0], scnPal[paper][1], scnPal[paper][2], scnPalNoAlpha)
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
	for x = gmode[currentMode][1] - 8,gmode[currentMode][1] - 1 do
		for y = 0,gmode[currentMode][2] - 1 do
			love.graphics.setColor(scnPal[paper][0], scnPal[paper][1], scnPal[paper][2], scnPalNoAlpha)
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
		for y = 0, gmode[currentMode][2] - 1 do
			love.graphics.setColor(scnPal[paper][0], scnPal[paper][1], scnPal[paper][2], scnPalNoAlpha)
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

	-- calculer le facteur d'échelle
	local scale = ss + 1
	
	-- point chaud centré sur x
	if hardspr[spr].hotspot == 1 or hardspr[spr].hotspot == 4 or hardspr[spr].hotspot == 7 then
		x = x - ((SPRITE_WIDTH / 2) * scale)
	end

	-- point chaud à droite
	if hardspr[spr].hotspot == 2 or hardspr[spr].hotspot == 5 or hardspr[spr].hotspot == 8 then
		x = x - (SPRITE_WIDTH * scale)
	end

	-- point chaud centré sur y
	if hardspr[spr].hotspot == 3 or hardspr[spr].hotspot == 4 or hardspr[spr].hotspot == 5 then
		y = y - ((SPRITE_HEIGHT / 2) * scale)
	end

	-- point chaud en bas
	if hardspr[spr].hotspot == 6 or hardspr[spr].hotspot == 7 or hardspr[spr].hotspot == 8 then
		y = y - (SPRITE_HEIGHT * scale)
	end
	
	-- arrondir les coordonnées du sprite
	x = math.floor(x + 0.5)
	y = math.floor(y + 0.5)

	-- dessiner le sprite
	for ys = 0, SPRITE_HEIGHT - 1 do
		for xs = 0, SPRITE_WIDTH - 1 do
			local xptemp = x + (xs * scale)
			local yptemp = y + (ys * scale)
			
			for yp = yptemp, yptemp + scale - 1 do
				for xp = xptemp, xptemp + scale - 1 do			
					if xp >= 0 and xp <= gmode[currentMode][1] - 1 and yp >= 0 and yp <= gmode[currentMode][2] - 1 then
						col = spram[(img * MAX_SPRITE_SIZE) + xs + (ys * SPRITE_WIDTH)]
				
						if col ~= bit.band(tc, 63) then
							love.graphics.setColor(scnPal[col][0], scnPal[col][1], scnPal[col][2], scnPalNoAlpha)
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

-- changer le mode graphique
function SetMode(m)
	if m < 0 or m > 2 then return ERR_TYPE_MISMATCH end
	
	currentMode = m
	
	DeleteRenderers()
	CreateRenderers()
end

-- créer les renderers
function CreateRenderers()
	-- créer les renderers
	renderer[0] = love.graphics.newCanvas(gmode[currentMode][1], gmode[currentMode][2])
	renderer[1] = love.graphics.newCanvas(gmode[currentMode][1], gmode[currentMode][2])
	renderer[2] = love.graphics.newCanvas(gmode[currentMode][1], SCN_SIZE_INFOS_HEIGHT)
	renderer[3] = love.graphics.newCanvas(gmode[currentMode][1], SCN_SIZE_INFOS_HEIGHT)
	renderer[4] = love.graphics.newCanvas(gmode[currentMode][1], SCN_SIZE_INFOS_HEIGHT)

	-- désactiver le flou sur les renderers
	renderer[0]:setFilter('nearest', 'nearest')
	renderer[1]:setFilter('nearest', 'nearest')
	renderer[2]:setFilter('nearest', 'nearest')
	renderer[3]:setFilter('nearest', 'nearest')
	renderer[4]:setFilter('nearest', 'nearest')
end

function DeleteRenderers()
	renderer[0]:release()
	renderer[1]:release()
	renderer[2]:release()
	renderer[3]:release()
	renderer[4]:release()
end