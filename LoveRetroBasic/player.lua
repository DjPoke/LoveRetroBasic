-- mettre à jour la musique
function UpdateMusic(delta)
	if not musicPlaying then return end
	
	-- play a music
	countTime = countTime + delta
	
	-- jouer l'arpège, si il est activé
	for i = 1, 4 do
		if arpeggioType[i] > 1 then
			arpTimer[i] = arpTimer[i] + delta
			if arpTimer[i] >= nextArp[i] then
				arpTimer[i] = 0
				-- stopper les instruments, si nécessaire
				if lastNote[i] ~= 0 then
					if pattern[i][currentNotesLine][mus[currentPattern]] ~= 0 then
						Stop(instr[i][lastNote[i]])
					end
					
					-- jouer la prochaine note d'arpège
					arpeggioCounter[i] = arpeggioCounter[i] + 1
					if arpeggioCounter[i] > 4 then arpeggioCounter[i] = 1 end
					
					-- calculer l'offset de la note
					local ofst = 0
					if arpeggioType[i] == 2 then
						if arpeggioCounter[i] == 1 then
							ofst = 0
						elseif arpeggioCounter[i] == 2 then
							ofst = 7
						elseif arpeggioCounter[i] == 3 then
							ofst = 12
						elseif arpeggioCounter[i] == 4 then
							ofst = 0
						end
					elseif arpeggioType[i] == 3 then
						if arpeggioCounter[i] == 1 then
							ofst = 0
						elseif arpeggioCounter[i] == 2 then
							ofst = 4
						elseif arpeggioCounter[i] == 3 then
							ofst = 7
						elseif arpeggioCounter[i] == 4 then
							ofst = 12
						end
					elseif arpeggioType[i] == 4 then
						if arpeggioCounter[i] == 1 then
							ofst = 0
						elseif arpeggioCounter[i] == 2 then
							ofst = 3
						elseif arpeggioCounter[i] == 3 then
							ofst = 7
						elseif arpeggioCounter[i] == 4 then
							ofst = 12
						end
					end
					
					-- jouer les notes de musiques
					if lastNote[i] + ofst <= 85 then
						if arpLastNote[i] ~= 0 then
							Stop(instr[i][arpLastNote[i]])
							arpLastNote[i] = 0
						end
						arpLastNote[i] = lastNote[i] + ofst
						instr[i][arpLastNote[i]]:setLooping(true)
						instr[i][arpLastNote[i]]:setVolume(tVol[i])
						instr[i][arpLastNote[i]]:play()
					end
				end
			end
		end
	end
	
	-- jouer les lignes de données suivantes
	if countTime >= nextNotes - 0.01 then
		-- la prochaine note est elle vide ? (valeur zéro)
		cn = currentNotesLine + 1
		cp = currentPattern
		if cn > notesPerPattern then
			cn = 1
			cp = cp + 1
			if cp > musicLength then
				cp = 1
			end
		end
		
		-- stopper les instruments, si nécessaire
		if currentNotesLine > 0 then
			for i = 1, 4 do
				if pattern[i][cn][mus[cp]] ~= 0 then
					if lastNote[i] ~= 0 then
						if arpLastNote[i] ~= lastNote[i] and arpLastNote[i] ~= 0 then
							Stop(instr[i][arpLastNote[i]])
						else
							Stop(instr[i][lastNote[i]])
						end
						arpLastNote[i] = 0
						lastNote[i] = 0
					end
				end
			end
		end
	end

	-- jouer les prochaines lignes de données
	if countTime >= nextNotes then
		countTime = countTime - nextNotes
		-- rechercher les prochaines notes à jouer
		currentNotesLine = currentNotesLine + 1
		if currentNotesLine > notesPerPattern then
			currentNotesLine = 1
			currentPattern = currentPattern + 1
			if currentPattern > musicLength then
				currentPattern = 1
			end
		end
		
		-- mettre les volumes	
		for i = 1, 4 do
			tVol[i] = 0.25
			if vol[i][currentNotesLine][mus[currentPattern]] ~= DEFAULT_VOLUME then
				tVol[i] = vol[i][currentNotesLine][mus[currentPattern]] / (4.0 * 15.0)
			end
		end

		for i = 1, 4 do
			if pattern[i][currentNotesLine][mus[currentPattern]] > 0 then
				-- jouer les notes de musique
				if pattern[i][currentNotesLine][mus[currentPattern]] <= 85 then
					if lastNote[i] == 0 then
						lastNote[i] = pattern[i][currentNotesLine][mus[currentPattern]]
						arpeggioCounter[i] = 1
						instr[i][lastNote[i]]:setLooping(true)
						instr[i][lastNote[i]]:setVolume(tVol[i])
						instr[i][lastNote[i]]:play()
					end
				end
			end
		end
	end
end