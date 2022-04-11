-- récupérer un caractère du clavier
function GetCharacter()
	if #kb_buffer > 0 then
		local c = string.sub(kb_buffer, -1)
		kb_buffer = string.sub(kb_buffer, 1, -2)
		return c
	end
	
	return Chr(0)
end

-- attendre la frappe d'une touche
function WaitKey()
end

-- effacer le buffer clavier
function ClearKeyboardBuffer()
	kb_buffer = ""
end

-- récupérer la coordonnée souris X
function GetMousePositionX()
	if not mouseSupport then return 0 end

	local x = love.mouse.getX() - borderX
	x = math.floor(x / gmode[currentMode][3])
	
	if x < 0 then x = 0 end
	if x > gmode[currentMode][1] - 1 then x = gmode[currentMode][1] - 1 end
	
	return x
end

-- récupérer la coordonnée souris Y
function GetMousePositionY()
	if not mouseSupport then return 0 end

	local y = love.mouse.getY() - borderY
	y = math.floor(y / gmode[currentMode][4])
	
	if y < 0 then y = 0 end
	if y > gmode[currentMode][2] - 1 then y = gmode[currentMode][2] - 1 end
	
	return y
end

-- voir si le bouton gauche est appuyé
function GetLeftMouseDown()
	if mouseSupport then
		return mouseDown[1]
	end
	
	return false
end

-- voir si le bouton droit est appuyé
function GetRightMouseDown()
	if mouseSupport then
		return mouseDown[2]
	end
	
	return false
end

-- voir si le bouton du milieu est appuyé
function GetMouseDownCenter()
	if mouseSupport then
		return mouseDown[3]
	end
	
	return false
end

-- voir si un clic gauche vient d'être effectué
function GetLeftMouseClic()
	if mouseSupport then
		return mouseClic[1]
	end
	
	return false
end

-- voir si un clic droit vient d'être effectué
function GetRightMouseClic()
	if mouseSupport then
		return mouseClic[2]
	end
	
	return false
end

-- voir si un clic centre vient d'être effectué
function GetMouseClicCenter()
	if mouseSupport then
		return mouseClic[3]
	end
	
	return false
end

-- voir si un clic gauche vient d'être terminé
function GetMouseReleasedLeft()
	if mouseSupport then
		return mouseRelease[1]
	end
	
	return false
end

-- voir si un clic droit vient d'être terminé
function GetMouseReleasedRight()
	if mouseSupport then
		return mouseRelease[2]
	end
	
	return false
end

-- voir si un clic centre vient d'être terminé
function GetMouseReleasedCenter()
	if mouseSupport then
		return mouseRelease[3]
	end
	
	return false
end
