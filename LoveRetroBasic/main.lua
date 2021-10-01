-- ==========================================
-- LoveRetroBasic, par retro-bruno, (c) 2021
-- ==========================================

-- ===============================
-- - import de la librairie UTF8 =
-- ===============================
local utf8 = require("utf8")

-- =======================================
-- - vérifier si la souris est supportée =
-- =======================================
mouseSupport = love.mouse.isCursorSupported()

if mouseSupport then
	love.mouse.setRelativeMode(false)
	if not love.mouse.isVisible() then
		love.mouse.setVisible(true)
	end
end

-- =============================
-- = integer!, float%, string$ =
-- =============================
VAR_INTEGER = 1
VAR_FLOAT = 2
VAR_NUM = 3 -- types numériques confondus
VAR_STRING = 4
VAR_POLY = 5 -- types numériques ou chaîne confondus
VAR_LABEL = 6
VAR_CONDITION = 7 -- true ou false, comparaison
VAR_VAR = 8 -- un nom de variable
VAR_CONSTANT = 9 -- une constante (numérique ou chaîne de caractères)

-- constantes du scrolling de l'éditeur
PRINT_NO_FLAGS = 0
PRINT_CLIPPED = 1
PRINT_NOT_CLIPPED = 2
PRINT_NOT_CLIPPED_NO_SCROLL = 3

-- constantes couleurs de l'éditeur
DEFAULT_PEN = 6
DEFAULT_LABELS_PEN = 10
DEFAULT_COMMENTS_PEN = 9
DEFAULT_INSTRUCTIONS_PEN = 4
DEFAULT_PAPER = 43

-- ralentir le jeu par défaut (en FPS)
DEFAULT_VBL = 1

-- ===================================================
-- = définir la liste des instructions de RetroBasic =
-- ===================================================

-- liste des noms de commandes
commands = {
			"ABS", "ASC",
			"BIN$", "BORDER",
			"CASE", "CHR$", "CLS",
			"DRAW", "DRAWR",
			"ELSEIF", "ELSE", "ENDIF", "ENDSELECT", "END",
			"FOR",
			"GETBORDER", "GETLOCX", "GETLOCY", "GETPAPER", "GETPEN", "GETGRAPHPEN", "GOSUB", "GOTO", "GRAPHPEN",
			"HEX$", "HOTSPOT",
			"IF", "INKEY$", "INPUT",
			"LINE", "LOCATE",
			"MOVE", "MOVER", "MUSIC",
			"NEXT",
			"OVAL",
			"PAPER", "PEN", "PLOT", "PLOTR", "PRINT",
			"RECT", "REPEAT", "RETURN",
			"SELECT", "SGN", "SPRITEIMG", "SPRITEOFF", "SPRITEON", "SPRITEPOS", "SPRITESCALE", "SPRITETRANSP", "STOPMUSIC",
			"UNTIL",
			"VAL",
			"WAITVBL", "WEND", "WHILE"
		}

-- liste des identifiants de commandes
cmd = {}

-- entrées des fonctions dans une table
for i = 1, #commands do
	cmd[commands[i]] = {fn = nil, ret = 0, pmin = 0, pmax = 0, ptype = VAR_INTEGER, word2 = "", word3 = "", wmin = 1, wmax = 1}
end

-- définir le type de valeur retournée pour chaque instruction BASIC
cmd["ABS"].ret = VAR_NUM
cmd["ASC"].ret = VAR_INTEGER
cmd["BIN$"].ret = VAR_STRING
cmd["CHR$"].ret = VAR_STRING
cmd["GETBORDER"].ret = VAR_INTEGER
cmd["GETGRAPHPEN"].ret = VAR_INTEGER
cmd["GETLOCX"].ret = VAR_INTEGER
cmd["GETLOCY"].ret = VAR_INTEGER
cmd["GETPAPER"].ret = VAR_INTEGER
cmd["GETPEN"].ret = VAR_INTEGER
cmd["HEX$"].ret = VAR_STRING
cmd["INKEY$"].ret = VAR_STRING
cmd["INPUT"].ret = VAR_STRING
cmd["SGN"].ret = VAR_NUM
cmd["VAL"].ret = VAR_NUM

-- définir le nombre minimal et maximal de paramètres d'entrée pour les instructions BASIC
cmd["ABS"].pmin, cmd["ABS"].pmax = 1, 1
cmd["ASC"].pmin, cmd["ASC"].pmax = 1, 1
cmd["BIN$"].pmin, cmd["BIN$"].pmax = 1, 1
cmd["BORDER"].pmin, cmd["BORDER"].pmax = 1, 1
cmd["CHR$"].pmin, cmd["CHR$"].pmax = 1, 1
cmd["DRAW"].pmin, cmd["DRAW"].pmax = 2, 2
cmd["DRAWR"].pmin, cmd["DRAWR"].pmax = 2, 2
cmd["ELSEIF"].pmin, cmd["ELSEIF"].pmax = 1, 1
cmd["FOR"].pmin, cmd["FOR"].pmax = 2, 3
cmd["GOSUB"].pmin, cmd["GOSUB"].pmax = 1, 1
cmd["GOTO"].pmin, cmd["GOTO"].pmax = 1, 1
cmd["GRAPHPEN"].pmin, cmd["GRAPHPEN"].pmax = 1, 1
cmd["HEX$"].pmin, cmd["HEX$"].pmax = 1, 1
cmd["HOTSPOT"].pmin, cmd["HOTSPOT"].pmax = 2, 2
cmd["IF"].pmin, cmd["IF"].pmax = 1, 1
cmd["LINE"].pmin, cmd["LINE"].pmax = 4, 4
cmd["LOCATE"].pmin, cmd["LOCATE"].pmax = 2, 2
cmd["MOVE"].pmin, cmd["MOVE"].pmax = 2, 2
cmd["MOVER"].pmin, cmd["MOVER"].pmax = 2, 2
cmd["MUSIC"].pmin, cmd["MUSIC"].pmax = 1, 1
cmd["OVAL"].pmin, cmd["OVAL"].pmax = 5, 5
cmd["PAPER"].pmin, cmd["PAPER"].pmax = 1, 1
cmd["PEN"].pmin, cmd["PEN"].pmax = 1, 1
cmd["PLOT"].pmin, cmd["PLOT"].pmax = 2, 2
cmd["PLOTR"].pmin, cmd["PLOTR"].pmax = 2, 2
cmd["PRINT"].pmin, cmd["PRINT"].pmax = 0, -1
cmd["RECT"].pmin, cmd["RECT"].pmax = 5, 5
cmd["SELECT"].pmin, cmd["SELECT"].pmax = 1, 1
cmd["CASE"].pmin, cmd["CASE"].pmax = 1, 1
cmd["SGN"].pmin, cmd["SGN"].pmax = 1, 1
cmd["SPRITEIMG"].pmin, cmd["SPRITEIMG"].pmax = 2, 2
cmd["SPRITEOFF"].pmin, cmd["SPRITEOFF"].pmax = 1, 1
cmd["SPRITEON"].pmin, cmd["SPRITEON"].pmax = 1, 1
cmd["SPRITEPOS"].pmin, cmd["SPRITEPOS"].pmax = 3, 3
cmd["SPRITESCALE"].pmin, cmd["SPRITESCALE"].pmax = 2, 2
cmd["SPRITETRANSP"].pmin, cmd["SPRITETRANSP"].pmax = 2, 2
cmd["UNTIL"].pmin, cmd["UNTIL"].pmax = 1, 1
cmd["VAL"].pmin, cmd["VAL"].pmax = 1, 1
cmd["WHILE"].pmin, cmd["WHILE"].pmax = 1, 1

-- définir le type de valeur du paramètre en entrée pour chaque instruction BASIC
cmd["ABS"].ptype = VAR_NUM
cmd["ASC"].ptype = VAR_STRING
cmd["ELSEIF"].ptype = VAR_CONDITION
cmd["FOR"].ptype = VAR_INTEGER
cmd["GOSUB"].ptype = VAR_LABEL
cmd["GOTO"].ptype = VAR_LABEL
cmd["IF"].ptype = VAR_CONDITION
cmd["PRINT"].ptype = VAR_POLY
cmd["SELECT"].ptype = VAR_VAR
cmd["CASE"].ptype = VAR_CONSTANT
cmd["SGN"].ptype = VAR_NUM
cmd["UNTIL"].ptype = VAR_CONDITION
cmd["VAL"].ptype = VAR_STRING
cmd["WHILE"].ptype = VAR_CONDITION

-- mots additionnels pour certaines commandes BASIC
cmd["FOR"].word2, cmd["FOR"].word3, cmd["FOR"].wmin, cmd["FOR"].wmax = "TO", "STEP", 2, 3
cmd["IF"].word2, cmd["IF"].wmin, cmd["IF"].wmax = "THEN", 2, 2

-- ===================================
-- = palette de 64 (16 x 4) couleurs =
-- ===================================
-- 0 à 15	-> Palette claire
-- 16 à 31	-> Palette medium
-- 32 à 47	-> Palette foncée
-- 48 à 63	-> Palette sombre

palette = {}
palette[0] = {8, 8, 8} -- noir
palette[1] = {255, 255, 255} -- blanc
palette[2] = {255, 0, 0} -- rouge
palette[3] = {255, 64, 0} -- rouge orangé
palette[4] = {255, 128, 0} -- orange
palette[5] = {255, 192, 0} -- jaune orangé
palette[6] = {255, 255, 0} -- jaune
palette[7] = {192, 192, 192} -- gris
palette[8] = {192, 255, 192} -- verdâtre
palette[9] = {0, 255, 0} -- vert
palette[10] = {0, 255, 255} -- bleu outremer
palette[11] = {0, 0, 255} -- bleu
palette[12] = {192, 192, 255} -- bleu ciel
palette[13] = {128, 0, 255} -- violet
palette[14] = {255, 0, 255} -- fushia
palette[15] = {255, 192, 192} -- chair

scnPal = {}
for x = 0, 15 do
	scnPal[x] = {}
	scnPal[x + 16] = {}
	scnPal[x + 32] = {}
	scnPal[x + 48] = {}
	
	for y = 0, 2 do
		scnPal[x][y] = palette[x][y + 1]
		scnPal[x + 16][y] = palette[x][y + 1]
		scnPal[x + 32][y] = palette[x][y + 1]
		scnPal[x + 48][y] = palette[x][y + 1]
	end
end

CR = 13 -- caractère de fin de ligne Carriage Return
LF = 10 -- caractère de fin de ligne Line Feed

-- importer les fichiers lua nécessaires
require("lexparse")
require("tools")
require("debugger")
require("base")
require("diskop")
require("input")
require("screen")
require("text")
require("init")
require("cmd")
require("generator")
require("player")

-- ==================
-- = codes d'erreur =
-- ==================
OK = 0 -- pas d'erreur

ERR_OVERFLOW = 1
ERR_OPERAND_MISSING = 2
ERR_TOO_MANY_OPERANDS = 3
ERR_TYPE_MISMATCH = 4
ERR_SYNTAX_ERROR = 5
ERR_DUPLICATE_LABEL = 6
ERR_UNDEFINED_LABEL = 7
ERR_UNKNOWN_COMMAND = 8
ERR_OUT_OF_MEMORY = 9
ERR_MEMORY_FULL = 10
ERR_DIVISION_BY_ZERO = 11
ERR_STACK_FULL = 12
ERR_UNEXPECTED_RETURN = 13
ERR_READ_ERROR = 14
ERR_WRITE_ERROR = 15
ERR_DISC_MISSING = 16
ERR_FILE_MISSING = 17

-- =======================
-- = constantes diverses =
-- =======================
EDIT_MODE = 1 -- mode d'édition du code source
RUN_MODE = 2 -- mode d'exécution du code source
READY_MODE = 3 -- mode d'exécution stoppé du code source
HELP_MODE = 4 -- mode d'affichage de l'aide
SPRITE_MODE = 5 -- mode d'édition de sprites
NOISE_MODE = 6 -- mode d'édition de bruitages
TRACKER_MODE = 7 -- mode d'édition de musiques
SPECIAL_MODE = 8 -- mode pour la gestion des erreurs

-- en mode édition, on peut activer le steps mode
-- qui permet le débogage ligne par ligne
stepsMode = false
execStep = false

IBF = 256 -- Nombre d'instructions exécutées chaque frame

SPRITE_WIDTH = 16
SPRITE_HEIGHT = 16
MAX_SPRITE_SIZE = SPRITE_WIDTH * SPRITE_HEIGHT
MAX_HARD_SPRITES = 32
MAX_SPRITES_IMAGES = 256 -- 8 banques de 32 images de sprites

SPRITE_LINE_WIDTH = 16
SPRITE_LINE_HEIGHT = 2

MAX_RAM = 65536 -- taille de la mémoire pour le code source (nombre de lignes de code de 0 à 65535)
MAX_VRAM = 65536 -- taille de la mémoire pour les variables (64k)
MAX_SPRAM = MAX_SPRITES_IMAGES * MAX_SPRITE_SIZE -- taille de la mémoire pour les 256 sprites
MAX_STACK = 65536 -- taille de chaque pile


SCN_SIZE_WIDTH = 320
SCN_SIZE_HEIGHT = 200
SCN_SIZE_INFOS_HEIGHT = 8

MAX_CLIPBOARD = SCN_SIZE_WIDTH * SCN_SIZE_HEIGHT

-- ===========================================================
-- = définir la RAM du code source, les lignes à interpréter =
-- ===========================================================
ram = {}
for i = 0, MAX_RAM - 1 do
	ram[i] = ""
end

ramLine = 0 -- offset de stockage de lignes de code en RAM

-- ============================================
-- = définir la RAM de stockage des variables =
-- ============================================
vram = {}

-- =======================================
-- = définir la pile pour les GOTO/GOSUB =
-- =======================================
stack = {}
for i = 0, MAX_STACK - 1 do
	stack[i] = 0
end

stackPointer = MAX_STACK

-- =======================================
-- = définir la pile pour les conditions =
-- =======================================
cstack = {}
for i = 0, MAX_STACK - 1 do
	cstack[i] = 0
end

cstackPointer = MAX_STACK

-- ====================================
-- = définir la pile pour les boucles =
-- ====================================
lstack = {}
for i = 0, MAX_STACK - 1 do
	lstack[i] = 0
end

lstackPointer = MAX_STACK

-- =====================================================
-- = définir la RAM de stockage des images des sprites =
-- =====================================================
spram = {}
for i = 0, MAX_SPRAM - 1 do
	spram[i] = 0
end

-- définir la taille par défaut des sprites
sprImgSize = {}
for i = 0, MAX_SPRITES_IMAGES - 1 do
	sprImgSize[i] = {w = SPRITE_WIDTH, h = SPRITE_HEIGHT}
end

-- sprite sélectionné par défaut
sprImgNumber = 0
sprImgPage = 0

-- ================================================
-- = définir les données des 256 hardware sprites =
-- ================================================
hardspr = {}
for i = 0, MAX_HARD_SPRITES - 1 do
	hardspr[i] = {x = 0.0, y = 0.0, img = 0, hotspot = 0, scale = 0, transp = 0, on = false}
end

-- =============================
-- = définir la vitesse du jeu =
-- =============================
gameVBL = DEFAULT_VBL -- coefficient pour ralentir le jeu
VBL = false

-- ==================================
-- = définir la Rom et la RAM ASCII =
-- ==================================
rom = {}
sym = {}
for i = 0, 255 do
	rom[i] = {}
	sym[i] = {}
	for x = 0, 7 do
		rom[i][x] = {}
		sym[i][x] = {}
		for y = 0, 7 do
			-- 0 pour un pixel vide, 1 pour un plein
			rom[i][x][y] = 0
			sym[i][x][y] = rom[i][x][y]
		end
	end
end

-- =============================
-- = définir l'écran graphique =
-- =============================
scnPixelSize = 3 -- taille d'un pixel à l'écran

-- écran de 320*2 par 200*2 = 640x400
-- avec le border, on peut prendre 800x600
realScnWidth = 800
realScnHeight = 600

-- mettre à jour l'écran en fonction de sa mémoire virtuelle
borderX = (realScnWidth - (scnPixelSize * SCN_SIZE_WIDTH)) / 2
borderY = (realScnHeight - (scnPixelSize * SCN_SIZE_HEIGHT)) / 2

-- mettre à jour la palette
CreatePalette()

-- curseur et curseur graphique
cursor = {1, 1}
safeCursor = {1, 1}
cursorVisible = false
pen = DEFAULT_PEN
paper = DEFAULT_PAPER
textTransparency = false
gcursor = {0, 0}
gpen = DEFAULT_PEN
border = 10

-- couleurs de dessin pour l'éditeur de sprites
drawingPen = 0
drawingPaper = 0

-- =============================================
-- = définition de quelques variables globales =
-- =============================================
kb_buffer = "" -- tampon clavier
dbg = nil -- message de débogage
err = nil -- sortie d'erreur
msg = nil -- sortie de message ou de question (err est prioritaire sur msg)
msgLine = nil -- sortie de numéro de ligne en steps mode

currentDrive = nil -- nom du projet en cours, pour sauvegarder le fichier
currentFolder = nil -- nom du dossier du projet en cours, pour sauvegarder le fichier
defaultFolder = nil -- répertoire par défaut de l'application

SEP = "/" -- séparateur de dossiers

helpPage = 0 -- numéro de page d'aide affichée

beepSound = nil -- id de chargement du son bip

-- variable globales pour la souris
mouseX = 0
mouseY = 0
memMouseDown = {false, false, false}
mouseDown = {false, false, false}
mouseClic = {false, false, false}
mouseRelease = {false, false, false}

editorOffsetX = 0 -- offset horizontal de l'éditeur de texte
editorOffsetY = 0 -- offset vertical de l'éditeur de texte
appState = EDIT_MODE -- mode en cours de l'application
specialAppState = false -- activer le mode spécial, pour la gestion des erreurs, des messages disque, etc

labels = {} -- liste de labels présents dans le script
labPC = {} -- liste des adresses mémoires de code source pointées par les labels
labCount = 0

ProgramCounter = 1

renderer = {}
renderer[0] = nil
renderer[1] = nil
renderer[2] = nil -- renderer pour les infos
renderer[3] = nil -- renderer pour les erreurs
renderer[4] = nil -- renderer pour le menu outils
currentRenderer = 0

clipboard = {}
for i = 0, MAX_CLIPBOARD - 1 do
	clipboard[i] = 0
end

-- audio et musique :
-- constantes
NOTEOFF = 100
DEFAULT_VOLUME = 16
MAX_PATTERNS = 64
MAX_MUSIC_LENGTH = 99

-- variables
BPM = 120
nextNotes = (60.0 / (4 * BPM))
countTime = nextNotes
notesPerPattern = 64
musicLength = 1
currentNotesLine = 0
currentPattern = 1
currentTrack = 1

-- instruments
instr = {}
for i = 1, 4 do
	instr[i] = {}
	for j = 1, 85 do
		instr[i][j] = nil
	end
end

-- arpèges
arpeggioType = {1, 1, 1, 1}
arpeggioCounter = {1, 1, 1, 1}
arpeggioSpeed = {8, 8, 8, 8}
	
nextArp = {}
for i = 1, 4 do
	nextArp[i] = nextNotes / arpeggioSpeed[i]
end

arpTimer = {0, 0, 0, 0}

pattern = {}
vol = {}
tVol = {}
lastNote = {}
arpLastNote = {}
for i = 1, 4 do
	pattern[i] = {}
	vol[i] = {}
	tVol[i] = 0.25
	lastNote[i] = 0
	arpLastNote[i] = lastNote[i]
	for j = 1, notesPerPattern do
		pattern[i][j] = {}
		vol[i][j] = {}
		for k = 1, MAX_PATTERNS do
			pattern[i][j][k] = 0
			vol[i][j][k] = DEFAULT_VOLUME
		end
	end
end

-- musique
mus = {}
for i = 1, MAX_MUSIC_LENGTH do
	mus[i] = 1
end

currentSoundsType = {3, 3, 3 ,3}
soundTypes = { "SIN", "TRI", "SQU", "SAW" }

musicPlaying = false

-- ==============================================================================================================================
-- = fonctions principales =
-- =========================
function love.load()
	-- créer la fenêtre graphique
	love.window.setMode(realScnWidth, realScnHeight, {resizable=false, vsync=true, fullscreen=false})
	love.window.setTitle("LoveRetroBasic ")
	
	-- récupérer la vraie taille de l'écran (ou de la fenêtre) et ajuster
	realScnWidth = love.graphics.getWidth()
	realScnHeight = love.graphics.getHeight()
	local w = SCN_SIZE_WIDTH
	local h = SCN_SIZE_HEIGHT
	while w * scnPixelSize < realScnWidth - (20 * scnPixelSize) and h * scnPixelSize < realScnHeight - (20 * scnPixelSize) do
		scnPixelSize = scnPixelSize + 1
	end
	while w * scnPixelSize > realScnWidth - (20 * scnPixelSize) or h * scnPixelSize > realScnHeight - (20 * scnPixelSize) do
		scnPixelSize = scnPixelSize - 1
	end
	borderX = (realScnWidth - (scnPixelSize * SCN_SIZE_WIDTH)) / 2
	borderY = (realScnHeight - (scnPixelSize * SCN_SIZE_HEIGHT)) / 2		
	
	-- initialiser le clavier
	love.keyboard.setKeyRepeat(true)

	-- charger le son de bip touches
	beepSound = love.audio.newSource("audio/beep.ogg", "static")
	
	-- créer les renderers
	renderer[0] = love.graphics.newCanvas(SCN_SIZE_WIDTH, SCN_SIZE_HEIGHT)
	renderer[1] = love.graphics.newCanvas(SCN_SIZE_WIDTH, SCN_SIZE_HEIGHT)
	renderer[2] = love.graphics.newCanvas(SCN_SIZE_WIDTH, SCN_SIZE_INFOS_HEIGHT)
	renderer[3] = love.graphics.newCanvas(SCN_SIZE_WIDTH, SCN_SIZE_INFOS_HEIGHT)
	renderer[4] = love.graphics.newCanvas(SCN_SIZE_WIDTH, SCN_SIZE_INFOS_HEIGHT)

	-- désactiver le flou sur les renderers
	renderer[0]:setFilter('nearest', 'nearest')
	renderer[1]:setFilter('nearest', 'nearest')
	renderer[2]:setFilter('nearest', 'nearest')
	renderer[3]:setFilter('nearest', 'nearest')
	renderer[4]:setFilter('nearest', 'nearest')
	
	-- dessiner sans flou
	love.graphics.setLineStyle("rough")
	
	-- initialiser tout
	local e, l = InitSymbols()
	if e ~= OK then
		err = GetError(e) .. " line " .. tostring(l)
	else
		Reset()
	end

	defaultFolder = love.filesystem.getSaveDirectory()
	defaultFolder = string.gsub(defaultFolder, "\\", "/") .. "/"
	
	-- créer le Disk0 s'il n'existe pas
	currentFolder = "Disk0"
	CreateDisk(currentFolder)
	currentFolder = currentFolder .. SEP
	
	-- choisir le Disk0 comme disque par défaut
	SelectDisk(defaultFolder .. currentFolder)
		
	-- recherche d'un lecteur virtuel dans à côté du fichier .love
	currentDrive = love.filesystem.getWorkingDirectory()
	if love.system.getOS() == "Windows" then
		currentDrive = string.gsub(currentDrive, "\\", "/")
	end
	currentDrive = currentDrive .. "/RBDisks/"
	if os.rename(currentDrive, currentDrive) then
		-- répertoire trouvé
		-- os.execute("copy ...") ou os.execute("cp ...")
	else
		-- répertoire non trouvé
		currentDrive = ""
	end
end

function love.keyreleased(key, scancode, isrepeat)
	-- sortie du mode spécial en cas d'erreur
	if specialAppState and err ~= nil then
		if key == "escape" then
			err = nil
			--
			return
		end
	end

	-- mode d’exécution de programme en cours ou terminée
	if appState == RUN_MODE or appState == READY_MODE then
		if key == "escape" then
			EndProgram()
			--
			return
		end
	end

	-- mode d'affichage de l'aide
	if appState == HELP_MODE then
		if helpPage == 0 then
			-- montrer les mots clés du basic
			if key == "1" then
				helpPage = 1
				HelpManager()
				--
				return
			-- voir les raccourcis claviers de l'éditeur
			elseif key == "2" then
				helpPage = 2
				HelpManager()
				--
				return
			-- revenir à l'éditeur
			elseif key == "escape" then
				ShowCursor(false)
				ClearScreen()
				RedrawEditor()
				cursor[1] = safeCursor[1]
				cursor[2] = safeCursor[2]
				-- afficher le curseur
				ShowCursor(true)
				appState = EDIT_MODE
				--
				return
			end
		elseif helpPage == 1 or helpPage == 2 then
			-- revenir à l'aide principale
			if key == "escape" then
				helpPage = 0
				HelpManager()
				--
				return
			end
		end
	end
	
	-- gérer les raccourcis clavier de l'éditeur de sprites
	if appState == SPRITE_MODE then
		if key == "escape" then
			SetPenColor(DEFAULT_PEN)
			SetPaperColor(DEFAULT_PAPER)
			SetBorderColor(DEFAULT_PAPER)
			SetGraphicPenColor(DEFAULT_PEN)
			ClearScreen()
			RedrawEditor()
			cursor[1] = safeCursor[1]
			cursor[2] = safeCursor[2]
			ShowCursor(true)
			appState = EDIT_MODE
			--
			return
		elseif key == "s" then
			-- sauvegarder tous les sprites existants
			SaveSprites(defaultFolder .. currentFolder .. "sprites.spr")
			--
			return
		elseif key == "c" then
			-- copier le sprite courant
			clipboard[0] = sprImgSize[sprImgNumber].w
			clipboard[1] = sprImgSize[sprImgNumber].h
			for i = 0, (sprImgSize[sprImgNumber].w * sprImgSize[sprImgNumber].h) - 1 do
				clipboard [i + 2] = spram[(sprImgNumber * MAX_SPRITE_SIZE) + i]
			end
			--
			return
		elseif key == "p" then
			local w = clipboard[0]
			local h = clipboard[1]
			-- récupérer le sprite dans le clipboard
			-- pour le coller
			sprImgSize[sprImgNumber].w = w
			sprImgSize[sprImgNumber].h = h
			for i = 0, MAX_SPRITE_SIZE - 1 do
				spram[(sprImgNumber * MAX_SPRITE_SIZE) + i] = 0
			end
			for i = 0, (w * h) - 1 do
				spram[(sprImgNumber * MAX_SPRITE_SIZE) + i] = clipboard[i + 2]
			end
			-- afficher le sprite si possible
			RedrawEditedSprite()
			RedrawCurrentSprite()
			--
			return
		end
	end	
end

function love.keypressed(key, scancode, isrepeat)
	-- tous modes compris
	if key == "f12" then
		QuitProgram()
	end
	
	-- mode d'édition de programme
	if appState == EDIT_MODE then
		if key == "up" then
			MoveCursorUp()
		elseif key == "down" then
			MoveCursorDown()
		elseif key == "pageup" then
			for i = 1, 25 do
				MoveCursorUp()
			end
		elseif key == "pagedown" then
			for i = 1, 25 do
				MoveCursorDown()
			end
		elseif key == "backspace" then
			ShowCursor(false)
			-- si le curseur est en début de ligne
			if cursor[1] == 1 then
				-- s'il y a d'autres ligne au dessus
				if ramLine > 1 then
					-- supprimer la ligne de code vide
					for i = ramLine, MAX_RAM - 2 do
						ram[i] = ram[i + 1]
					end
					ram[MAX_RAM - 1] = ""
					-- gérer le scrolling horizontal et redessiner l'écran
					SetHScroll()
					-- passer à la ligne précédente
					ramLine = ramLine - 1
					--
					cursor[1] = #ram[ramLine] + 1
					cursor[2] = cursor[2] - 1
					-- si le curseur demande de faire un scrolling, alors...
					if cursor[2] < 1 then
						-- afficher la ligne du dessus
						ScrollScreenDown()
						-- on le prend en compte dans l'éditeur
						if editorOffsetY > 0 then
							editorOffsetY = editorOffsetY - 1
						end
						--
						cursor[1] = 1
						cursor[2] = cursor[2] + 1
						for i = 1, #ram[ramLine] do
							PrintChar(Asc(string.sub(ram[ramLine], i, i)), PRINT_NOT_CLIPPED)
						end
						-- gérer le scrolling horizontal et redessiner l'écran
						SetHScroll()
					end
				else
					Beep()
				end
			elseif editorOffsetX > 0 then
				-- supprimer le caractère précédent
				ram[ramLine] = string.sub(ram[ramLine], 1, -2)
				cursor[1] = #ram[ramLine] + 1
				PrintChar(32, PRINT_NOT_CLIPPED)
				cursor[1] = #ram[ramLine] + 1
				editorOffsetX = editorOffsetX - 1
				-- gérer le scrolling horizontal et redessiner l'écran
				SetHScroll()
			else
				-- supprimer le caractère précédent
				ram[ramLine] = string.sub(ram[ramLine], 1, -2)
				cursor[1] = #ram[ramLine] + 1
				PrintChar(32, PRINT_NOT_CLIPPED)
				cursor[1] = #ram[ramLine] + 1
			end

			ShowCursor(true)
		elseif key == "return" then
			ShowCursor(false)
			-- on passe à la ligne suivante
			ramLine = ramLine + 1
			-- si la ligne suivante est vide, alors...
			if ram[ramLine] == "" then
				-- on se positionne en début de ligne
				cursor[1] = 1
				cursor[2] = cursor[2] + 1
				-- si le curseur doit faire scroller l'écran
				if cursor[2] > 25 then
					-- on scrolle l'écran
					ScrollScreenUp()
					-- on le prend en compte dans l'éditeur
					editorOffsetY = editorOffsetY + 1
					-- on repositionne le curseur virtuellement en début de ligne
					cursor[1] = 1
					cursor[2] = cursor[2] - 1
					-- s'il y a du texte à afficher en bas, alors...
					for i = 1, #ram[ramLine] do
						PrintChar(Asc(string.sub(ram[ramLine], i, i)), PRINT_NOT_CLIPPED)
					end
					if ram[ramLine] == Chr(LF) then
						cursor[1] = 1
					else
						cursor[1] = #ram[ramLine] + 1
					end
					-- gérer le scrolling horizontal
					SetHScroll()
				end
			-- si la ligne contient du code, on affiche cette ligne et l'on reste en fin de ligne
			else
				cursor[1] = 1
				cursor[2] = cursor[2] + 1
				for i = 1, #ram[ramLine] do
					PrintChar(Asc(string.sub(ram[ramLine], i, i)), PRINT_NOT_CLIPPED)
				end
				if ram[ramLine] == Chr(LF) then
					cursor[1] = 1
				end
				-- gérer le scrolling horizontal
				SetHScroll()
			end
			-- décaler les lignes de code si possible
			if ram[MAX_RAM - 1] == "" then
				for i = MAX_RAM - 1, ramLine + 1, -1 do
					ram[i] = ram[i - 1]
				end
				ram[ramLine] = ""
				-- gérer le scrolling horizontal
				SetHScroll()
			end
			--
			cursor[1] = 1
			ShowCursor(true)
		end
	end

	-- ajouter certaines touches au buffer clavier
	if appState == RUN_MODE then
		if key == "return" then
			kb_buffer = kb_buffer .. Chr(13)
		elseif key == "backspace" then
			kb_buffer = kb_buffer .. Chr(8)
		end
	end
end

function love.textinput(t)
	if appState == EDIT_MODE or appState == RUN_MODE then
		local a = Asc(string.sub(t, -1))
		
		if a < 128 then
			-- récupérer les caractères pressés
			if #kb_buffer < 255 then
				kb_buffer = kb_buffer .. t
			end
		end
	end
end

function love.update(dt)
	-- mettre à jour la position de la souris
	mouseX = GetMousePositionX()
	mouseY = GetMousePositionY()

	-- mettre à jour les clics souris
	for b = 1, 3 do
		memMouseDown[b] = mouseDown[b]
		mouseDown[b] = love.mouse.isDown(b)
		
		if mouseDown[b] and not memMouseDown[b] then
			mouseClic[b] = true
			mouseRelease[b] = false
		elseif not mouseDown[b] and memMouseDown[b] then
			mouseClic[b] = false
			mouseRelease[b] = true
		else
			mouseClic[b] = false
			mouseRelease[b] = false
		end
	end
	
	-- mise à jour du lecteur de musique
	if appState == RUN_MODE or appState == READY_MODE then
		UpdateMusic(dt)
	end

	-- en mode édition...
	if appState == EDIT_MODE then
		local newTextEntered = false
		
		if kb_buffer ~= nil and kb_buffer ~= "" then
			-- récupérer les dernier textes saisis
			AppendTextToRam(kb_buffer)
			newTextEntered = true
		end
		
		-- récupérer les clics sur le menu outils
		if GetMouseClicLeft() then
			local x = math.floor(mouseX / 8)
			local y = love.mouse.getY()
						
			if y >= borderY - (16 * scnPixelSize) and y < borderY - (8 * scnPixelSize) then
				if x == 0 then
					-- remise à zéro d'un éventuel message texte
					msg = nil
					SaveProgram()
					safeCursor[1] = cursor[1]
					safeCursor[2] = cursor[2]
					for i = 0, MAX_CLIPBOARD - 1 do
						clipboard[i] = 0
					end
					appState = SPRITE_MODE
					SpriteEditor()
					--
					return
				elseif x == 2 then
					-- remise à zéro d'un éventuel message texte
					msg = nil
					--
					SaveProgram()
					safeCursor[1] = cursor[1]
					safeCursor[2] = cursor[2]
					appState = LEVEL_MODE
					LevelEditor()
					--
					return
				elseif x == 4 then
					-- remise à zéro d'un éventuel message texte
					msg = nil
					--
					SaveProgram()
					safeCursor[1] = cursor[1]
					safeCursor[2] = cursor[2]
					appState = NOISE_MODE
					NoiseEditor()
					--
					return
				elseif x == 6 then
					-- remise à zéro d'un éventuel message texte
					msg = nil
					--
					SaveProgram()
					safeCursor[1] = cursor[1]
					safeCursor[2] = cursor[2]
					appState = TRACKER_MODE
					Tracker()
					--
					return
				elseif x == 8 then
					-- remise à zéro d'un éventuel message texte
					msg = nil
					--
					SaveProgram()
					safeCursor[1] = cursor[1]
					safeCursor[2] = cursor[2]
					appState = HELP_MODE
					HelpManager()
					--
					return
				elseif x >= 10 and x <= 12 then
					-- remise à zéro d'un éventuel message texte
					msg = nil
					--
					stepsMode = false
					SaveProgram()
					err = GetError(ScanLabels())
					if err == "Ok" then
						err = nil
						ClearScreen()
						safeCursor[1] = cursor[1]
						safeCursor[2] = cursor[2]
						Locate(1, 1)
						kb_buffer = ""
						for i = 0, MAX_HARD_SPRITES - 1 do
							hardspr[i].x = 0.0
							hardspr[i].y = 0.0
							hardspr[i].img = 0
							hardspr[i].hotspot = 0
							hardspr[i].scale = 0
						end
						execStep = true
						appState = RUN_MODE -- exécuter le code source basic
					end
					--
					return
				elseif x >= 14 and x <= 18 then
					-- remise à zéro d'un éventuel message texte
					msg = nil
					--
					stepsMode = true
					SaveProgram()
					err = GetError(ScanLabels())
					if err == "Ok" then
						err = nil
						ClearScreen()
						safeCursor[1] = cursor[1]
						safeCursor[2] = cursor[2]
						Locate(1, 1)
						kb_buffer = ""
						for i = 0, MAX_HARD_SPRITES - 1 do
							hardspr[i].x = 0.0
							hardspr[i].y = 0.0
							hardspr[i].img = 0
							hardspr[i].hotspot = 0
							hardspr[i].scale = 0
						end
						execStep = true
						appState = RUN_MODE -- exécuter le code source basic en mode 'debug'
					end
					--
					return
				elseif x >= 20 and x <= 23 then
					-- remise à zéro d'un éventuel message texte
					msg = nil
					--
					SaveProgram()
					--
					return
				elseif x >= 25 and x <= 28 then
					-- remise à zéro d'un éventuel message texte
					msg = nil
					--
					ShowCursor(false)
					ClearScreen()
					SelectDisk(defaultFolder .. currentFolder)
					--
					return
				elseif x == 39 then
					--
					SaveProgram()
					--
					QuitProgram()					
					--
					return					
				end
			end
		end
		
		if newTextEntered then
			-- colorier la ligne courante de code source
			SetEditorTextColor(ramLine)
		end
	end
	
	if appState == RUN_MODE then
		-- exécuter les instructions de la frame
		local i2 = IBF
		if stepsMode then i2 = 1 end
		for i = 1, i2 do
			-- exécuter le commandes
			if ProgramCounter < MAX_RAM and (not stepsMode or (stepsMode and execStep)) then
				execStep = false
				local s = ram[ProgramCounter]
				if s ~= nil and s ~= Chr(LF) then
					-- débogage en 'step mode'
					if stepsMode then
						msg = s
						msgLine = tostring(ProgramCounter)
					end
					-- suppression des commentaires
					s, e = RemoveComments(s)
					-- exécution de la commande
					if e == OK then
						err, value = GetError(Exec(Parser(Lexer(RemoveLabels(s)))), ProgramCounter)
					else
						err = GetError(e, ProgramCounter)
					end
					-- stopper en cas d'erreur
					if err == "Ok" then
						err = nil
					else
						StopProgram()
						break
					end
				end
			elseif not stepsMode then
				StopProgram()
				break
			end
			if appState == RUN_MODE then
				-- débogage
				if stepsMode then
					if GetMouseClicLeft() then
						-- passer à la ligne de code suivante
						ProgramCounter = ProgramCounter + 1
						execStep = true
					end
				else
					-- passer à la ligne de code suivante
					ProgramCounter = ProgramCounter + 1
				end
			else
				break
			end
			-- waitVBL
			if VBL then
				-- sortir de la boucle d'instructions
				break
			end
		end
	end
	
	--
	if appState == SPRITE_MODE then
		local col = nil
		local mx = -1
		local my = -1
		
		local mpx = mouseX
		local mpy = mouseY

		if GetMouseDownLeft() then
		
			mx = math.floor((mpx - 128) / 8)
			my = math.floor(mpy / 8)

			local x = mx
			local y = my
			
			col = drawingPen
			
			if x < 0 then
				x = x + 16
				if y >= 9 and y <= 16 then
					if x >= 0 and x <= 7 then
						y = y - 9
						drawingPen = x + (y * 8)
						
						SetGraphicPenColor(drawingPen)
						DrawRectangle(72, 72, 16, 16, 1)
					end
				end
			end
			
			if y == 20 then
				if x >= 0 and x <= 1 then
					-- effacer la zone de dessin de sprite
					SetGraphicPenColor(0)
					DrawRectangle(128, 0, SPRITE_WIDTH * 8, SPRITE_HEIGHT * 8, 1)
					-- passer au sprite précédent
					if sprImgNumber > 0 then sprImgNumber = sprImgNumber - 1 end
					sprImgPage = math.floor(sprImgNumber / (SPRITE_LINE_WIDTH * SPRITE_LINE_HEIGHT))
					-- afficher le sprite si possible
					RedrawEditedSprite()
					RedrawSpritesLine()
					RedrawCurrentSprite()
					-- mettre à jour le numéro de sprite
					Locate(1, 4)
					SetPenColor(1)
					PrintString("Sprite:" .. tostring(sprImgNumber) .. "   ")
					love.timer.sleep(1/5)
				elseif x >= 3 and x <= 4 then
					-- effacer la zone de dessin de sprite
					SetGraphicPenColor(0)
					DrawRectangle(128, 0, SPRITE_WIDTH * 8, SPRITE_HEIGHT * 8, 1)
					-- passer au sprite suivant
					if sprImgNumber < MAX_SPRITES_IMAGES - 1 then sprImgNumber = sprImgNumber + 1 end
					sprImgPage = math.floor(sprImgNumber / (SPRITE_LINE_WIDTH * SPRITE_LINE_HEIGHT))
					-- afficher le sprite si possible
					RedrawEditedSprite()
					RedrawSpritesLine()
					RedrawCurrentSprite()
					-- mettre à jour le numéro de sprite
					Locate(1, 4)
					SetPenColor(1)
					PrintString("Sprite:" .. tostring(sprImgNumber) .. "   ")					
					love.timer.sleep(1/5)
				elseif x >= 6 and x <= 7 then
					-- effacer la zone de dessin de sprite
					SetGraphicPenColor(0)
					DrawRectangle(128, 0, SPRITE_WIDTH * 8, SPRITE_HEIGHT * 8, 1)
					-- passer au sprite précédent
					if sprImgPage > 0 then sprImgPage = sprImgPage - 1 end
					sprImgNumber = (sprImgNumber % (SPRITE_LINE_WIDTH * SPRITE_LINE_HEIGHT)) + (sprImgPage * (SPRITE_LINE_WIDTH * SPRITE_LINE_HEIGHT))
					-- afficher le sprite si possible
					RedrawEditedSprite()
					RedrawSpritesLine()
					RedrawCurrentSprite()
					-- mettre à jour le numéro de sprite
					Locate(1, 4)
					SetPenColor(1)
					PrintStringN("Sprite:" .. tostring(sprImgNumber) .. "   ")					
					PrintString("Page  :" .. tostring(sprImgPage) .. "   ")					
					love.timer.sleep(1/5)
				elseif x >= 9 and x <= 10 then
					-- effacer la zone de dessin de sprite
					SetGraphicPenColor(0)
					DrawRectangle(128, 0, SPRITE_WIDTH * 8, SPRITE_HEIGHT * 8, 1)
					-- passer au sprite suivant
					if sprImgPage < (MAX_SPRITES_IMAGES / (SPRITE_LINE_WIDTH * SPRITE_LINE_HEIGHT)) - 1 then sprImgPage = sprImgPage + 1 end
					sprImgNumber = (sprImgNumber % (SPRITE_LINE_WIDTH * SPRITE_LINE_HEIGHT)) + (sprImgPage * (SPRITE_LINE_WIDTH * SPRITE_LINE_HEIGHT))
					-- afficher le sprite si possible
					RedrawEditedSprite()
					RedrawSpritesLine()
					RedrawCurrentSprite()
					-- mettre à jour le numéro de sprite
					Locate(1, 4)
					SetPenColor(1)
					PrintStringN("Sprite:" .. tostring(sprImgNumber) .. "   ")					
					PrintString("Page  :" .. tostring(sprImgPage) .. "   ")					
					love.timer.sleep(1/5)
				end
			elseif y > 20 then
				if mpx < SPRITE_LINE_WIDTH * SPRITE_WIDTH then
					mx = math.floor(mpx / SPRITE_WIDTH)
					my = math.floor((mpy - (200 - (SPRITE_HEIGHT * SPRITE_LINE_HEIGHT))) / SPRITE_HEIGHT)
					sprImgNumber = (sprImgPage * (SPRITE_LINE_WIDTH * SPRITE_LINE_HEIGHT)) + mx + (my * SPRITE_LINE_WIDTH)
					Locate(1, 4)
					SetPenColor(1)
					PrintStringN("Sprite:" .. tostring(sprImgNumber) .. "   ")					
					PrintString("Page  :" .. tostring(sprImgPage) .. "   ")					
					RedrawEditedSprite()
					RedrawSpritesLine()
					RedrawCurrentSprite()
					col = nil
				end
			end
		elseif GetMouseDownRight() then
			mx = math.floor(((mouseX - 128) / 8))
			my = math.floor((mouseY / 8))

			local x = mx
			local y = my
			
			col = drawingPaper
			
			if x < 0 then
				x = x + 16
				if y >= 9 and y <= 16 then
					y = y - 9
					drawingPaper = x + (y * 8)
	
					SetGraphicPenColor(drawingPaper)
					DrawRectangle(72, 96, 16, 16, 1)
				end
			end
		end
		
		-- dessiner dans le sprite
		if col ~= nil then
			if mx >= 0 and mx < SPRITE_WIDTH then
				if my >= 0 and my < SPRITE_HEIGHT then
					SetGraphicPenColor(col)
					DrawRectangle(128 + (mx * 8), (my * 8), 8, 8, 1)
					spram[(sprImgNumber * MAX_SPRITE_SIZE) + mx + (my * SPRITE_WIDTH)] = col
					RedrawCurrentSprite()
				end
			end
		end
	end
	
	if appState == EDIT_MODE then
		ClearKeyboardBuffer()
	end
end

function love.draw()
	-- ralentir le jeu
	if appState == RUN_MODE then
		if VBL then
			for i = 1, gameVBL do
				love.timer.sleep(1/1000)
			end
			VBL = false
		end
	end

	-- récupérer les coordonnées souris pour les afficher
	local mx = mouseX
	local my = mouseY

	-- rétablir le canvas par défaut
	love.graphics.setCanvas()
	
	-- effacer l'écran avec la couleur du border
	love.graphics.clear(scnPal[border][0] / 255.0, scnPal[border][1] / 255.0, scnPal[border][2] / 255.0, 1.0, false, false)

	-- capturer l'écran
	love.graphics.setCanvas(renderer[(currentRenderer + 1) % 2])
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(renderer[currentRenderer], 0, 0)
	love.graphics.setCanvas()

	-- dessiner les sprites hardware
	if appState == RUN_MODE or appState == READY_MODE then
		SetCanvas(true)
		for i = 0, MAX_HARD_SPRITES - 1 do
			DrawSprite(i)
		end
		SetCanvas(false)
	end

	-- changer la couleur du stylo
	love.graphics.setColor(1, 1, 1, 1)

	-- afficher le renderer
	love.graphics.draw(renderer[currentRenderer], borderX, borderY, 0, scnPixelSize, scnPixelSize, 0, 0, 0, 0)
		
	-- restaurer l'écran capturé
	love.graphics.setCanvas(renderer[currentRenderer])
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(renderer[(currentRenderer + 1) % 2], 0, 0)
	love.graphics.setCanvas()

	-- changer la couleur du stylo
	love.graphics.setColor(1, 1, 0, 1)

	-- effacer les renderer d'infos et d'erreur
	PrintInfosString("                                        ", 2, "black")
	PrintInfosString("                                        ", 3, "black")
	PrintInfosString("                                        ", 4, "black")

	-- montrer le curseur en mode édition de texte
	if appState == EDIT_MODE then
		-- afficher la ligne et colonne courante, ainsi que le nombre de lignes saisies
		PrintInfosString("Ln " .. tostring(ramLine) .. " Col " .. tostring(cursor[1] + editorOffsetX), 2, "black")
	end

	-- afficher la position de la souris
	if appState == SPRITE_MODE then
		local x = math.floor((mx - 128) / 8)
		local y = math.floor(my / 8)
		
		if x >= 0 and x < sprImgSize[sprImgNumber].w and y >= 0 and y < sprImgSize[sprImgNumber].h then
			local st = "x,y: " .. tostring(x) .. "," .. tostring(y)
			PrintInfosString(st, 2, "black")
		end
	elseif appState == RUN_MODE and stepsMode and msgLine ~= nil then
		PrintInfosString("Line " .. msgLine .. " :", 2, "black")
	end

	-- afficher les erreurs
	if err == nil and msg ~= nil then
		PrintInfosString(msg, 3, "blue")
		specialAppState = true
	elseif err ~= nil then
		PrintInfosString(err, 3, "red")
		specialAppState = true
	end

	-- afficher le renderer d'infos en mode édition de texte
	if appState == EDIT_MODE or (appState == RUN_MODE and stepsMode) or appState == SPRITE_MODE or appState == NOISE_MODE or appState == TRACKER_MODE then
		love.graphics.draw(renderer[2], borderX, borderY + ((SCN_SIZE_HEIGHT + 8) * scnPixelSize), 0, scnPixelSize, scnPixelSize, 0, 0, 0, 0)
	end

	-- afficher le renderer de message d'erreur
	if appState == EDIT_MODE or appState == READY_MODE or (appState == RUN_MODE and stepsMode) then
		love.graphics.draw(renderer[3], borderX, borderY + ((SCN_SIZE_HEIGHT + 16) * scnPixelSize), 0, scnPixelSize, scnPixelSize, 0, 0, 0, 0)
	end
	
	-- afficher le renderer de menu outils
	if appState == EDIT_MODE then
		PrintInfosString(Chr(1) .. " " ..Chr(2) .. " " ..Chr(3) .. " " ..Chr(4) .. " ? RUN DEBUG SAVE LOAD          X", 4, "blue")
		love.graphics.draw(renderer[4], borderX, borderY - (16 * scnPixelSize), 0, scnPixelSize, scnPixelSize, 0, 0, 0, 0)
	end

	-- afficher un message de débogage
	if dbg ~= nil then
		love.window.showMessageBox("Debug", dbg, "info", true)
		print("Debug: " .. dbg)
		dbg = nil
	end	
end

-- ==============================================================================================================================
