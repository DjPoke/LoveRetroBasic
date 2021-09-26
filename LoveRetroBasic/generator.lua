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

	-- create the sounds in stereo
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