-- ==============================================
-- LoveRetroBasic, par retro-bruno, (c) 2021-2022
-- ==============================================

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
DEFAULT_LABELS_PEN = 34
DEFAULT_COMMENTS_PEN = 33
DEFAULT_INSTRUCTIONS_PEN = 4
DEFAULT_PAPER = 35
EDITOR_PEN = 1
EDITOR_PAPER = 35
EDITOR_BORDER = 35
EDITOR_MENU = 6
EDITOR_UI = 4

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
			"GETBORDER", "GETLOCX", "GETLOCY", "GETPAPER", "GETPEN", "GETGRAPHPEN", "GOSUB", "GOTO", "GRAPHPEN", "GRAPHPRINT",
			"HEX$", "HOTSPOT",
			"IF", "INKEY$", "INPUT",
			"LINE", "LOCATE",
			"MODE", "MOVE", "MOVER", "MUSIC",
			"NEXT",
			"OVAL",
			"PAPER", "PEN", "PLOT", "PLOTR", "PRINT",
			"RECT", "REPEAT", "RETURN",
			"SELECT", "SGN", "SPRITEIMG", "SPRITEOFF", "SPRITEON", "SPRITEPOS", "SPRITESCALE", "SPRITETRANSP", "STOPMUSIC","STR$",
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
cmd["STR$"].ret = VAR_STRING
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
cmd["GRAPHPRINT"].pmin, cmd["GRAPHPRINT"].pmax = 0, -1
cmd["HEX$"].pmin, cmd["HEX$"].pmax = 1, 1
cmd["HOTSPOT"].pmin, cmd["HOTSPOT"].pmax = 2, 2
cmd["IF"].pmin, cmd["IF"].pmax = 1, 1
cmd["LINE"].pmin, cmd["LINE"].pmax = 4, 4
cmd["LOCATE"].pmin, cmd["LOCATE"].pmax = 2, 2
cmd["MODE"].pmin, cmd["MODE"].pmax = 1, 1
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
cmd["STR$"].pmin, cmd["STR$"].pmax = 1, 1
cmd["UNTIL"].pmin, cmd["UNTIL"].pmax = 1, 1
cmd["VAL"].pmin, cmd["VAL"].pmax = 1, 1
cmd["WHILE"].pmin, cmd["WHILE"].pmax = 1, 1

-- définir le type de valeur du paramètre en entrée pour chaque instruction BASIC
cmd["ABS"].ptype = VAR_NUM
cmd["ASC"].ptype = VAR_STRING
cmd["CHR$"].ptype = VAR_NUM
cmd["ELSEIF"].ptype = VAR_CONDITION
cmd["FOR"].ptype = VAR_INTEGER
cmd["GOSUB"].ptype = VAR_LABEL
cmd["GOTO"].ptype = VAR_LABEL
cmd["GRAPHPRINT"].ptype = VAR_POLY
cmd["IF"].ptype = VAR_CONDITION
cmd["MODE"].ptype = VAR_INTEGER
cmd["PRINT"].ptype = VAR_POLY
cmd["SELECT"].ptype = VAR_VAR
cmd["CASE"].ptype = VAR_CONSTANT
cmd["SGN"].ptype = VAR_NUM
cmd["UNTIL"].ptype = VAR_CONDITION
cmd["STR$"].ptype = VAR_NUM
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
palette[0] = {0, 0, 0} -- noir
palette[1] = {255, 255, 255} -- blanc
palette[2] = {255, 0, 0} -- rouge
palette[3] = {255, 64, 0} -- rouge orangé
palette[4] = {255, 128, 0} -- orange
palette[5] = {255, 192, 0} -- jaune orangé
palette[6] = {255, 255, 0} -- jaune
palette[7] = {128, 128, 192} -- gris bleuté
palette[8] = {192, 255, 192} -- verdâtre
palette[9] = {0, 255, 0} -- vert
palette[10] = {0, 255, 255} -- bleu outremer
palette[11] = {0, 0, 255} -- bleu
palette[12] = {192, 192, 255} -- bleu ciel
palette[13] = {128, 0, 255} -- violet
palette[14] = {255, 0, 255} -- fushia
palette[15] = {255, 192, 192} -- chair

-- création des couleurs de base
scnPal = {}
for x = 0, 7 do
	scnPal[x] = {}
	scnPal[x + 8] = {}
	scnPal[x + 16] = {}
	scnPal[x + 24] = {}
	
	scnPal[x + 32] = {}
	scnPal[x + 40] = {}
	scnPal[x + 48] = {}
	scnPal[x + 56] = {}

	for y = 0, 2 do
		scnPal[x][y] = palette[x][y + 1]
		scnPal[x + 8][y] = palette[x][y + 1]
		scnPal[x + 16][y] = palette[x][y + 1]
		scnPal[x + 24][y] = palette[x][y + 1]
		
		scnPal[x + 32][y] = palette[x + 8][y + 1]
		scnPal[x + 40][y] = palette[x + 8][y + 1]
		scnPal[x + 48][y] = palette[x + 8][y + 1]
		scnPal[x + 56][y] = palette[x + 8][y + 1]
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
MAX_HARD_SPRITES = 32 -- 32 images de sprites par page
MAX_SPRITES_IMAGES = 256 -- 8 pages

SPRITE_LINE_WIDTH = 16
SPRITE_LINE_HEIGHT = 2

MAX_RAM = 65536 -- taille de la mémoire pour le code source (nombre de lignes de code de 0 à 65535)
MAX_VRAM = 65536 -- taille de la mémoire pour les variables (64k)
MAX_SPRAM = MAX_SPRITES_IMAGES * MAX_SPRITE_SIZE -- taille de la mémoire pour les 256 sprites
MAX_STACK = 65536 -- taille de chaque pile


MAX_SCN_WIDTH = 640
MAX_SCN_HEIGHT = 00
SCN_SIZE_INFOS_HEIGHT = 8

MAX_CLIPBOARD = MAX_SCN_WIDTH * MAX_SCN_HEIGHT

DEFAULT_MODE = 1

-- ================================
-- = définir les modes graphiques =
-- ================================
gmode = {}
gmode[0] = {160, 200, 4, 2}
gmode[1] = {320, 200, 2, 2}
gmode[2] = {640, 200, 1, 2}

currentMode = DEFAULT_MODE

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
-- écran de 320*2 par 200*2 = 640x400
-- avec le border, on peut prendre 800x600
realScnWidth = 800
realScnHeight = 600

-- mettre à jour l'écran en fonction de sa mémoire virtuelle
borderX = (realScnWidth - (gmode[currentMode][3] * gmode[currentMode][1])) / 2
borderY = (realScnHeight - (gmode[currentMode][4] * gmode[currentMode][2])) / 2

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

-- boutons du tracker
BTN_UP = 1
BTN_DOWN = 2
BTN_MENU_STOP = 3
BTN_MENU_EDIT = 4
BTN_MENU_PLAY = 5
BTN_OCTAVE_UP = 6
BTN_OCTAVE_DOWN = 7
BTN_SND_SHAPE_1 = 8
BTN_SND_SHAPE_2 = 9
BTN_SND_SHAPE_3 = 10
BTN_SND_SHAPE_4 = 11
BTN_TEMPO_UP = 12
BTN_TEMPO_DOWN = 13
BTN_LOAD = 14
BTN_SAVE = 15
BTN_POS_UP = 16
BTN_POS_DOWN = 17
BTN_LEN_UP = 18
BTN_LEN_DOWN = 19
BTN_PAT_UP = 20
BTN_PAT_DOWN = 21
BTN_CUT_TRACK = 22
BTN_CUT_PATTERN = 23
BTN_COPY_TRACK = 24
BTN_COPY_PATTERN = 25
BTN_PASTE_TRACK = 26
BTN_PASTE_PATTERN = 27
BTN_SND_ARP_1 = 28
BTN_SND_ARP_2 = 29
BTN_SND_ARP_3 = 30
BTN_SND_ARP_4 = 31
NO_BUTTONS = 100

-- layouts clavier
QWERTY = 1
AZERTY = 2

-- variables
BPM = 120
nextNotes = (60.0 / (4 * BPM))
countTime = nextNotes
notesPerPattern = 64
musicLength = 1
currentNotesLine = 0
currentPattern = 1
currentTrack = 1
currentEditLine = 1

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

-- clipboard pour la musique
clipmus = {}
for i = 1, 4 do
	clipmus[i] = {}
	
	for j = 1, notesPerPattern do
		clipmus[i][j] = {}
		clipmus[i][j][1] = 0
		clipmus[i][j][2] = DEFAULT_VOLUME
	end
end

-- créer une musique vide avec 1 pattern
mus = {} -- musique
for i = 1, MAX_MUSIC_LENGTH do
	mus[i] = 1
end

currentShownLineStart = 1
currentShownLineEnd = 16
	
currentOctave = 3
currentPianoNote = 0
currentArpNote = currentPianoNote
	
readyForNextNote = true
	
b1 = false
b2 = false
b3 = false

trg = 0
targetButton = 0
	
timeCounter = {0, 0, 0}
trigger = {false, false, false}
waitTrigger = false

options = {BTN_MENU_STOP}
	
-- position des images de touches de piano
piano = {}

-- clavier hardware
kb = {}

-- initialize arrows keycodes
key_right = "right"
key_left = "left"
key_down = "down"
key_up = "up"

key_pageup = "pageup"
key_pagedown = "pagedown"
	
-- app state
STOP = 1
EDIT = 2
PLAY = 3

state = STOP

mode = { "STOP", "EDIT", "PLAY" }

-- générer des signaux carrés par défaut
currentSoundsType = {3, 3, 3 ,3} -- pour chaque piste

soundTypes = { "SIN", "TRI", "SQU", "SAW" }
	
musicName = nil
	
-- créer les instruments
for ch = 1, 4 do
	CreateSounds(ch, currentSoundsType[ch])
end
	
editVolume = false
showVolumeTrigger = false
	
mouseEnabled = true

musicPlaying = false

-- ==============================================================================================================================
-- = fonctions principales =
-- =========================
function love.load()
	-- créer la fenêtre graphique
	love.window.setMode(realScnWidth, realScnHeight, {resizable=false, vsync=true, fullscreen=false})
	love.window.setTitle("LoveRetroBasic ")

	-- initialiser le clavier
	love.keyboard.setKeyRepeat(true)

	-- charger le son de bip touches
	beepSound = love.audio.newSource("audio/beep.ogg", "static")

	-- créer les renderers
	CreateRenderers()
	
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
	LoadDisc(defaultFolder .. currentFolder)
		
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
	
	-- récupérer le layout clavier mémorisé
	GetKeyboardLayout()

	-- préparer le clavier du tracker
	for i = 1, 22 do
		piano[i] = {"blanche", 8 + ((i - 1) * 12), 286, 0}
	end
	
	InitPiano()

	-- clavier hardware
	for i = 1, 34 do
		kb[i] = {}
	end

	InitKeyboard()

	-- initialiser l'application
	appStarted = true
end

function love.keyreleased(key, scancode, isrepeat)
	-- sortie du mode spécial en cas d'erreur
	if specialAppState and err ~= nil then
		if key == "escape" then
			err = nil

			return
		end
	end

	-- mode d’exécution de programme en cours ou terminée
	if appState == RUN_MODE or appState == READY_MODE then
		if key == "escape" then
			EndProgram()

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

				return
			-- voir les raccourcis claviers de l'éditeur
			elseif key == "2" then
				helpPage = 2
				HelpManager()

				return
			-- revenir à l'éditeur
			elseif key == "escape" then
				ShowCursor(false)

				-- rétablir le mode graphique par défaut
				SetMode(DEFAULT_MODE)
				
				-- effacer l'écran
				ClearScreen()
				
				-- redessiner l'éditeur
				RedrawEditor()
				cursor[1] = safeCursor[1]
				cursor[2] = safeCursor[2]
				-- afficher le curseur
				ShowCursor(true)
				appState = EDIT_MODE

				return
			end
		elseif helpPage == 1 or helpPage == 2 then
			-- revenir à l'aide principale
			if key == "escape" then
				helpPage = 0
				HelpManager()

				return
			end
		end
	end
	
	-- gérer les raccourcis clavier de l'éditeur de sprites
	if appState == SPRITE_MODE then
		if key == "escape" then
			-- rétablir le mode graphique par défaut
			SetMode(DEFAULT_MODE)
			
			-- rétablir les couleurs
			SetPenColor(DEFAULT_PEN)
			SetPaperColor(DEFAULT_PAPER)
			SetBorderColor(DEFAULT_PAPER)
			SetGraphicPenColor(DEFAULT_PEN)
			ShowCursor(false)
			ClearScreen()
			RedrawEditor()
			cursor[1] = safeCursor[1]
			cursor[2] = safeCursor[2]
			ShowCursor(true)
			appState = EDIT_MODE

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
	elseif appState == SPRITE_MODE then	
		if key == "s" and love.keyboard.isDown("lctrl", "rctrl") then
			-- sauvegarder tous les sprites existants
			SaveSprites(defaultFolder .. currentFolder .. "sprites.spr")

			return
		elseif key == "x" and love.keyboard.isDown("lctrl", "rctrl") then
			-- copier le sprite courant dans le clipboard
			clipboard[0] = SPRITE_WIDTH
			clipboard[1] = SPRITE_HEIGHT
			
			for i = 0, (SPRITE_WIDTH * SPRITE_HEIGHT) - 1 do
				clipboard[i + 2] = spram[(sprImgNumber * MAX_SPRITE_SIZE) + i]
			end

			-- effacer le sprite
			for i = 0, MAX_SPRITE_SIZE - 1 do
				spram[(sprImgNumber * MAX_SPRITE_SIZE) + i] = 0
			end

			-- afficher le sprite (vide) si possible
			RedrawEditedSprite()
			RedrawCurrentSprite()

			return
		elseif key == "c" and love.keyboard.isDown("lctrl", "rctrl") then
			-- copier le sprite courant dans le clipboard
			clipboard[0] = SPRITE_WIDTH
			clipboard[1] = SPRITE_HEIGHT
			
			for i = 0, (SPRITE_WIDTH * SPRITE_HEIGHT) - 1 do
				clipboard[i + 2] = spram[(sprImgNumber * MAX_SPRITE_SIZE) + i]
			end

			return
		elseif key == "v" and love.keyboard.isDown("lctrl", "rctrl") then
			-- récupérer la taille du sprite
			local w = clipboard[0]
			local h = clipboard[1]

			-- si pas d'erreur, alors...
			if w == SPRITE_WIDTH and h == SPRITE_HEIGHT then 
				-- effacer le sprite sélectionné
				for i = 0, MAX_SPRITE_SIZE - 1 do
					spram[(sprImgNumber * MAX_SPRITE_SIZE) + i] = 0
				end
				
				-- récupérer le sprite dans le clipboard
				for i = 0, (w * h) - 1 do
					spram[(sprImgNumber * MAX_SPRITE_SIZE) + i] = clipboard[i + 2]
				end
				
				-- afficher le sprite (si possible)
				RedrawEditedSprite()
				RedrawCurrentSprite()
			end

			return
		elseif key == "delete" then
			-- effacer le sprite
			for i = 0, MAX_SPRITE_SIZE - 1 do
				spram[(sprImgNumber * MAX_SPRITE_SIZE) + i] = 0
			end
			
			-- afficher le sprite (vide) si possible
			RedrawEditedSprite()
			RedrawCurrentSprite()

			return
		elseif key == "i" and love.keyboard.isDown("lctrl", "rctrl") then
			ImportSprites()
		elseif key == "e" and love.keyboard.isDown("lctrl", "rctrl") then
			ExportSprites()
		end
	-- changer le layout clavier avec tab
	elseif appState == TRACKER_MODE then
		if key == "tab" then
			if keyboard == AZERTY then
				keyboard = QWERTY
			else
				keyboard = AZERTY
			end
			
			UpdateKeyboardLayout()
			InitKeyboard()
		end
		
		if state == STOP then
			if key == key_right then
				if currentTrack < 4 then
					currentTrack = currentTrack + 1
				end
			end
			
			if key == key_left then
				if currentTrack > 1 then
					currentTrack = currentTrack - 1
				end
			end
			
			if key == key_pageup then
				currentShownLineStart = 1
				currentShownLineEnd = 16
				currentEditLine = 1
			end
			
			if key == key_pagedown then
				currentShownLineStart = notesPerPattern - 15
				currentShownLineEnd = notesPerPattern
				currentEditLine = currentShownLineEnd
			end
		end
	-- ajouter certaines touches au buffer clavier
	elseif appState == RUN_MODE then
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
	-- initialiser countTime
	if appStarted then
		countTime = 0
		appStarted = false
	end
	
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
		if GetLeftMouseClic() then
			local x = math.floor(mouseX / 8)
			local y = love.mouse.getY()
						
			if y >= borderY - (16 * gmode[currentMode][3]) and y < borderY - (8 * gmode[currentMode][3]) then
				if x == 0 then -- lancer l'éditeur de sprites
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

					return
				elseif x == 2 then -- lancer l'éditeur de niveaux
					-- remise à zéro d'un éventuel message texte
					msg = nil

					SaveProgram()
					safeCursor[1] = cursor[1]
					safeCursor[2] = cursor[2]
					appState = LEVEL_MODE
					LevelEditor()

					return
				elseif x == 4 then -- lancer l'éditeur de bruitages
					-- remise à zéro d'un éventuel message texte
					msg = nil

					SaveProgram()
					safeCursor[1] = cursor[1]
					safeCursor[2] = cursor[2]
					appState = NOISE_MODE
					NoiseEditor()

					return
				elseif x == 6 then -- lancer le tracker musical
					-- remise à zéro d'un éventuel message texte
					msg = nil

					SaveProgram()
					safeCursor[1] = cursor[1]
					safeCursor[2] = cursor[2]
					appState = TRACKER_MODE
					Tracker()

					return
				elseif x == 8 then -- lancer l'aide
					-- remise à zéro d'un éventuel message texte
					msg = nil

					SaveProgram()
					safeCursor[1] = cursor[1]
					safeCursor[2] = cursor[2]
					appState = HELP_MODE
					HelpManager()

					return
				elseif x >= 10 and x <= 12 then -- executer le programme
					-- remise à zéro d'un éventuel message texte
					msg = nil

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

					return
				elseif x >= 14 and x <= 16 then -- déboguer le programme
					-- remise à zéro d'un éventuel message texte
					msg = nil

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

					return
				elseif x >= 18 and x <= 21 then -- sauvegarder le programme
					-- remise à zéro d'un éventuel message texte
					msg = nil

					SaveProgram()

					return
				elseif x >= 23 and x <= 26 then -- charger le programme
					-- remise à zéro d'un éventuel message texte
					msg = nil

					ShowCursor(false)
					ClearScreen()
					LoadDisc(defaultFolder .. currentFolder)

					return
				elseif x >= 28 and x <= 30 then -- importer un programme
					-- remise à zéro d'un éventuel message texte
					msg = nil

					ShowCursor(false)
					ClearScreen()
					ImportProgram()

					return
				elseif x >= 32 and x <= 34 then -- exporter un programme
					-- remise à zéro d'un éventuel message texte
					msg = nil

					ExportProgram()

					return
				elseif x == 39 then
					--
					SaveProgram()
					QuitProgram()					

					return					
				end
			end
		end
		
		if newTextEntered then
			-- colorier la ligne courante de code source
			SetEditorTextColor(ramLine)
		end
	elseif appState == RUN_MODE then
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
					if GetLeftMouseClic() then
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
	elseif appState == SPRITE_MODE then
		local col = nil
		local mx = -1
		local my = -1
		
		local mpx = mouseX
		local mpy = mouseY

		if GetLeftMouseDown() then
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
		elseif GetRightMouseDown() then
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
		-- afficher les bullers d'aide au survol
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
	elseif appState == TRACKER_MODE then
		-- timers
		for i = 1, #timeCounter do
			timeCounter[i] = timeCounter[i] + dt
			trigger[i] = false
		end
	
		-- répéter le timer souris ou touche appuyée
		if timeCounter[1] > 0.05 then
			timeCounter[1] = timeCounter[1] - 0.05
			trigger[1] = true
		end

		-- premier timer de souris ou de touche appuyée
		if timeCounter[2] > 0.5 then
			timeCounter[2] = timeCounter[2] - 0.5
			trigger[2] = true
		end

		-- timer de clignotement
		if timeCounter[3] > 0.5 then
			timeCounter[3] = timeCounter[3] - 0.5
			trigger[3] = true
		end

		-- clignotte si en mode d'édition de volume
		if trigger[3] and editVolume then
			if showVolumeTrigger == false then
				showVolumeTrigger = true
			else
				showVolumeTrigger = false
			end
		end

		-- mémoriser les anciens événements
		old_b1 = b1
		old_b2 = b2
		old_b3 = b3
	
		-- get the mouse events
		mx = mouseX
		my = mouseY
		b1, b2, b3 = love.mouse.isDown("1", "2", "3")

		-- désactiver les boutons si en mode d'édition de volume
		if editVolume then b1 = false; b2 = false; b3 = false end

		if mx ~= NaN and my ~= NaN and mouseEnabled then
			-- si un bouton souris est pressé...
			if b1 then
				trg = 0
				if mx >= 313 and mx <= 313 + 31 and my >= 0 and my <= 31 then
					trg = BTN_UP
				elseif mx >= 313 and mx <= 313 + 31 and my >= 32 and my <= 63 then
					trg = BTN_DOWN
				elseif mx >= 313 and mx <= 313 + 31 and my >= 128 and my <= 128 + 31 then
					trg = BTN_TEMPO_DOWN
				elseif mx >= 377 and mx <= 377 + 31 and my >= 128 and my <= 128 + 31 then
					trg = BTN_TEMPO_UP
				elseif mx >= 340 and mx <= 340 + 31 and my >= 285 and my <= 285 + 31 then
					trg = BTN_OCTAVE_UP
				elseif mx >= 278 and mx <= 278 + 31 and my >= 285 and my <= 285 + 31 then
					trg = BTN_OCTAVE_DOWN
				elseif mx >= 383 and mx <= 383 + 95 and my >= 0 and my <= 31 then
					trg = BTN_MENU_STOP
				elseif mx >= 383 and mx <= 383 + 95 and my >= 32 and my <= 63 then
					trg = BTN_MENU_EDIT
				elseif mx >= 383 and mx <= 383 + 95 and my >= 64 and my <= 95 then
					trg = BTN_MENU_PLAY
				elseif mx >= 24 and mx <= 24 + 15 and my >= 264 and my <= 264 + 15 then
					trg = BTN_SND_SHAPE_1
				elseif mx >= 24 + 72 and mx <= 24 + 72 + 15 and my >= 264 and my <= 264 + 15 then
					trg = BTN_SND_SHAPE_2
				elseif mx >= 24 + 144 and mx <= 24 + 144 + 15 and my >= 264 and my <= 264 + 15 then
					trg = BTN_SND_SHAPE_3
				elseif mx >= 24 + 144 + 72 and mx <= 24 + 144 + 72 + 15 and my >= 264 and my <= 264 + 15 then
					trg = BTN_SND_SHAPE_4
				elseif mx >= 40 and mx <= 40 + 15 and my >= 264 and my <= 264 + 15 then
					trg = BTN_SND_ARP_1
				elseif mx >= 40 + 72 and mx <= 40 + 72 + 15 and my >= 264 and my <= 264 + 15 then
					trg = BTN_SND_ARP_2
				elseif mx >= 40 + 144 and mx <= 40+144+15 and my >= 264 and my <= 264 + 15 then
					trg = BTN_SND_ARP_3
				elseif mx >= 40 + 144 + 72 and mx <= 40 + 144 + 72 + 15 and my >= 264 and my <= 264 + 15 then
					trg = BTN_SND_ARP_4
				elseif mx >= 480 - 64 + 9 and mx <= 480 - 64 + 9 + 31 and my >= 285 and my <= 285 + 31 then
					trg = BTN_LOAD
				elseif mx >= 480 - 32 + 9 and mx <= 480 - 32 + 9 + 31 and my >= 285 and my <= 285 + 31 then
					trg = BTN_SAVE
				elseif mx >= 377 and mx <= 392 and my >= 168 and my <= 183 then
					trg = BTN_CUT_TRACK
				elseif mx >= 393 and mx <= 408 and my >= 168 and my <= 183 then
					trg = BTN_CUT_PATTERN
				elseif mx >= 377 and mx <= 392 and my >= 184 and my <= 199 then
					trg = BTN_COPY_TRACK
				elseif mx >= 393 and mx <= 408 and my >= 184 and my <= 199 then
					trg = BTN_COPY_PATTERN
				elseif mx >= 377 and mx <= 392 and my >= 200 and my <= 215 then
					trg = BTN_PASTE_TRACK
				elseif mx >= 393 and mx <= 408 and my >= 200 and my <= 215 then
					trg = BTN_PASTE_PATTERN
				elseif mx >= 409 and mx <= 424 and my >= 216 and my <= 231 then
					trg = BTN_POS_DOWN
				elseif mx >= 425 and mx <= 451 and my >= 216 and my <= 231 then
					trg = BTN_POS_UP
				elseif mx >= 409 and mx <= 424 and my >= 232 and my <= 247 then
					trg = BTN_LEN_DOWN
				elseif mx >= 425 and mx <= 451 and my >= 232 and my <= 247 then
					trg = BTN_LEN_UP
				elseif mx >= 409 and mx <= 424 and my >= 248 and my <= 263 then
					trg = BTN_PAT_DOWN
				elseif mx >= 425 and mx <= 451 and my >= 248 and my <= 263 then
					trg = BTN_PAT_UP
				elseif mx >= 32 and mx <= 103 and my >= 0 and my <= 263 then
					currentTrack = 1
					offst = math.floor((my - 4) / 16)
					if offst >= 0 and offst <= 15 then
						currentEditLine = currentShownLineStart + offst
					end
				elseif mx >= 104 and mx <= 175 and my >= 0 and my <= 263 then
					currentTrack = 2
					offst = math.floor((my - 4) / 16)
					if offst >= 0 and offst <= 15 then
						currentEditLine = currentShownLineStart + offst
					end
				elseif mx >= 176 and mx <= 247 and my >= 0 and my <= 263 then
					currentTrack = 3
					offst = math.floor((my - 4) / 16)
					if offst >= 0 and offst <= 15 then
						currentEditLine = currentShownLineStart + offst
					end
				elseif mx >= 248 and mx <= 319 and my >= 0 and my <= 263 then
					currentTrack = 4
					offst = math.floor((my - 4) / 16)
					if offst >= 0 and offst <= 15 then
						currentEditLine = currentShownLineStart + offst
					end
				else
					trg = NO_BUTTONS
				end
			end

			-- si un bouton souris est pressé à l'intérieur d'un bouton virtuel...
			if b1 and not old_b1 then
				if targetButton == 0 and trg ~= 0 then
					targetButton = trg
					waitTrigger = true
					timeCounter[2] = 0
				end
			end
		
			-- attendre le premier trigger
			if waitTrigger and trigger[2] then
				waitTrigger = false
				timeCounter[1] = 0
			end

			-- si le bouton gauche de la souris est pressé
			if b1 then
				if targetButton == trg then
					if (not waitTrigger and trigger[1]) or not old_b1 or ((targetButton == BTN_UP or targetButton == BTN_DOWN) and trigger[1]) then
						-- action tant que le bouton est pressé
						if targetButton == BTN_UP then
							if state ~= PLAY and currentEditLine > 1 then
								currentEditLine = currentEditLine - 1
								if currentEditLine < currentShownLineStart then
									if currentShownLineStart > 1 then
										currentShownLineStart = currentShownLineStart - 1
										currentShownLineEnd = currentShownLineEnd - 1
										currentEditLine = currentShownLineStart
									end
								end
							end
						elseif targetButton == BTN_DOWN then
							if state ~= PLAY and currentEditLine < notesPerPattern then
								currentEditLine = currentEditLine + 1
								if currentEditLine > currentShownLineEnd then
									if currentShownLineEnd < notesPerPattern then
										currentShownLineStart = currentShownLineStart + 1
										currentShownLineEnd = currentShownLineEnd + 1
										currentEditLine = currentShownLineEnd
									end
								end
							end
						elseif targetButton == BTN_TEMPO_UP then
							if state ~= PLAY then
								if BPM < 240 then
									BPM = BPM + 1
									nextNotes = (60.0 / (4 * BPM))
									for a = 1,4 do
										nextArp[a] = nextNotes / arpeggioSpeed[a]
									end
								end
							end
						elseif targetButton == BTN_TEMPO_DOWN then
							if state ~= PLAY then
								if BPM > 40 then
									BPM = BPM - 1
									nextNotes = (60.0 / (4 * BPM))
									for a = 1,4 do
										nextArp[a] = nextNotes / arpeggioSpeed[a]
									end
								end
							end
						elseif targetButton == BTN_POS_DOWN then
							if state ~= PLAY then
								if currentPattern > 1 then
									currentPattern = currentPattern - 1
								end
							else
								if currentPattern > 1 then
									-- stopper les instruments
									SoundStop()
	
									currentPattern = currentPattern - 1
								
									-- remise à zéro du pattern
									currentShownLineStart = 1
									currentShownLineEnd = 16
									currentNotesLine = 0
									countTime = 0
								end
							end
						elseif targetButton == BTN_POS_UP then
							if state ~= PLAY then
								if currentPattern < musicLength then
									currentPattern = currentPattern + 1
								end
							else
								if currentPattern < musicLength then
									-- stopper les instruments
									SoundStop()
	
									currentPattern = currentPattern + 1
									
									-- remise à zéro du pattern
									currentShownLineStart = 1
									currentShownLineEnd = 16
									currentNotesLine = 0
									countTime = 0
								end
							end
						elseif targetButton == BTN_LEN_DOWN then
							if state ~= PLAY then
								if musicLength > 1 then
									musicLength = musicLength - 1
									if currentPattern > musicLength then
										currentPattern = 1
									end
								end
							else
								if musicLength > 1 then
									-- stopper les instruments
									SoundStop()

									musicLength = musicLength - 1
									if currentPattern > musicLength then
										currentPattern = 1
									
										-- remise à zéro du pattern
										currentShownLineStart = 1
										currentShownLineEnd = 16
										currentNotesLine = 0
										countTime = 0
									end
								end
							end
						elseif targetButton == BTN_LEN_UP then
							if musicLength < MAX_MUSIC_LENGTH then
								musicLength = musicLength + 1
							end
						elseif targetButton == BTN_PAT_DOWN then
							if state ~= PLAY then
								if mus[currentPattern] > 1 then
									mus[currentPattern] = mus[currentPattern] - 1
								end
							else
								if mus[currentPattern] > 1 then
									-- stopper les instruments
									SoundStop()
	
									mus[currentPattern] = mus[currentPattern] - 1
									
									-- remise à zéro du pattern
									currentShownLineStart = 1
									currentShownLineEnd = 16
									currentNotesLine = 0
									countTime = 0
								end
							end
						elseif targetButton == BTN_PAT_UP then
							if state ~= PLAY then
								if mus[currentPattern] < MAX_PATTERNS then
									mus[currentPattern] = mus[currentPattern] + 1
								end
							else
								if mus[currentPattern] < MAX_PATTERNS then
									-- stopper les instruments
									SoundStop()
	
									mus[currentPattern] = mus[currentPattern] + 1
									
									-- remise à zéro du pattern
									currentShownLineStart = 1
									currentShownLineEnd = 16
									currentNotesLine = 0
									countTime = 0
								end
							end
						end
					end
				else
					targetButton = - 1
				end
			elseif targetButton == - 1 then
				waitTrigger = false
				targetButton = 0
			else
				-- action quand on relâche le bouton de la souris
				if targetButton == BTN_OCTAVE_UP then
					if currentOctave < 5 then
						currentOctave = currentOctave + 1
					end
				elseif targetButton == BTN_OCTAVE_DOWN then
					if currentOctave > 1 then
						currentOctave = currentOctave - 1
					end
				elseif targetButton == BTN_MENU_STOP then
					if state == PLAY then
						-- stopper les instruments
						SoundStop()
	
						currentEditLine = currentNotesLine
						
						-- changer d'état pour "Stop Mode"
						state = STOP
						options[1] = BTN_MENU_STOP
					elseif state == EDIT then
						state = STOP
						options[1] = BTN_MENU_STOP
					end
				elseif targetButton == BTN_MENU_EDIT then
					if state == PLAY then
						-- stopper les instruments
						SoundStop()
	
						currentEditLine = currentNotesLine
						
						-- changer d'état pour "Edit Mode"
						state = EDIT
						options[1] = BTN_MENU_EDIT
					elseif state == STOP then
						state = EDIT
						options[1] = BTN_MENU_EDIT
					end
				elseif targetButton == BTN_MENU_PLAY then
					if state ~= PLAY then
						-- stopper les sons du piano
						if currentPianoNote > 0 then
							stop(instr[1][currentPianoNote])
						end
						
						-- remette à zéro le pattern
						currentShownLineStart = 1
						currentShownLineEnd = 16
						currentNotesLine = 0
						countTime = 0
						
						-- changer d'état pour "Play Mode"
						state = PLAY
						options[1] = BTN_MENU_PLAY
					end
				elseif targetButton == BTN_SND_SHAPE_1 then
					if state == STOP then
						-- stopper les sons de piano
						if currentPianoNote > 0 then
							stop(instr[1][currentPianoNote])
						end

						-- changer la forme d'onde
						currentSoundsType[1] = currentSoundsType[1] + 1

						if currentSoundsType[1] > 4 then
							currentSoundsType[1] = 1
						end
					
						-- charger le nouveau son
						CreateSounds(1, currentSoundsType[1])
					end
				elseif targetButton == BTN_SND_SHAPE_2 then
					if state == STOP then
						-- stopper les sons de piano
						if currentPianoNote > 0 then
							stop(instr[1][currentPianoNote])
						end
						
						-- changer la forme d'onde
						currentSoundsType[2] = currentSoundsType[2] + 1
						if currentSoundsType[2] > 4 then
							currentSoundsType[2] = 1
						end
						
						-- charger le nouveau son
						CreateSounds(2, currentSoundsType[2])
					end
				elseif targetButton == BTN_SND_SHAPE_3 then
					if state == STOP then
						-- stopper les sons de piano
						if currentPianoNote > 0 then
							stop(instr[1][currentPianoNote])
						end
						
						-- changer la forme d'onde
						currentSoundsType[3] = currentSoundsType[3] + 1
						if currentSoundsType[3] > 4 then
							currentSoundsType[3] = 1
						end
						
						-- charger le nouveau son
						CreateSounds(3, currentSoundsType[3])
					end
				elseif targetButton == BTN_SND_SHAPE_4 then
					if state == STOP then
						-- stopper les sons de piano
						if currentPianoNote > 0 then
							stop(instr[1][currentPianoNote])
						end
						
						-- changer la forme d'onde
						currentSoundsType[4] = currentSoundsType[4] + 1
						if currentSoundsType[4] > 4 then
							currentSoundsType[4] = 1
						end
					
						-- charger le nouveau son
						CreateSounds(4, currentSoundsType[4])
					end
				elseif targetButton == BTN_SND_ARP_1 then
					if state == STOP then
						-- stopper les sons de piano
						if currentPianoNote > 0 then
							stop(instr[1][currentPianoNote])
						end
						
						-- changer le type d'arpège
						arpeggioType[1] = arpeggioType[1] + 1
						
						if arpeggioType[1] > 4 then
							arpeggioType[1] = 1
						end
					end
				elseif targetButton == BTN_SND_ARP_2 then
					if state == STOP then
						-- stopper les sons de piano
						if currentPianoNote > 0 then
							stop(instr[1][currentPianoNote])
						end
						
						-- changer le type d'arpège
						arpeggioType[2] = arpeggioType[2] + 1
						if arpeggioType[2] > 4 then
							arpeggioType[2] = 1
						end
					end
				elseif targetButton == BTN_SND_ARP_3 then
					if state == STOP then
						-- stopper les sons de piano
						if currentPianoNote > 0 then
							stop(instr[1][currentPianoNote])
						end
						
						-- changer le type d'arpège
						arpeggioType[3] = arpeggioType[3] + 1
						if arpeggioType[3] > 4 then
							arpeggioType[3] = 1
						end
					end
				elseif targetButton == BTN_SND_ARP_4 then
					if state == STOP then
						--- stopper les sons de piano
						if currentPianoNote > 0 then
							stop(instr[1][currentPianoNote])
						end
						
						-- changer le type d'arpège
						arpeggioType[4] = arpeggioType[4] + 1
						if arpeggioType[4] > 4 then
							arpeggioType[4] = 1
						end
					end
				elseif targetButton == BTN_LOAD then
					if state == STOP then
						-- stopper les sons de piano
						if currentPianoNote > 0 then
							stop(instr[1][currentPianoNote])
						end

						-- charger une musique
						local f = input("Name of the music (no extension)", "My Music")
						if f ~= nil then
							if #f > 0 then
								musicName = f .. ".rmu"
								local filename = Path.combine(musicFolder, musicName)
								ClearMusic()
								LoadMusic(filename)
								-- créer les instruments
								for ch = 1,4 do
									CreateSounds(ch, currentSoundsType[ch])
								end
							end
						end
					else
						mouseEnabled = false
						msgbox("Please push 'STOP' button first !")
					end
				elseif targetButton == BTN_SAVE then
					if state == STOP then
						-- stopper les sons de piano
						if currentPianoNote > 0 then
							stop(instr[1][currentPianoNote])
						end
						
						-- sauvegarder une musique
						if musicName == nil then
							local f = input("Name of the music (no extension)", "My Music")
							if f ~= nil then
								if #f > 0 then
									musicName = f .. ".rmu"
									local filename = Path.combine(musicFolder, musicName)
									SaveMusic(filename)
									mouseEnabled = false
									msgbox("Saved !")
								end
							end
						else
							local filename = Path.combine(musicFolder, musicName)
							SaveMusic(filename)
							mouseEnabled = false
							msgbox("Saved !")
						end
					else
						mouseEnabled = false
						msgbox("Please push 'STOP' button first !")
					end
				elseif targetButton == BTN_CUT_TRACK then
					if state == EDIT then
						-- couper la piste
						for i = 1,notesPerPattern do
							clipmus[1][i][1] = pattern[currentTrack][i][mus[currentPattern]]
							clipmus[1][i][2] = vol[currentTrack][i][mus[currentPattern]]
							pattern[currentTrack][i][mus[currentPattern]] = 0
							vol[currentTrack][i][mus[currentPattern]] = DEFAULT_VOLUME
						end
						
						-- remettre à zéro les autres pistes
						for i = 2,4 do
							for j = 1,notesPerPattern do
								clipmus[i][j][1] = 0
								clipmus[i][j][2] = DEFAULT_VOLUME
							end
						end
					else
						msgbox("You must set EDIT mode !")
					end
				elseif targetButton == BTN_CUT_PATTERN then
					if state == EDIT then
						-- couper le pattern
						for i = 1,4 do
							for j = 1,notesPerPattern do
								clipmus[i][j][1] = pattern[i][j][mus[currentPattern]]
								clipmus[i][j][2] = vol[i][j][mus[currentPattern]]
								pattern[i][j][mus[currentPattern]] = 0
								vol[i][j][mus[currentPattern]] = DEFAULT_VOLUME
							end
						end
					else
						msgbox("You must set EDIT mode !")
					end
				elseif targetButton == BTN_COPY_TRACK then
					if state == EDIT then
						-- copier la piste
						for i = 1,notesPerPattern do
							clipmus[1][i][1] = pattern[currentTrack][i][mus[currentPattern]]
							clipmus[1][i][2] = vol[currentTrack][i][mus[currentPattern]]
						end
						
						-- remettre à zéro les autres pistes
						for i = 2, 4 do
							for j = 1, notesPerPattern do
								clipmus[i][j][1] = 0
								clipmus[i][j][2] = DEFAULT_VOLUME
							end
						end
						
						-- message d'info
						msgbox("Copied")
					else
						msgbox("You must set EDIT mode !")
					end
				elseif targetButton == BTN_COPY_PATTERN then
					if state == EDIT then
						-- copier le pattern
						for i = 1, 4 do
							for j = 1, notesPerPattern do
								clipmus[i][j][1] = pattern[i][j][mus[currentPattern]]
								clipmus[i][j][2] = vol[i][j][mus[currentPattern]]
							end
						end
						
						msgbox("Copied")
					else
						msgbox("You must set EDIT mode !")
					end
				elseif targetButton == BTN_PASTE_TRACK then
					if state == EDIT then
						-- coller la piste
						for i = 1,notesPerPattern do
							pattern[currentTrack][i][mus[currentPattern]] = clipmus[1][i][1]
							vol[currentTrack][i][mus[currentPattern]] = clipmus[1][i][2]
						end
					else
						msgbox("You must set EDIT mode !")
					end
				elseif targetButton == BTN_PASTE_PATTERN then
					if state == EDIT then
						-- coller le pattern
						for i = 1,4 do
							for j = 1,notesPerPattern do
								pattern[i][j][mus[currentPattern]] = clipmus[i][j][1]
								vol[i][j][mus[currentPattern]] = clipmus[i][j][2]
							end
						end
					else
						msgbox("You must set EDIT mode !")
					end
				end
				--
				targetButton = 0
				mouseEnabled = true
			end
		end
		
		-- ====================================================================
		-- jouer une musique
		if state == PLAY then
			UpdateMusic(dt)
		elseif state == STOP then
			nt = GetKeyboardPlay(currentTrack, dt)
			if nt == 0 then
				if love.keyboard.isDown(key_up) and trigger[1] then
					if currentEditLine > 1 then
						currentEditLine = currentEditLine - 1
						if currentEditLine < currentShownLineStart then
							if currentShownLineStart > 1 then
								currentShownLineStart = currentShownLineStart - 1
								currentShownLineEnd = currentShownLineEnd - 1
								currentEditLine = currentShownLineStart
							end
						end
					end
				end
				if love.keyboard.isDown(key_down) and trigger[1] then
					if currentEditLine < notesPerPattern then
						currentEditLine = currentEditLine + 1
						if currentEditLine > currentShownLineEnd then
							if currentShownLineEnd < notesPerPattern then
								currentShownLineStart = currentShownLineStart + 1
								currentShownLineEnd = currentShownLineEnd + 1
								currentEditLine = currentShownLineEnd
							end
						end
					end
				end
			end
		elseif state == EDIT then
			if editVolume == false then
				nt = GetKeyboardPlay(currentTrack, dt)
				if nt > 0 and readyForNextNote then
					pattern[currentTrack][currentEditLine][mus[currentPattern]] = nt
					currentEditLine = currentEditLine + 1
					if currentEditLine > currentShownLineEnd then
						if currentShownLineEnd < notesPerPattern then
							currentShownLineStart = currentShownLineStart + 1
							currentShownLineEnd = currentShownLineEnd + 1
						end
						currentEditLine = currentShownLineEnd
					end
					readyForNextNote = false
				elseif nt == 0 then
					readyForNextNote = true
	
					-- touche suppr
					if keyp(127) then
						pattern[currentTrack][currentEditLine][mus[currentPattern]] = 0
						currentEditLine = currentEditLine + 1
						if currentEditLine > currentShownLineEnd then
							if currentShownLineEnd < notesPerPattern then
								currentShownLineStart = currentShownLineStart + 1
								currentShownLineEnd = currentShownLineEnd + 1
							end
							currentEditLine = currentShownLineEnd
						end
					end
	
					-- touche espace
					if keyp(32) then
						pattern[currentTrack][currentEditLine][mus[currentPattern]] = 100
						currentEditLine = currentEditLine + 1
						if currentEditLine > currentShownLineEnd then
							if currentShownLineEnd < notesPerPattern then
								currentShownLineStart = currentShownLineStart + 1
								currentShownLineEnd = currentShownLineEnd + 1
							end
							currentEditLine = currentShownLineEnd
						end
					end
	
					-- fleche haut
					if keyp(key_up) then
						if currentEditLine > 1 then
							currentEditLine = currentEditLine - 1
							if currentEditLine < currentShownLineStart then
								if currentShownLineStart > 1 then
									currentShownLineStart = currentShownLineStart - 1
									currentShownLineEnd = currentShownLineEnd - 1
								end
								currentEditLine = currentShownLineStart
							end
						end
					end
	
					-- fleche bas
					if keyp(key_down) then
						if currentEditLine < notesPerPattern then
							currentEditLine = currentEditLine + 1
							if currentEditLine > currentShownLineEnd then
								if currentShownLineEnd < notesPerPattern then
									currentShownLineStart = currentShownLineStart + 1
									currentShownLineEnd = currentShownLineEnd + 1
								end
								currentEditLine = currentShownLineEnd
							end
						end
					end
	
					-- fleche droite
					if keyp(key_right) then
						if currentTrack < 4 then
							currentTrack = currentTrack + 1
						end
					end
	
					-- fleche gauche
					if keyp(key_left) then
						if currentTrack > 1 then
							currentTrack = currentTrack - 1
						end
					end
	
					-- page up
					if keyp(key_pageup) then
						currentShownLineStart = 1
						currentShownLineEnd = 16
						currentEditLine = 1
					end
	
					-- page down
					if keyp(key_pagedown) then
						currentShownLineStart = notesPerPattern - 15
						currentShownLineEnd = notesPerPattern
						currentEditLine = currentShownLineEnd
					end
					
					-- touche entrée pour éditer le volume
					if keyp(13) then
						editVolume = true
						showVolumeTrigger = true
					end
				end
			else
				-- touche entrée pour annuler l'édition de volume
				if keyp(13) then
					editVolume = false
					showVolumeTrigger = false
				end
			
				if editVolume then
					for i = 48, 57 do
						if keyp(i) then
							vol[currentTrack][currentEditLine][mus[currentPattern]] = i - 48

							if currentEditLine < notesPerPattern then
								currentEditLine = currentEditLine + 1
								if currentEditLine > currentShownLineEnd then
									if currentShownLineEnd < notesPerPattern then
										currentShownLineStart = currentShownLineStart + 1
										currentShownLineEnd = currentShownLineEnd + 1
									end
									currentEditLine = currentShownLineEnd
								end
							end
							
							break
						end
					end
				end
			
				if editVolume then
					for i = 65, 70 do
						if keyp(i) then
							vol[currentTrack][currentEditLine][mus[currentPattern]] = i - 55

							if currentEditLine < notesPerPattern then
								currentEditLine = currentEditLine + 1
								if currentEditLine > currentShownLineEnd then
									if currentShownLineEnd < notesPerPattern then
										currentShownLineStart = currentShownLineStart + 1
										currentShownLineEnd = currentShownLineEnd + 1
									end
									currentEditLine = currentShownLineEnd
								end
							end
							
							break
						end
					end
				end
				
				if editVolume then
					for i = 97, 102 do
						if keyp(i) then
							vol[currentTrack][currentEditLine][mus[currentPattern]] = i - 87
	
							if currentEditLine < notesPerPattern then
								currentEditLine = currentEditLine + 1
								if currentEditLine > currentShownLineEnd then
									if currentShownLineEnd < notesPerPattern then
										currentShownLineStart = currentShownLineStart + 1
										currentShownLineEnd = currentShownLineEnd + 1
									end
									currentEditLine = currentShownLineEnd
								end
							end
							
							break
						end
					end
				end
			end
		end	
	end
	
	-- effacer le buffer clavier
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
	love.graphics.draw(renderer[currentRenderer], borderX, borderY, 0, gmode[currentMode][3], gmode[currentMode][4], 0, 0, 0, 0)
		
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
		local xn = math.floor(mx / 8)
		local y = math.floor(my / 8)

		-- afficher la position de la souris dans la barre du bas
		-- de l'éditeur de sprites
		if x >= 0 and x < SPRITE_WIDTH and y >= 0 and y < SPRITE_HEIGHT then
			local st = "x,y: " .. tostring(x) .. "," .. tostring(y)			
			PrintInfosString(st, 2, "black")
		elseif y == 20 then
			if xn == 17 then
				PrintInfosString("Cut Sprite", 2, "black")
			elseif xn == 19 then
				PrintInfosString("Copy Sprite", 2, "black")
			elseif xn == 21 then
				PrintInfosString("Paste Sprite", 2, "black")
			elseif xn == 23 then
				PrintInfosString("Save Sprites", 2, "black")
			elseif xn == 25 then
				PrintInfosString("Import Sprites", 2, "black")
			elseif xn == 27 then
				PrintInfosString("Export Sprites", 2, "black")
			end
		end
	elseif appState == TRACKER_MODE then
		local memGPen = gpen

		-- dessiner l'UI du tracker
		gpen = 17
		DrawRectangle(0, 0, 312, 264, 1)
		
		gpen = 1
		DrawRectangle(0, 0, 312, 264, 0)
	
		if state == PLAY then
			if currentNotesLine > currentShownLineEnd then
				currentShownLineEnd = currentNotesLine
				currentShownLineStart = currentShownLineEnd - 15
			elseif currentNotesLine < 2 then
				currentShownLineStart = 1
				currentShownLineEnd = 16
			end
			ShowTracks(currentShownLineStart, currentShownLineEnd, currentNotesLine, mus[currentPattern], 0)
		else
			ShowTracks(currentShownLineStart, currentShownLineEnd, currentEditLine, mus[currentPattern], currentTrack)
		end
	
		-- montrer les pistes qui jouent
		if app_started then
			for i = 1,4 do
				if pattern[i][currentNotesLine][mus[currentPattern]] ~= 0 then
					rect(25 + ((i - 1)*72), 265, 25 + (i*72), 265+8, true, 2)
				end
			end
		end

		gpen = 1
		
		DrawFullLine(24, 0, 24, 264)
		DrawFullLine(96, 0, 96, 264)
		DrawFullLine(168, 0, 168, 264)
		DrawFullLine(240, 0, 240, 264)
		
		gpen = memGPen
	
		-- scrollbar
		if targetButton == BTN_UP then
			--DrawButton(313, 0, 16, 16, 1, 9, 1, 0)
		else
			--DrawButton(313, 0, 16, 16, 2, 9, 1, 0)
		end
		--tex(button_up, 313, 0)
	
		if targetButton == BTN_DOWN then
			--DrawButton(313, 32, 16, 16, 1, 9, 1, 0)
		else
			--DrawButton(313, 32, 16, 16, 2, 9, 1, 0)
		end
		--tex(button_down, 313, 32)
	
		-- boutons d'octave
		if targetButton == BTN_OCTAVE_UP then
			DrawButton(340, 285, 16, 16, 1, 9, 1, 0)
		else
			DrawButton(340, 285, 16, 16, 2, 9, 1, 0)
		end
		Text("+", 353, 291, 25)
	
		if targetButton == BTN_OCTAVE_DOWN then
			DrawButton(278, 285, 16, 16, 1, 9, 1, 0)
		else
			DrawButton(278, 285, 16, 16, 2, 9, 1, 0)
		end
		Text("-", 291, 291, 25)
	
		Text("Octave:", 300, 266, 25)
		DrawButton(308, 285, 16, 16, 1, 1, 9, 25)
		Text(tostring(currentOctave), 322, 292, 25)
	
		-- boutons de menu
		if options[1] == BTN_MENU_STOP then
			--tex(large_button_pushed, 383, 0)
		else
			--tex(large_button, 383, 0)
		end
		Text(mode[1], 415, 7, 25)
	
		if options[1] == BTN_MENU_EDIT then
			--tex(large_button_pushed, 383, 32)
		else
			--tex(large_button, 383, 32)
		end
		Text(mode[2], 415, 39, 25)
	
		if options[1] == BTN_MENU_PLAY then
			--tex(large_button_pushed, 383, 64)
		else
			--tex(large_button, 383, 64)
		end
		Text(mode[3], 415, 71, 25)
			
		-- boutons de tempo
		Text("TEMPO:", 313+28, 108, 25)
		--tex(textbox, 313+32, 128)
		Text(tostring(BPM), 313+37, 134, 25)
	
		if targetButton == BTN_TEMPO_DOWN then
			--tex(button_pushed, 313, 128)
		else
			--tex(button, 313, 128)
		end
		Text("-", 326, 134, 25)
	
		if targetButton == BTN_TEMPO_UP then
			--tex(button_pushed, 313+64, 128)
		else
			--tex(button, 313+64, 128)
		end
		Text("+", 326+64, 134, 25)
	
		-- montrer le layout clavier
		if keyboard == AZERTY then
			Text("AZERTY", 480-64+9, 291-24, 26)
		else
			Text("QWERTY", 480 - 64 + 9, 291 - 24, 26)
		end
		
		-- boutons load/save
		if targetButton == BTN_LOAD then
			--tex(button_pushed, 480 - 64, 285)
		else
			--tex(button, 480 - 64, 285)
		end
		Text("LD", 480 - 64 + 9, 291, 25)
	
		if targetButton == BTN_SAVE then
			--tex(button_pushed, 480 - 32, 285)
		else
			--tex(button, 480 - 32, 285)
		end
		Text("SV", 480 - 32 + 9, 291, 25)
		
		-- boutons de formes d'ondes
		t = textbox_mini
		if state ~= STOP then
			t = textbox_mini_disabled
		end
		
		--tex(t, 24, 264)
		--tex(img_shape[currentSoundsType[1]], 24, 264)
	
		--tex(t, 24+72, 264, 16, 16)
		--tex(img_shape[currentSoundsType[2]], 24+72, 264, 16, 16)
	
		--tex(t, 24+144, 264, 16, 16)
		--tex(img_shape[currentSoundsType[3]], 24+144, 264, 16, 16)
	
		--tex(t, 24+144+72, 264, 16, 16)
		--tex(img_shape[currentSoundsType[4]], 24+144+72, 264, 16, 16)
		
		-- boutons d'arpège
		t = textbox_mini
		if state ~= STOP then
			t = textbox_mini_disabled
		end
		
		--tex(t, 40, 264)
		--tex(img_arp[arpeggioType[1]], 40, 264)
	
		--tex(t, 40+72, 264, 16, 16)
		--tex(img_arp[arpeggioType[2]], 40+72, 264, 16, 16)
	
		--tex(t, 40+144, 264, 16, 16)
		--tex(img_arp[arpeggioType[3]], 40+144, 264, 16, 16)
	
		--tex(t, 40+144+72, 264, 16, 16)
		--tex(img_arp[arpeggioType[4]], 40+144+72, 264, 16, 16)
	
		-- bouton couper/copier/coller piste
		--tex(large_textbox, 313, 168)
		Text("CUT", 313+3, 167, 25)
	
		if targetButton == BTN_CUT_TRACK then
			--tex(button_mini_pushed, 377, 168)
		else
			--tex(button_mini, 377, 168)
		end
		Text("T", 381, 166, 25)
	
		if targetButton == BTN_CUT_PATTERN then
			--tex(button_mini_pushed, 393, 168)
		else
			--tex(button_mini, 393, 168)
		end
		Text("P", 397, 166, 25)
	
		--tex(large_textbox, 313, 184)
		Text("COPY", 313+3, 183, 25)
	
		if targetButton == BTN_COPY_TRACK then
			--tex(button_mini_pushed, 377, 184)
		else
			--tex(button_mini, 377, 184)
		end
		Text("T", 381, 182, 25)
	
		if targetButton == BTN_COPY_PATTERN then
			--tex(button_mini_pushed, 393, 184)
		else
			--tex(button_mini, 393, 184)
		end
		Text("P", 397, 182, 25)
	
		--tex(large_textbox, 313, 200)
		Text("PASTE", 313+3, 199, 25)
	
		if targetButton == BTN_PASTE_TRACK then
			--tex(button_mini_pushed, 377, 200)
		else
			--tex(button_mini, 377, 200)
		end
		Text("T", 381, 198, 25)
	
		if targetButton == BTN_PASTE_PATTERN then
			--tex(button_mini_pushed, 393, 200)
		else
			--tex(button_mini, 393, 200)
		end
		Text("P", 397, 198, 25)
	
		-- boutons et infos patterns
		--tex(large_textbox, 313, 216)
		Text("POSITION " .. tostring(currentPattern), 313+3, 215, 25)
	
		--tex(large_textbox, 313, 232)
		Text("LENGTH   " .. tostring(musicLength), 313+3, 231, 25)
	
		--tex(large_textbox, 313, 248)
		Text("PATTERN  " .. tostring(mus[currentPattern]), 313+3, 247, 25)
	
		if targetButton == BTN_POS_DOWN then
			--tex(button_mini_pushed, 409, 216)
		else
			--tex(button_mini, 409, 216)
		end
		Text("-", 415, 214, 25)
	
		if targetButton == BTN_POS_UP then
			--tex(button_mini_pushed, 313+96+16, 216)
		else
			--tex(button_mini, 313+96+16, 216)
		end
		Text("+", 431, 214, 25)
	
		if targetButton == BTN_LEN_DOWN then
			--tex(button_mini_pushed, 313+96, 232)
		else
			--tex(button_mini, 313+96, 232)
		end
		Text("-", 415, 230, 25)
	
		if targetButton == BTN_LEN_UP then
			--tex(button_mini_pushed, 313+96+16, 232)
		else
			--tex(button_mini, 313+96+16, 232)
		end
		Text("+", 431, 230, 25)
	
		if targetButton == BTN_PAT_DOWN then
			--tex(button_mini_pushed, 313+96, 248)
		else
			--tex(button_mini, 313+96, 248)
		end
		Text("-", 415, 246, 25)
	
		if targetButton == BTN_PAT_UP then
			--tex(button_mini_pushed, 313+96+16, 248)
		else
			--tex(button_mini, 313+96+16, 248)
		end
		Text("+", 431, 246, 25)
		
		-- montrer le piano pour jouer
		for i = 1, 37 do
			--tex(piano[i][1], piano[i][2], piano[i][3])
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
		love.graphics.draw(renderer[2], borderX, borderY + ((gmode[currentMode][2] + 8) * gmode[currentMode][3]), 0, gmode[currentMode][3], gmode[currentMode][4], 0, 0, 0, 0)
	end

	-- afficher le renderer de message d'erreur
	if appState == EDIT_MODE or appState == READY_MODE or (appState == RUN_MODE and stepsMode) then
		love.graphics.draw(renderer[3], borderX, borderY + ((gmode[currentMode][2] + 16) * gmode[currentMode][4]), 0, gmode[currentMode][3], gmode[currentMode][4], 0, 0, 0, 0)
	end
	
	-- afficher le renderer de menu outils
	if appState == EDIT_MODE then
		PrintInfosString(Chr(1) .. " " ..Chr(2) .. " " ..Chr(3) .. " " ..Chr(4) .. " ? RUN DBG SAVE LOAD IMP EXP    X", 4, "blue")
		love.graphics.draw(renderer[4], borderX, borderY - (16 * gmode[currentMode][3]), 0, gmode[currentMode][3], gmode[currentMode][4], 0, 0, 0, 0)
	end

	-- afficher un message de débogage
	if dbg ~= nil then
		love.window.showMessageBox("Debug", dbg, "info", true)
		print("Debug: " .. dbg)
		dbg = nil
	end	
end

-- ==============================================================================================================================
