-- créer les sons nécessaires
function CreateSounds(ch, snd)

	local channels = 2 -- stereo
	local sampleRate = 44100 -- 44100 Htz
	local bitsPerSample = 16 -- son 16 bits

	-- fréquences des notes, de C1 à C8
	local note = {}
	note[85] = 4434.92
	note[84] = 4186.01
	note[83] = 3951.07
	note[82] = 3729.31
	note[81] = 3520.00
	note[80] = 3322.44
	note[79] = 3135.96
	note[78] = 2959.96
	note[77] = 2793.83
	note[76] = 2637.02
	note[75] = 2349.32
	note[74] = 2217.46
	note[73] = 2093.00
	note[72] = 1975.53
	note[71] = 1864.66
	note[70] = 1760.00
	note[69] = 1661.22
	note[68] = 1567.98
	note[67] = 1479.98
	note[66] = 1396.91
	note[65] = 1318.51
	note[64] = 1244.51
	note[63] = 1174.66
	note[62] = 1108.73
	note[61] = 1046.50
	note[60] = 987.77
	note[59] = 932.33
	note[58] = 880.00
	note[57] = 830.61
	note[56] = 783.99
	note[55] = 739.99
	note[54] = 698.46
	note[53] = 659.25
	note[52] = 622.25
	note[51] = 587.33
	note[50] = 554.37
	note[49] = 523.25
	note[48] = 493.88
	note[47] = 466.16
	note[46] = 440.00
	note[45] = 415.30
	note[44] = 392.00
	note[43] = 369.99
	note[42] = 349.23
	note[41] = 329.63
	note[40] = 311.13
	note[39] = 293.66
	note[38] = 277.18
	note[37] = 261.63
	note[36] = 246.94
	note[35] = 233.08
	note[34] = 220.00
	note[33] = 207.65
	note[32] = 196.00
	note[31] = 185.00
	note[30] = 174.61
	note[29] = 164.81
	note[28] = 155.56
	note[27] = 146.83
	note[26] = 138.59
	note[25] = 130.81
	note[24] = 123.47
	note[23] = 116.54
	note[22] = 110.00
	note[21] = 103.83
	note[20] = 98.00
	note[19] = 92.50
	note[18] = 87.31
	note[17] = 82.41
	note[16] = 77.78
	note[15] = 73.42
	note[14] = 69.30
	note[13] = 65.41
	note[12] = 61.74
	note[11] = 58.27
	note[10] = 55.00
	note[9] = 51.91
	note[8] = 49.00
	note[7] = 46.25
	note[6] = 43.65
	note[5] = 41.20
	note[4] = 38.89
	note[3] = 36.71
	note[2] = 34.65
	note[1] = 32.70

	-- créer les sons en stéréo
	coef_left = 1.0
	coef_right = 1.0
	if ch == 1 then
		coef_right = 0.0
	elseif ch == 2 then
		coef_left = 0.75
		coef_right = 0.25
	elseif ch == 3 then
		coef_left = 0.25
		coef_right = 0.75
	elseif ch == 4 then
		coef_left = 0.0
	end
	
	-- générer tous les sons
	for notes = 1, 85 do
	 	-- de C1 à C8 <=> note[1] à note[85]
        local sampleLen = Round(sampleRate / note[notes])
	
		-- créer un sample
		local wav = love.sound.newSoundData(sampleLen, sampleRate, bitsPerSample, channels)

		-- générer le son
		for i = 0, sampleLen - 1, 2 do
			local val = 0
			if snd == 1 then
				local j = i % sampleLen
				local angle = (360.0 / sampleLen)  * j
				val = math.sin(math.rad(angle)) * 32760
			elseif snd == 2 then
				local j = i % sampleLen
				local p4 = sampleLen / 4
				if j <= math.floor(sampleLen / 4) then
					val = (32760 * (j / p4))
				elseif j <= math.floor(sampleLen / 2) then
					val = (32760 * ((sampleLen - j) / p4))
				elseif j <= math.floor(sampleLen * 3 / 4) then
					val = (32760 * (-j / p4))
				else
					val = (32760 * ((j - sampleLen) / p4))
				end
			elseif snd == 3 then
				local j = i % sampleLen
				if j < math.floor(sampleLen / 2) then
					val = 32760
				else
					val = -32760
				end
			elseif snd == 4 then
				local j = i % sampleLen
				val = (65520 * ((sampleLen - j) / sampleLen)) - 32760
			end
			
			wav:setSample(i, 1, math.floor(val * coef_left) / 32767)
			wav:setSample(i, 2, math.floor(val * coef_right) / 32767)
		end

		instr[ch][notes] = love.audio.newSource(wav, "static")
	end
end

-- initialiser le piano virtuel
function InitPiano()
	piano[23] = { "noire", 15, 286, 2 }
	piano[24] = { "noire", 27, 286, 4 }
	piano[25] = { "noire", 51, 286, 7 }
	piano[26] = { "noire", 63, 286, 9 }
	piano[27] = { "noire", 75, 286, 11 }
	piano[28] = { "noire", 99, 286, 14 }
	piano[29] = { "noire", 111, 286, 16 }
	piano[30] = { "noire", 135, 286, 19 }
	piano[31] = { "noire", 147, 286, 21 }
	piano[32] = { "noire", 159, 286, 23 }
	piano[33] = { "noire", 183, 286, 26 }
	piano[34] = { "noire", 195, 286, 28 }
	piano[35] = { "noire", 219, 286, 31 }
	piano[36] = { "noire", 231, 286, 33 }
	piano[37] = { "noire", 243, 286, 35 }
	
	piano[1][4] = 1
	piano[2][4] = 3
	piano[3][4] = 5
	piano[4][4] = 6
	piano[5][4] = 8
	piano[6][4] = 10
	piano[7][4] = 12
	piano[8][4] = 13
	piano[9][4] = 15
	piano[10][4] = 17
	piano[11][4] = 18
	piano[12][4] = 20
	piano[13][4] = 22
	piano[14][4] = 24
	piano[15][4] = 25
	piano[16][4] = 27
	piano[17][4] = 29
	piano[18][4] = 30
	piano[19][4] = 32
	piano[20][4] = 34
	piano[21][4] = 36
	piano[22][4] = 37
end

-- initialiser les touches du clavier pour jouer du piano
function InitKeyboard()
	if keyboard == AZERTY then
		-- touches du bas pour clavier AZERTY
		kb[1] = {"w", 1}
		kb[2] = {"s", 2}
		kb[3] = {"x", 3}
		kb[4] = {"s", 4}
		kb[5] = {"c", 5}
		kb[6] = {"v", 6}
		kb[7] = {"g", 7}
		kb[8] = {"b", 8}
		kb[9] = {"h", 9}
		kb[10] = {"n", 10}
		kb[11] = {"j", 11}
		kb[12] = {",", 12}
		kb[13] = {";", 13}
		kb[14] = {"l", 14}
		kb[15] = {":", 15}
		kb[16] = {"m", 16}
		kb[17] = {"!", 17}

		-- touches du haut pour clavier AZERTY
		kb[18] = {"a", 13}
		kb[19] = {"é", 14}
		kb[20] = {"z", 15}
		kb[21] = {"\"", 16}
		kb[22] = {"e", 17}
		kb[23] = {"r", 18}
		kb[24] = {"(", 19}
		kb[25] = {"t", 20}
		kb[26] = {"-", 21}
		kb[27] = {"y", 22}
		kb[28] = {"è", 23}
		kb[29] = {"u", 24}
		kb[30] = {"i", 25}
		kb[31] = {"ç", 26}
		kb[32] = {"o", 27}
		kb[33] = {"à", 28}
		kb[34] = {"p", 29}
	else
		-- touches du bas pour clavier QWERTY
		kb[1] = {"z", 1}
		kb[2] = {"s", 2}
		kb[3] = {"x", 3}
		kb[4] = {"s", 4}
		kb[5] = {"c", 5}
		kb[6] = {"v", 6}
		kb[7] = {"g", 7}
		kb[8] = {"b", 8}
		kb[9] = {"h", 9}
		kb[10] = {"n", 10}
		kb[11] = {"j", 11}
		kb[12] = {"m", 12}
		kb[13] = {"<", 13}
		kb[14] = {"l", 14}
		kb[15] = {">", 15}
		kb[16] = {";", 16}
		kb[17] = {"?", 17}

		-- touches du haut pour clavier QWERTY
		kb[18] = {"q", 13}
		kb[19] = {"2", 14}
		kb[20] = {"w", 15}
		kb[21] = {"3", 16}
		kb[22] = {"e", 17}
		kb[23] = {"r", 18}
		kb[24] = {"5", 19}
		kb[25] = {"t", 20}
		kb[26] = {"6", 21}
		kb[27] = {"y", 22}
		kb[28] = {"7", 23}
		kb[29] = {"u", 24}
		kb[30] = {"i", 25}
		kb[31] = {"9", 26}
		kb[32] = {"o", 27}
		kb[33] = {"0", 28}
		kb[34] = {"p", 29}
	end
end

-- montrer les informations des pistes
function ShowTracks(l1, l2, l0, pat, tr)
	local noteName = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}
	
	for j = l1, l2 do
		local ln = {"", "", "", ""}
		local fullLine = ""
		for i = 1, 4 do
			local n = pattern[i][j][pat]
			
			if n == 0 then
				ln[i] = "___"
			elseif n == NOTEOFF then
				ln[i] = "OFF"
			else
				ln[i] = noteName[math.fmod(n - 1, 12) + 1] .. tostring(math.floor((n - 1) / 12) + 1)
				if #noteName[math.fmod(n - 1, 12) + 1] == 1 then
					ln[i] = ln[i] .. "_"
				end
			end
			
			ln[i] = ln[i] .. " V"
			if vol[i][j][pat] == DEFAULT_VOLUME then
				ln[i] = ln[i] .. "__ "
			else
				local st = string.upper(string.format("%x", vol[i][j][pat]))
				if string.len(st) == 1 then
					st = "0" .. st
				end
				ln[i] = ln[i] .. st .. " "
			end
			
			local lcx = ""
			
			if i == 1 then
				lcx = string.upper(string.format("%x", j - 1))
				if #lcx == 1 then
					lcx = "0" .. lcx
				end
				lcx = lcx .. " "
			end
			
			fullLine = lcx ..fullLine .. ln[i] .. " "
		end
		
		if j - l1 == l0 - 1 - (l2 - 16) and state == PLAY  then
			rect(28, 4 + ((l0 - 1 - (l2 - 16)) * 16), 284+24, 4 + ((l0 - (l2 - 16)) * 16) - 1, true, 26)
		end

		Text(fullLine, 8, 4 + ((j - l1) * 16), 1)
		
		if j - l1 == l0 - 1 - (l2 - 16) and state ~= PLAY then
			if tr == 1 then
				Text(ln[1], 32, 4 + ((j - l1) * 16), 2)
				
				if showVolumeTrigger then
					Text(string.sub(ln[1], 5, 7), 64, 4 + ((j - l1) * 16), 38)
				end
			elseif tr == 2 then
				Text(ln[2], 104, 4 + ((j - l1) * 16), 2)
				
				if showVolumeTrigger then
					Text(string.sub(ln[2], 5, 7), 136, 4 + ((j - l1) * 16), 38)
				end
			elseif tr == 3 then
				Text(ln[3], 176, 4 + ((j - l1) * 16), 2)
				
				if showVolumeTrigger then
					Text(string.sub(ln[3], 5, 7), 208, 4 + ((j - l1) * 16), 38)
				end
			elseif tr == 4 then
				Text(ln[4], 176 + 72, 4 + ((j - l1) * 16), 2)
				
				if showVolumeTrigger then
					Text(string.sub(ln[4], 5, 7), 208+72, 4 + ((j - l1) * 16), 38)
				end
			end
		end
	end
end

-- récupérer l'état des claviers hardware et software
function GetKeyboardPlay(ch, delta)
	-- clavier hardware
	for i = 1, 34 do
		if love.keyboard.isDown(kb[i][1]) then
			j = kb[i][2]
			if currentPianoNote > 0 then
				if currentPianoNote ~= j + ((currentOctave - 1) * 12) then
					if currentArpNote ~= currentPianoNote and currentArpNote > 0 then
						stop(instr[ch][currentArpNote])
					else
						stop(instr[ch][currentPianoNote])
					end
					
					currentPianoNote = 0
					currentArpNote = 0
					
					if j + ((currentOctave - 1) * 12) <= 85 then
						currentPianoNote = j + ((currentOctave - 1) * 12)
						arpeggioCounter[ch] = 1
						play(instr[ch][currentPianoNote], true, 0, 1)
					end
				elseif arpeggioType[ch] > 1 then
					arpTimer[ch] = arpTimer[ch] + delta
					
					if arpTimer[ch] >= nextArp[ch] then
						arpTimer[ch] = arpTimer[ch] - nextArp[ch]
						stop(instr[ch][currentPianoNote])
					end
					
					-- jouer la prochaine note d'arpège
					arpeggioCounter[ch] = arpeggioCounter[ch] + 1
					
					if arpeggioCounter[ch] > 4 then arpeggioCounter[ch] = 1 end
					
					-- calculer l'offset de la note
					local ofst = 0
					
					if arpeggioType[ch] == 2 then
						if arpeggioCounter[ch] == 1 then
							ofst = 0
						elseif arpeggioCounter[ch] == 2 then
							ofst = 7
						elseif arpeggioCounter[ch] == 3 then
							ofst = 12
						elseif arpeggioCounter[ch] == 4 then
							ofst = 0
						end
					elseif arpeggioType[ch] == 3 then
						if arpeggioCounter[ch] == 1 then
							ofst = 0
						elseif arpeggioCounter[ch] == 2 then
							ofst = 4
						elseif arpeggioCounter[ch] == 3 then
							ofst = 7
						elseif arpeggioCounter[ch] == 4 then
							ofst = 12
						end
					elseif arpeggioType[ch] == 4 then
						if arpeggioCounter[ch] == 1 then
							ofst = 0
						elseif arpeggioCounter[ch] == 2 then
							ofst = 3
						elseif arpeggioCounter[ch] == 3 then
							ofst = 7
						elseif arpeggioCounter[ch] == 4 then
							ofst = 12
						end
					end
					
					-- jouer les notes de musique
					if currentPianoNote + ofst <= 85 then
						currentArpNote = currentPianoNote + ofst
						play(instr[ch][currentArpNote], true, 0, 1)
					end
				end
			else
				if j + ((currentOctave - 1) * 12) <= 85 then
					currentPianoNote = j + ((currentOctave - 1) * 12)
					arpeggioCounter[ch] = 1
					play(instr[ch][currentPianoNote], true, 0, 1)
				end
			end
			
			return currentPianoNote
		end
	end
	

	-- récupérer l'état de la souris pour le clavier software
	local mx = mouseX
	local my = mouseY
	local mb1, mb2, mb3 = love.mouse.isDown("1", "2", "3")

	if mb1 then
		for i = 37, 1, -1 do
			local sx = 10
			local sy = 20
			
			if i < 23 then
				sx = 12
				sy = 32
			end
			
			if mx >= piano[i][2] and mx <= piano[i][2] + sx - 1 and my >= piano[i][3] and my <= piano[i][3] + sy - 1 then
				if currentPianoNote > 0 then
					if currentPianoNote ~= piano[i][4] + ((currentOctave - 1) * 12) then
						if currentPianoNote ~= piano[i][4] + ((currentOctave - 1) * 12) then
							if currentArpNote ~= currentPianoNote and currentArpNote > 0 then
								stop(instr[ch][currentArpNote])
							else
								stop(instr[ch][currentPianoNote])
							end
							
							currentPianoNote = 0
							currentArpNote = 0
						end
						
						if piano[i][4] + ((currentOctave - 1) * 12) <= 85 then
							currentPianoNote = piano[i][4] + ((currentOctave - 1) * 12)
							play(instr[ch][currentPianoNote], true, 0, 1)
						end
					elseif arpeggioType[ch] > 1 then
						arpTimer[ch] = arpTimer[ch] + delta
						
						if arpTimer[ch] >= nextArp[ch] then
							arpTimer[ch] = arpTimer[ch] - nextArp[ch]
							stop(instr[ch][currentPianoNote])
						end
						
						-- jouer les prochaines notes d'arpège
						arpeggioCounter[ch] = arpeggioCounter[ch] + 1
						
						if arpeggioCounter[ch] > 4 then arpeggioCounter[ch] = 1 end
						
						-- calculer l'offset de la note
						local ofst = 0
						if arpeggioType[ch] == 2 then
							if arpeggioCounter[ch] == 1 then
								ofst = 0
							elseif arpeggioCounter[ch] == 2 then
								ofst = 7
							elseif arpeggioCounter[ch] == 3 then
								ofst = 12
							elseif arpeggioCounter[ch] == 4 then
								ofst = 0
							end
						elseif arpeggioType[ch] == 3 then
							if arpeggioCounter[ch] == 1 then
								ofst = 0
							elseif arpeggioCounter[ch] == 2 then
								ofst = 4
							elseif arpeggioCounter[ch] == 3 then
								ofst = 7
							elseif arpeggioCounter[ch] == 4 then
								ofst = 12
							end
						elseif arpeggioType[ch] == 4 then
							if arpeggioCounter[ch] == 1 then
								ofst = 0
							elseif arpeggioCounter[ch] == 2 then
								ofst = 3
							elseif arpeggioCounter[ch] == 3 then
								ofst = 7
							elseif arpeggioCounter[ch] == 4 then
								ofst = 12
							end
						end
						
						-- jouer les notes de musique
						if currentPianoNote + ofst <= 85 then
							currentArpNote = currentPianoNote + ofst
							play(instr[ch][currentArpNote], true, 0, 1)
						end
					end
				else
					if piano[i][4] + ((currentOctave - 1) * 12) <= 85 then
						currentPianoNote = piano[i][4] + ((currentOctave - 1) * 12)
						play(instr[ch][currentPianoNote], true, 0, 1)
					end
				end
				
				break
			end
		end
	elseif currentPianoNote > 0 then
		if currentArpNote ~= currentPianoNote and currentArpNote > 0 then
			stop(instr[ch][currentArpNote])
		else
			stop(instr[ch][currentPianoNote])
		end
		
		currentPianoNote = 0
		currentArpNote = 0
	end
	
	return currentPianoNote
end

-- récupérer le layout clavier
function GetKeyboardLayout()
	f = defaultFolder
	
	if not os.rename(f .. "config.cfg", f .. "config.cfg") then
		keyboard = QWERTY
		
		local file = io.open(f .. "config.cfg", "w")
		
		file:write("QWERTY")
		file:close()
	end
		
	if os.rename(f .. "config.cfg", f .. "config.cfg") then
		local file = io.open(f .. "config.cfg", "rb")
		
		if file:read() == "AZERTY" then
			keyboard = AZERTY
		else
			keyboard = QWERTY
		end

		file:close()
	end
end

-- mettre à jouer le layout clavier
function UpdateKeyboardLayout()
	f = defaultFolder

	local file = io.open(f .. "config.cfg", "rb")
	
	if keyboard == QWERTY then
		file:write("QWERTY")
	else
		file:write("AZERTY")
	end
	
	file:close()
end

-- stopper un instrument du tracker
function SoundStop()
	if currentNotesLine > 0 then
		for i = 1, 4 do
			if lastNote[i] ~= 0 then
				if arpLastNote[i] ~= lastNote[i] and arpLastNote[i] ~= 0 then
					stop(instr[i][arpLastNote[i]])
				else
					stop(instr[i][lastNote[i]])
				end
				
				arpLastNote[i] = 0
				lastNote[i] = 0
			end
		end
	end
end
