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
			"FOR", "FREEBOB",
			"GETBORDER", "GETLOCX", "GETLOCY", "GETPAPER", "GETPEN", "GETGRAPHPEN", "GOSUB", "GOTO", "GRAPHPEN", "GRAPHPRINT",
			"HEX$", "HOTSPOT",
			"IF", "INKEY$", "INPUT",
			"LINE", "LOADBOB", "LOADIMAGE", "LOCATE",
			"MODE", "MOVE", "MOVER", "MUSIC",
			"NEXT",
			"OVAL",
			"PAPER", "PASTEBOB", "PEN", "PLOT", "PLOTR", "PRINT",
			"RECT", "REPEAT", "RETURN",
			"SAVEBOB", "SELECT", "SGN", "SPRITEIMG", "SPRITEOFF", "SPRITEON", "SPRITEPOS", "SPRITESCALE", "SPRITETRANSP", "STOPMUSIC", "STEP", "STR$",
			"TO",
			"UNTIL",
			"VAL",
			"WAITKEY", "WAITVBL", "WEND", "WHILE"
		}

-- liste des identifiants de commandes
cmd = {}

-- entrées des fonctions dans une table
for i = 1, #commands do
	cmd[commands[i]] = {fn = nil, ret = 0, pmin = 0, pmax = 0, ptype = {VAR_INTEGER}}
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
cmd["GETGRAPHPEN"].ret = VAR_INTEGER
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
cmd["CASE"].pmin, cmd["CASE"].pmax = 1, 1
cmd["CHR$"].pmin, cmd["CHR$"].pmax = 1, 1
-- CLS
cmd["DRAW"].pmin, cmd["DRAW"].pmax = 2, 2
cmd["DRAWR"].pmin, cmd["DRAWR"].pmax = 2, 2
-- ENDIF
-- ENDSELECT
-- END
cmd["ELSEIF"].pmin, cmd["ELSEIF"].pmax = 1, 1
-- ELSE
cmd["FOR"].pmin, cmd["FOR"].pmax = 1, 1
cmd["FREEBOB"].pmin, cmd["FREEBOB"].pmax = 1, 1
cmd["GOSUB"].pmin, cmd["GOSUB"].pmax = 1, 1
cmd["GOTO"].pmin, cmd["GOTO"].pmax = 1, 1
cmd["GRAPHPEN"].pmin, cmd["GRAPHPEN"].pmax = 1, 1
cmd["GRAPHPRINT"].pmin, cmd["GRAPHPRINT"].pmax = 0, -1
cmd["HEX$"].pmin, cmd["HEX$"].pmax = 1, 1
cmd["HOTSPOT"].pmin, cmd["HOTSPOT"].pmax = 2, 2
cmd["IF"].pmin, cmd["IF"].pmax = 1, 1
cmd["LINE"].pmin, cmd["LINE"].pmax = 4, 4
cmd["LOADBOB"].pmin, cmd["LOADBOB"].pmax = 2, 2
cmd["LOADIMAGE"].pmin, cmd["LOADIMAGE"].pmax = 1, 1
cmd["LOCATE"].pmin, cmd["LOCATE"].pmax = 2, 2
cmd["MODE"].pmin, cmd["MODE"].pmax = 1, 1
cmd["MOVE"].pmin, cmd["MOVE"].pmax = 2, 2
cmd["MOVER"].pmin, cmd["MOVER"].pmax = 2, 2
cmd["MUSIC"].pmin, cmd["MUSIC"].pmax = 1, 1
cmd["OVAL"].pmin, cmd["OVAL"].pmax = 5, 5
cmd["PAPER"].pmin, cmd["PAPER"].pmax = 1, 1
cmd["PASTEBOB"].pmin, cmd["PASTEBOB"].pmax = 3, 3
cmd["PEN"].pmin, cmd["PEN"].pmax = 1, 1
cmd["PLOT"].pmin, cmd["PLOT"].pmax = 2, 2
cmd["PLOTR"].pmin, cmd["PLOTR"].pmax = 2, 2
cmd["PRINT"].pmin, cmd["PRINT"].pmax = 0, -1
cmd["RECT"].pmin, cmd["RECT"].pmax = 5, 5
cmd["SELECT"].pmin, cmd["SELECT"].pmax = 1, 1
cmd["SAVEBOB"].pmin, cmd["SAVEBOB"].pmax = 2, 2
cmd["SGN"].pmin, cmd["SGN"].pmax = 1, 1
cmd["SPRITEIMG"].pmin, cmd["SPRITEIMG"].pmax = 2, 2
cmd["SPRITEOFF"].pmin, cmd["SPRITEOFF"].pmax = 1, 1
cmd["SPRITEON"].pmin, cmd["SPRITEON"].pmax = 1, 1
cmd["SPRITEPOS"].pmin, cmd["SPRITEPOS"].pmax = 3, 3
cmd["SPRITESCALE"].pmin, cmd["SPRITESCALE"].pmax = 2, 2
cmd["SPRITETRANSP"].pmin, cmd["SPRITETRANSP"].pmax = 2, 2
cmd["STEP"].pmin, cmd["STEP"].pmax = 1, 1
cmd["STR$"].pmin, cmd["STR$"].pmax = 1, 1
cmd["TO"].pmin, cmd["TO"].pmax = 1, 1
cmd["UNTIL"].pmin, cmd["UNTIL"].pmax = 1, 1
cmd["VAL"].pmin, cmd["VAL"].pmax = 1, 1
cmd["WHILE"].pmin, cmd["WHILE"].pmax = 1, 1

-- définir le type de valeur du paramètre en entrée pour chaque instruction BASIC
cmd["ABS"].ptype = {VAR_NUM}
cmd["ASC"].ptype = {VAR_STRING}
cmd["CASE"].ptype = {VAR_CONSTANT}
cmd["CHR$"].ptype = {VAR_NUM}
cmd["ELSEIF"].ptype = {VAR_CONDITION}
cmd["FOR"].ptype = {VAR_INTEGER}
cmd["GOSUB"].ptype = {VAR_LABEL}
cmd["GOTO"].ptype = {VAR_LABEL}
cmd["GRAPHPRINT"].ptype = {VAR_POLY}
cmd["IF"].ptype = {VAR_CONDITION}
cmd["LOADIMAGE"].ptype = {VAR_STRING}
cmd["LOADBOB"].ptype = {VAR_STRING, VAR_INTEGER}
cmd["PASTEBOB"].ptype = {VAR_INTEGER, VAR_FLOAT, VAR_FLOAT}
cmd["PRINT"].ptype = {VAR_POLY}
cmd["SAVEBOB"].ptype = {VAR_STRING, VAR_INTEGER}
cmd["SELECT"].ptype = {VAR_VAR}
cmd["SGN"].ptype = {VAR_NUM}
cmd["STEP"].ptype = {VAR_INTEGER}
cmd["TO"].ptype = {VAR_INTEGER}
cmd["UNTIL"].ptype = {VAR_CONDITION}
cmd["STR$"].ptype = {VAR_NUM}
cmd["VAL"].ptype = {VAR_STRING}
cmd["WHILE"].ptype = {VAR_CONDITION}

-- opérateurs spéciaux
operators = {"MOD"}

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
require("audio")
require("player")
require("images")

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
MAX_SCN_HEIGHT = 400
SCN_SIZE_INFOS_HEIGHT = 8

MAX_CLIPBOARD = MAX_SCN_WIDTH * MAX_SCN_HEIGHT

DEFAULT_MODE = 1

MAX_BOB = 65535

-- ================================
-- = définir les modes graphiques =
-- ================================
gmode = {}
gmode[0] = {160, 100, 4, 4}
gmode[1] = {320, 200, 2, 2}
gmode[2] = {640, 400, 1, 1}

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

-- ===========================
-- = créer les bobs virtuels =
-- ===========================
bob = {}

-- =====================
-- = matrices d'icones =
-- =====================
arp = {}

arp[1] = {
	"0000000000000000",
	"0000100110011000",
	"0001010101010100",
	"0001110110011000",
	"0001010101010000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0011111111111100",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000"
}

arp[2] = {
	"0000000000000000",
	"0000100110011000",
	"0001010101010100",
	"0001110110011000",
	"0001010101010000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000011100000",
	"0000000000000000",
	"0000011100000000",
	"0000000000000000",
	"0011100000011100",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000"
}

arp[3] = {
	"0000000000000000",
	"0000100110011000",
	"0001010101010100",
	"0001110110011000",
	"0001010101010000",
	"0000000000000000",
	"0000000000011100",
	"0000000000000000",
	"0000000000000000",
	"0000000011100000",
	"0000011100000000",
	"0000000000000000",
	"0011100000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000"
}

arp[4] = {
	"0000000000000000",
	"0000100110011000",
	"0001010101010100",
	"0001110110011000",
	"0001010101010000",
	"0000000000000000",
	"0000000000011100",
	"0000000000000000",
	"0000000000000000",
	"0000000011100000",
	"0000000000000000",
	"0000011100000000",
	"0011100000000000",
	"0000000000000000",
	"0000000000000000",
	"0000000000000000"
}

img_shape = {}

img_shape[1] = {
	"0000000000000000",
	"0000000000000000",
	"0000110000000000",
	"0001001000000000",
	"0001001000000000",
	"0010000100000000",
	"0010000100000000",
	"0010000100000000",
	"0000000010000100",
	"0000000010000100",
	"0000000010000100",
	"0000000001001000",
	"0000000001001000",
	"0000000000110000",
	"0000000000000000",
	"0000000000000000"
}

img_shape[2] = {
	"0000000000000000",
	"0000000000000000",
	"0000010000000000",
	"0000010000000000",
	"0000101000000000",
	"0000101000000000",
	"0001000100000000",
	"0001000100000000",
	"0000000010001000",
	"0000000010001000",
	"0000000001010000",
	"0000000001010000",
	"0000000000100000",
	"0000000000100000",
	"0000000000000000",
	"0000000000000000"
}

img_shape[3] = {
	"0000000000000000",
	"0000000000000000",
	"0011111100000000",
	"0010000100000000",
	"0010000100000000",
	"0010000100000000",
	"0010000100000000",
	"0010000100000000",
	"0000000100001000",
	"0000000100001000",
	"0000000100001000",
	"0000000100001000",
	"0000000100001000",
	"0000000111111000",
	"0000000000000000",
	"0000000000000000"
}

img_shape[4] = {
	"0000000000000000",
	"0000000000000000",
	"0010000010000000",
	"0010000010000000",
	"0011000011000000",
	"0011000011000000",
	"0010100010100000",
	"0010100010100000",
	"0010010010010000",
	"0010010010010000",
	"0010001010001000",
	"0010001010001000",
	"0010000110000100",
	"0010000110000100",
	"0000000000000000",
	"0000000000000000"
}

-- matrix images for keyboard
img_kb = {}

img_kb[1] = {
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"100000000001",
	"X1111111111X"
}

img_kb[2] = {
	"0111111110",
	"0111111110",
	"0111111110",
	"0111111110",
	"0111111110",
	"0111111110",
	"0111111110",
	"0111111110",
	"0111111110",
	"0111111110",
	"0111111110",
	"0111111110",
	"0111111110",
	"0111111110",
	"0111111110",
	"0111111110",
	"0111111110",
	"0111111110",
	"0111111110",
	"X00000000X"
}

-- =============================================
-- = définition de quelques variables globales =
-- =============================================
kb_buffer = "" -- tampon clavier
dbg = nil -- message de débogage
errCode = nil -- sortie d'erreur
msg = nil -- sortie de message ou de question (errCode est prioritaire sur msg)
msgLine = nil -- sortie de numéro de ligne en steps mode

diskFolder = nil -- nom du dossier du projet en cours, pour sauvegarder le fichier
driveFolder = nil -- répertoire par défaut de l'application
currentRelativeFolder = nil -- chemin relatif courant

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

-- ====================
-- = audio et musique =
-- ====================
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

-- créer les patterns
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

key_home = "home"
key_end = "end"
	
-- app state
STOP = 1
EDIT = 2
PLAY = 3

state = STOP

trck_mode = { "STOP", "EDIT", "PLAY" }

track = {nil, nil, nil, nil}

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
musicPlaying = false

mouseEnabled = true

setFullscreen = false
screenScaleX = 1
screenScaleY = 1

-- ==============================================================================================================================
-- = fonctions principales =
-- =========================
function love.load()
	-- créer la fenêtre graphique
	love.window.setMode(realScnWidth, realScnHeight, {resizable=false, vsync=true, fullscreen=false})
	love.window.setTitle("LoveRetroBasic ")
	
	-- mettre le programme en plein fenêtre (maximisé)
	if setFullscreen then love.window.maximize() end

	-- calculer le redimensionnement de l'écran si en 'plein écran'
	local w = love.graphics.getWidth() -- nouvelle taille écran
	local h = love.graphics.getHeight()
	
	screenScaleX = (w / realScnWidth)
	screenScaleY = (h / realScnHeight)
	
	-- mettre à jour l'écran en fonction de sa mémoire virtuelle
	borderX = borderX * screenScaleX
	borderY = borderY * screenScaleY

	-- initialiser le clavier
	love.keyboard.setKeyRepeat(true)

	-- charger le son de bip touches
	beepSound = love.audio.newSource("audio/beep.ogg", "static")
	validateSound = love.audio.newSource("audio/click.ogg", "static")

	-- créer les renderers
	CreateRenderers()
	
	-- dessiner sans flou
	love.graphics.setLineStyle("rough")
	
	-- initialiser tout
	local e, l = InitSymbols()

	if e ~= OK then
		errCode = GetError(e) .. " line " .. tostring(l)
	else
		Reset()
	end

	-- trouver le drive virtuel courant
	driveFolder = love.filesystem.getIdentity()
	
	-- créer le Disk0 s'il n'existe pas
	diskFolder = "Disk0"
	CreateDisk(driveFolder, diskFolder)

	--récupérer le répertoire courant
	GetCurrentFolder()
	
	-- créer les dossiers pour le jeu
	imageFolder = "Images"
	spriteFolder = "Sprites"
	musicFolder = "Musics"
		
	if not love.filesystem.getInfo(currentRelativeFolder .. imageFolder, "directory") then love.filesystem.createDirectory(diskFolder .. "/" .. imageFolder) end
	if not love.filesystem.getInfo(currentRelativeFolder .. spriteFolder, "directory") then love.filesystem.createDirectory(diskFolder .. "/" .. spriteFolder) end
	if not love.filesystem.getInfo(currentRelativeFolder .. musicFolder, "directory") then love.filesystem.createDirectory(diskFolder .. "/" .. musicFolder) end

	-- pointer sur le disque par défaut
	love.filesystem.setIdentity(currentRelativeFolder)
	
	-- choisir le Disk0 comme disque par défaut
	LoadDisc(currentRelativeFolder)
	
	-- récupérer le layout clavier mémorisé
	GetKeyboardLayout()

	-- préparer le clavier du tracker
	for i = 1, 22 do
		piano[i] = {img_kb[1], 8 + ((i - 1) * 12), 286, 0}
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
	if specialAppState and errCode ~= nil then
		if key == "escape" then
			errCode = nil

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
			if key == "1" or key == "kp1" then
				helpPage = 1
				HelpManager()

				return
			-- voir les raccourcis claviers de l'éditeur
			elseif key == "2" or key == "kp2" then
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
	
	-- permettre de quitter les éditeurs
	if appState == SPRITE_MODE or appState == TRACKER_MODE then
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
		elseif key == "f1" then
			UI_Help()
		elseif key == "f5" then
			UI_Run()
		elseif key == "f6" then
			UI_Debug()
		elseif key == "f7" then
			UI_Save()
		elseif key == "f8" then
			UI_Load()
		elseif key == "f9" then
			UI_Import()
		elseif key == "f10" then
			UI_Export()
		elseif key == "delete" and love.keyboard.isDown("lctrl", "rctrl") then
			KillProgram()
		elseif key == "q" and love.keyboard.isDown("lctrl", "rctrl") then
			CloseProgram()
		end
	elseif appState == SPRITE_MODE then	
		if key == "s" and love.keyboard.isDown("lctrl", "rctrl") then
			-- sauvegarder tous les sprites existants
			SaveSprites("sprites.spr")

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
			
			if key == key_home then
				currentShownLineStart = 1
				currentShownLineEnd = 16
				currentEditLine = 1
			end
			
			if key == key_end then
				currentShownLineStart = notesPerPattern - 15
				currentShownLineEnd = notesPerPattern
				currentEditLine = currentShownLineEnd
			end
		elseif state == EDIT then
			if editVolume == false then				
				if noteOn == 0 then
					readyForNextNote = true
	
					-- touche suppr
					if key == "backspace" then
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
					if key == "space" then
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
					if key == key_up then
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
					if key == key_down then
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
					if key == key_right then
						if currentTrack < 4 then
							currentTrack = currentTrack + 1
						end
					end
	
					-- fleche gauche
					if key == key_left then
						if currentTrack > 1 then
							currentTrack = currentTrack - 1
						end
					end
	
					-- page up
					if key == key_home then
						currentShownLineStart = 1
						currentShownLineEnd = 16
						currentEditLine = 1
					end
	
					-- page down
					if key == key_end then
						currentShownLineStart = notesPerPattern - 15
						currentShownLineEnd = notesPerPattern
						currentEditLine = currentShownLineEnd
					end
					
					-- touche entrée pour éditer le volume
					if key == "return" then
						editVolume = true
						showVolumeTrigger = true
					end
				end
			else
				-- touche entrée pour annuler l'édition de volume
				if key == "return" then
					editVolume = false
					showVolumeTrigger = false
				end
			
				if editVolume then
					for i = 48, 57 do
						if key == string.char(i) then
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
						if key == string.char(i) then
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
						if key == string.char(i) then
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
					
					SetMode(2)
					
					Tracker()

					return
				elseif x == 8 then -- lancer l'aide
					UI_Help()
				elseif x >= 11 and x <= 11 then -- executer le programme
					UI_Run()
				elseif x >= 13 and x <= 13 then -- déboguer le programme
					UI_Debug()
				elseif x >= 16 and x <= 16 then -- sauvegarder le programme
					UI_Save()
				elseif x >= 18 and x <= 18 then -- charger le programme
					UI_Load()
				elseif x >= 21 and x <= 21 then -- importer un programme
					UI_Import()
				elseif x >= 23 and x <= 23 then -- exporter un programme
					UI_Export()
				elseif x >= 26 and x <= 26 then -- effacer le programme
					KillProgram()
				elseif x == 39 then
					CloseProgram()
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
			-- exécuter les commandes
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
						errCode, value = GetError(Exec(Parser(Lexer(RemoveLabels(s)))), ProgramCounter)
					else
						errCode = GetError(e, ProgramCounter)
					end
					
					-- stopper en cas d'erreur
					if errCode == "Ok" then
						errCode = nil
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
				if mx >= 313 and mx <= 313 + 15 and my >= 0 and my <= 15 then
					trg = BTN_UP
				elseif mx >= 313 and mx <= 313 + 15 and my >= 32 and my <= 47 then
					trg = BTN_DOWN
				elseif mx >= 313 and mx <= 313 + 15 and my >= 128 and my <= 128 + 15 then
					trg = BTN_TEMPO_DOWN
				elseif mx >= 377 and mx <= 377 + 15 and my >= 128 and my <= 128 + 15 then
					trg = BTN_TEMPO_UP
				elseif mx >= 340 and mx <= 340 + 15 and my >= 285 and my <= 285 + 15 then
					trg = BTN_OCTAVE_UP
				elseif mx >= 278 and mx <= 278 + 15 and my >= 285 and my <= 285 + 15 then
					trg = BTN_OCTAVE_DOWN
				elseif mx >= 383 and mx <= 383 + 47 and my >= 0 and my <= 15 then
					trg = BTN_MENU_STOP
				elseif mx >= 383 and mx <= 383 + 47 and my >= 32 and my <= 47 then
					trg = BTN_MENU_EDIT
				elseif mx >= 383 and mx <= 383 + 47 and my >= 64 and my <= 79 then
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
				elseif mx >= 40 + 144 and mx <= 40 + 144 + 15 and my >= 264 and my <= 264 + 15 then
					trg = BTN_SND_ARP_3
				elseif mx >= 40 + 144 + 72 and mx <= 40 + 144 + 72 + 15 and my >= 264 and my <= 264 + 15 then
					trg = BTN_SND_ARP_4
				elseif mx >= 480 - 64 + 9 and mx <= 480 - 64 + 9 + 15 and my >= 285 and my <= 285 + 15 then
					trg = BTN_LOAD
				elseif mx >= 480 - 32 + 9 and mx <= 480 - 32 + 9 + 15 and my >= 285 and my <= 285 + 15 then
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
							Stop(instr[1][currentPianoNote])
							currentPianoNote = 0
						end
						
						-- remette à zéro le pattern
						currentShownLineStart = 1
						currentShownLineEnd = 16
						currentNotesLine = 0
						countTime = 0
						
						-- musique en fonction
						musicPlaying = true
						
						-- changer d'état pour "Play Mode"
						state = PLAY
						options[1] = BTN_MENU_PLAY
					end
				elseif targetButton == BTN_SND_SHAPE_1 then
					if state == STOP then
						-- stopper les sons de piano
						if currentPianoNote > 0 then
							Stop(instr[1][currentPianoNote])
							currentPianoNote = 0
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
							Stop(instr[1][currentPianoNote])
							currentPianoNote = 0
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
							Stop(instr[1][currentPianoNote])
							currentPianoNote = 0
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
							Stop(instr[1][currentPianoNote])
							currentPianoNote = 0
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
							Stop(instr[1][currentPianoNote])
							currentPianoNote = 0
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
							Stop(instr[1][currentPianoNote])
							currentPianoNote = 0
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
							Stop(instr[1][currentPianoNote])
							currentPianoNote = 0
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
							Stop(instr[1][currentPianoNote])
							currentPianoNote = 0
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
							Stop(instr[1][currentPianoNote])
							currentPianoNote = 0
						end

						-- charger une musique
						--local f = input("Name of the music (no extension)", "My Music")
						-- TODO
						musicName = "music1.rmu"
						if f ~= nil then
							if #f > 0 then
								ClearMusic()
								LoadMusic(musicName)
								-- créer les instruments
								for ch = 1, 4 do
									CreateSounds(ch, currentSoundsType[ch])
								end
							end
						end
					else
						mouseEnabled = false
						love.window.showMessageBox("Info", "Please push 'STOP' button first !", "info", true)
					end
				elseif targetButton == BTN_SAVE then
					if state == STOP then
						-- stopper les sons de piano
						if currentPianoNote > 0 then
							Stop(instr[1][currentPianoNote])
							currentPianoNote = 0
						end
						
						-- sauvegarder une musique
						if musicName == nil then
							--local f = input("Name of the music (no extension)", "My Music")
							-- TODO
							musicName = "music1.rmu"
							
							if f ~= nil then
								if #f > 0 then
									SaveMusic(musicName)
									mouseEnabled = false
									love.window.showMessageBox("Info", "Saved !", "info", true)
								end
							end
						else
							SaveMusic(musicName)
							mouseEnabled = false
							love.window.showMessageBox("Info", "Saved !", "info", true)
						end
					else
						mouseEnabled = false
						love.window.showMessageBox("Info", "Please push 'STOP' button first !", "info", true)
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
						love.window.showMessageBox("Info", "You must set EDIT mode !", "info", true)
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
						love.window.showMessageBox("Info", "You must set EDIT mode !", "info", true)
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
						love.window.showMessageBox("Info", "Copied", "info", true)
					else
						love.window.showMessageBox("Info", "You must set EDIT mode !", "info", true)
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
						
						-- message d'info
						love.window.showMessageBox("Info", "Copied", "info", true)
					else
						love.window.showMessageBox("Info", "You must set EDIT mode !", "info", true)
					end
				elseif targetButton == BTN_PASTE_TRACK then
					if state == EDIT then
						-- coller la piste
						for i = 1,notesPerPattern do
							pattern[currentTrack][i][mus[currentPattern]] = clipmus[1][i][1]
							vol[currentTrack][i][mus[currentPattern]] = clipmus[1][i][2]
						end
					else
						love.window.showMessageBox("Info", "You must set EDIT mode !", "info", true)
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
						love.window.showMessageBox("Info", "You must set EDIT mode !", "info", true)
					end
				end

				targetButton = 0
				mouseEnabled = true
			end
		end
		
		-- ====================================================================
		-- jouer une musique
		if state == PLAY then
			UpdateMusic(dt)
		elseif state == EDIT then
			if editVolume == false then
				noteOn = GetKeyboardPlay(currentTrack, dt)
				
				if noteOn > 0 and readyForNextNote then
					pattern[currentTrack][currentEditLine][mus[currentPattern]] = noteOn
					currentEditLine = currentEditLine + 1
					
					if currentEditLine > currentShownLineEnd then
						if currentShownLineEnd < notesPerPattern then
							currentShownLineStart = currentShownLineStart + 1
							currentShownLineEnd = currentShownLineEnd + 1
						end
						currentEditLine = currentShownLineEnd
					end
					
					readyForNextNote = false
				end
			end
		elseif state == STOP then
			noteOn = GetKeyboardPlay(currentTrack, dt)
			
			if noteOn == 0 then
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
	love.graphics.draw(renderer[currentRenderer], borderX, borderY, 0, gmode[currentMode][3] * screenScaleX, gmode[currentMode][4] * screenScaleY, 0, 0, 0, 0)
		
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
		
		local nfo = ""
		
		x = math.floor(mx / 8)
		y = math.floor(my / 8)
		
		if y == 0 then
			if x == 0 then
				nfo = "Sprite Editor"
				PrintInfosString(nfo, 2, "orange", 17)
			elseif x == 2 then
				nfo = "Level Editor"
				PrintInfosString(nfo, 2, "orange", 17)
			elseif x == 4 then
				nfo = "Noise Editor"
				PrintInfosString(nfo, 2, "orange", 17)
			elseif x == 6 then
				nfo = "Tracker"
				PrintInfosString(nfo, 2, "orange", 17)
			elseif x == 8 then
				nfo = "Help"
				PrintInfosString(nfo, 2, "green", 17)
			elseif x == 11 then
				nfo = "Run Program"
				PrintInfosString(nfo, 2, "red", 17)
			elseif x == 13 then
				nfo = "Debug Program"
				PrintInfosString(nfo, 2, "red", 17)
			elseif x == 16 then
				nfo = "Save Program"
				PrintInfosString(nfo, 2, "black", 17)
			elseif x == 18 then
				nfo = "Load Program"
				PrintInfosString(nfo, 2, "black", 17)
			elseif x == 21 then
				nfo = "Import/Export Program"
				PrintInfosString(nfo, 2, "blue", 17)
			elseif x == 24 then
				nfo = "Delete Program"
				PrintInfosString(nfo, 2, "red", 17)
			end
		end

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

		-- redessiner l'écran
		Tracker()

		-- dessiner un background pour le tracker
		DrawButton(0, 0, 480, 320, 1, 25, 9, 9)

		-- dessiner l'UI du tracker
		gpen = 40
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
			for i = 1, 4 do
				if pattern[i][currentNotesLine][mus[currentPattern]] ~= 0 then
					gpen = 2
					DrawRectangle(25 + ((i - 1) * 72), 265, 25 + (i * 72), 265 + 8, true)
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
			DrawButton(313, 0, 16, 16, 1, 9, 1, 0)
			Text(Chr(157), 317, 4, 1)
		else
			DrawButton(313, 0, 16, 16, 2, 9, 1, 0)
			Text(Chr(157), 317, 4, 25)
		end
	
		if targetButton == BTN_DOWN then
			DrawButton(313, 32, 16, 16, 1, 9, 1, 0)
			Text(Chr(158), 317, 36, 1)
		else
			DrawButton(313, 32, 16, 16, 2, 9, 1, 0)
			Text(Chr(158), 317, 36, 25)
		end
	
		-- boutons d'octave
		if targetButton == BTN_OCTAVE_UP then
			DrawButton(340, 285, 16, 16, 1, 9, 1, 0)
			Text("+", 348, 293, 1, true)
		else
			DrawButton(340, 285, 16, 16, 2, 9, 1, 0)
			Text("+", 348, 293, 25, true)
		end
	
		if targetButton == BTN_OCTAVE_DOWN then
			DrawButton(278, 285, 16, 16, 1, 9, 1, 0)
			Text("-", 286, 293, 1, true)
		else
			DrawButton(278, 285, 16, 16, 2, 9, 1, 0)
			Text("-", 286, 293, 25, true)
		end
	
		Text("Octave", 294, 270, 4, false)
		DrawButton(308, 285, 16, 16, 1, 1, 9, 9)
		Text(tostring(currentOctave), 316, 293, 25, true)
	
		-- boutons de menu
		if options[1] == BTN_MENU_STOP then
			DrawButton(383, 0, 48, 16, 1, 9, 1, 0)
			Text(trck_mode[1], 392, 4, 1, false)
		else
			DrawButton(383, 0, 48, 16, 2, 9, 1, 0)
			Text(trck_mode[1], 392, 4, 25, false)
		end
	
		if options[1] == BTN_MENU_EDIT then
			DrawButton(383, 32, 48, 16, 1, 9, 1, 0)
			Text(trck_mode[2], 392, 36, 1, false)
		else
			DrawButton(383, 32, 48, 16, 2, 9, 1, 0)
			Text(trck_mode[2], 392, 36, 25, false)
		end
	
		if options[1] == BTN_MENU_PLAY then
			DrawButton(383, 64, 48, 16, 1, 9, 1, 0)
			Text(trck_mode[3], 392, 68, 1, false)
		else
			DrawButton(383, 64, 48, 16, 2, 9, 1, 0)
			Text(trck_mode[3], 392, 68, 25, false)
		end
			
		-- boutons de tempo
		Text("TEMPO", 313 + 20, 112, 4, false)
		DrawButton(313 + 16, 128, 48, 16, 1, 1, 9, 9)
		Text(tostring(BPM), 313 + 40, 136, 25, true)
	
		if targetButton == BTN_TEMPO_DOWN then
			DrawButton(313, 128, 16, 16, 1, 9, 1, 0)
		else
			DrawButton(313, 128, 16, 16, 2, 9, 1, 0)
		end
		Text("-", 321, 136, 25, true)
	
		if targetButton == BTN_TEMPO_UP then
			DrawButton(313 + 64, 128, 16, 16, 1, 9, 1, 0)
		else
			DrawButton(313 + 64, 128, 16, 16, 2, 9, 1, 0)
		end
		Text("+", 321 + 64, 136, 25, true)
	
		-- montrer le layout clavier
		if keyboard == AZERTY then
			Text("AZERTY", 480 - 64, 291 - 20, 10, false)
		else
			Text("QWERTY", 480 - 64, 291 - 20, 10, false)
		end
		
		-- boutons load/save
		if targetButton == BTN_LOAD then
			DrawButton(480 - 64, 285, 16, 16, 1, 9, 1, 0)
		else
			DrawButton(480 - 64, 285, 16, 16, 2, 9, 1, 0)
		end
		Text("L", 480 - 64 + 9, 293, 25, true)
	
		if targetButton == BTN_SAVE then
			DrawButton(480 - 32, 285, 16, 16, 1, 9, 1, 0)
		else
			DrawButton(480 - 32, 285, 16, 16, 2, 9, 1, 0)
		end
		Text("S", 480 - 32 + 9, 293, 25, true)
		
		-- boutons de formes d'ondes
		t = textbox_mini
		if state ~= STOP then
			t = textbox_mini_disabled

			DrawButton(24, 264, 16, 16, 1, 9, 0, 0)
			DrawButton(24 + 72, 264, 16, 16, 1, 9, 0, 0)
			DrawButton(24 + 144, 264, 16, 16, 1, 9, 0, 0)
			DrawButton(24 + 144 + 72, 264, 16, 16, 1, 9, 0, 0)
		else
			DrawButton(24, 264, 16, 16, 1, 1, 9, 9)
			DrawButton(24 + 72, 264, 16, 16, 1, 1, 9, 9)
			DrawButton(24 + 144, 264, 16, 16, 1, 1, 9, 9)
			DrawButton(24 + 144 + 72, 264, 16, 16, 1, 1, 9, 9)
		end
		
		DrawMatrix(img_shape[currentSoundsType[1]], 24, 264, 0, 1)
		DrawMatrix(img_shape[currentSoundsType[2]], 24 + 72, 264, 0, 1)
		DrawMatrix(img_shape[currentSoundsType[3]], 24 + 144, 264, 0, 1)
		DrawMatrix(img_shape[currentSoundsType[4]], 24 + 144 + 72, 264, 0, 1)
		
		-- boutons d'arpège
		t = textbox_mini
		if state ~= STOP then
			t = textbox_mini_disabled
			
			DrawButton(40, 264, 16, 16, 1, 9, 0, 0)
			DrawButton(40 + 72, 264, 16, 16, 1, 9, 0, 0)
			DrawButton(40 + 144, 264, 16, 16, 1, 9, 0, 0)
			DrawButton(40 + 144 + 72, 264, 16, 16, 1, 9, 0, 0)
		else
			DrawButton(40, 264, 16, 16, 1, 1, 9, 9)
			DrawButton(40 + 72, 264, 16, 16, 1, 1, 9, 9)
			DrawButton(40 + 144, 264, 16, 16, 1, 1, 9, 9)
			DrawButton(40 + 144 + 72, 264, 16, 16, 1, 1, 9, 9)
		end
		
		DrawMatrix(arp[arpeggioType[1]], 40, 264, 0, 1)
		DrawMatrix(arp[arpeggioType[2]], 40 + 72, 264, 0, 1)
		DrawMatrix(arp[arpeggioType[3]], 40 + 144, 264, 0, 1)
		DrawMatrix(arp[arpeggioType[4]], 40 + 144 + 72, 264, 0, 1)
	
		-- bouton couper/copier/coller piste
		DrawButton(313, 168, 96, 16, 1, 1, 9, 0)
		Text("CUT", 316, 172, 25, false)
	
		if targetButton == BTN_CUT_TRACK then
			DrawButton(377, 168, 16, 16, 1, 9, 1, 0)
			Text("T", 381, 172, 1, false)
		else
			DrawButton(377, 168, 16, 16, 2, 9, 1, 0)
			Text("T", 381, 172, 25, false)
		end
	
		if targetButton == BTN_CUT_PATTERN then
			DrawButton(393, 168, 16, 16, 1, 9, 1, 0)
			Text("P", 398, 172, 1, false)
		else
			DrawButton(393, 168, 16, 16, 2, 9, 1, 0)
			Text("P", 398, 172, 25, false)
		end
	
		DrawButton(313, 184, 96, 16, 1, 1, 9, 0)
		Text("COPY", 316, 188, 25, false)
	
		if targetButton == BTN_COPY_TRACK then
			DrawButton(377, 184, 16, 16, 1, 9, 1, 0)
			Text("T", 381, 188, 1, false)
		else
			DrawButton(377, 184, 16, 16, 2, 9, 1, 0)
			Text("T", 381, 188, 25, false)
		end
	
		if targetButton == BTN_COPY_PATTERN then
			DrawButton(393, 184, 16, 16, 1, 9, 1, 0)
			Text("P", 398, 188, 1, false)
		else
			DrawButton(393, 184, 16, 16, 2, 9, 1, 0)
			Text("P", 398, 188, 25, false)
		end
	
		DrawButton(313, 200, 96, 16, 1, 1, 9, 0)
		Text("PASTE", 316, 204, 25, false)
	
		if targetButton == BTN_PASTE_TRACK then
			DrawButton(377, 200, 16, 16, 1, 9, 1, 0)
			Text("T", 381, 204, 1, false)
		else
			DrawButton(377, 200, 16, 16, 2, 9, 1, 0)
			Text("T", 381, 204, 25, false)
		end
	
		if targetButton == BTN_PASTE_PATTERN then
			DrawButton(393, 200, 16, 16, 1, 9, 1, 0)
			Text("P", 398, 204, 1, false)
		else
			DrawButton(393, 200, 16, 16, 2, 9, 1, 0)
			Text("P", 398, 204, 25, false)
		end
	
		-- boutons et infos patterns
		DrawButton(313, 216, 96, 16, 1, 1, 25, 0)
		Text("POSITION " .. tostring(currentPattern), 316, 220, 25, false)
	
		DrawButton(313, 232, 96, 16, 1, 1, 25, 0)
		Text("LENGTH   " .. tostring(musicLength), 316, 236, 25, false)
	
		DrawButton(313, 248, 96, 16, 1, 1, 25, 0)
		Text("PATTERN  " .. tostring(mus[currentPattern]), 316, 252, 25, false)
	
		if targetButton == BTN_POS_DOWN then
			DrawButton(409, 216, 16, 16, 1, 9, 0, 1)
			Text("-", 413, 220, 1, false)
		else
			DrawButton(409, 216, 16, 16, 2, 9, 0, 1)
			Text("-", 413, 220, 25, false)
		end
	
		if targetButton == BTN_POS_UP then
			DrawButton(313 + 96 + 16, 216, 16, 16, 1, 9, 0, 1)
			Text("+", 429, 220, 1, false)
		else
			DrawButton(313 + 96 + 16, 216, 16, 16, 2, 9, 0, 1)
			Text("+", 429, 220, 25, false)
		end
	
		if targetButton == BTN_LEN_DOWN then
			DrawButton(313 + 96, 232, 16, 16, 1, 9, 0, 1)
			Text("-", 413, 237, 1, false)
		else
			DrawButton(313 + 96, 232, 16, 16, 2, 9, 0, 1)
			Text("-", 413, 237, 25, false)
		end
	
		if targetButton == BTN_LEN_UP then
			DrawButton(313 + 96 + 16, 232, 16, 16, 1, 9, 0, 1)
			Text("+", 429, 237, 1, false)
		else
			DrawButton(313 + 96 + 16, 232, 16, 16, 2, 9, 0, 1)
			Text("+", 429, 237, 25, false)
		end
	
		if targetButton == BTN_PAT_DOWN then
			DrawButton(313 + 96, 248, 16, 16, 1, 9, 0, 1)
			Text("-", 413, 254, 1, false)
		else
			DrawButton(313 + 96, 248, 16, 16, 2, 9, 0, 1)
			Text("-", 413, 254, 25, false)
		end
	
		if targetButton == BTN_PAT_UP then
			DrawButton(313 + 96 + 16, 248, 16, 16, 1, 9, 0, 1)
			Text("+", 429, 254, 1, false)
		else
			DrawButton(313 + 96 + 16, 248, 16, 16, 2, 9, 0, 1)
			Text("+", 429, 254, 25, false)
		end
		
		-- montrer le piano pour jouer
		for i = 1, 37 do
			DrawMatrix(piano[i][1], piano[i][2], piano[i][3], 0, 1)
		end
	elseif appState == RUN_MODE and stepsMode and msgLine ~= nil then
		PrintInfosString("Line " .. msgLine, 2, "black")
		PrintInfosString("LeftClick " .. Chr(160) .. Chr(160), 2, "orange", 20)
	end

	-- afficher les erreurs
	if errCode == nil and msg ~= nil then
		PrintInfosString(msg, 3, "blue")
		specialAppState = true
	elseif errCode ~= nil then
		PrintInfosString(errCode, 3, "red")
		specialAppState = true
	end

	-- afficher le renderer d'infos en mode édition de texte
	if appState == EDIT_MODE or (appState == RUN_MODE and stepsMode) or appState == SPRITE_MODE or appState == NOISE_MODE or appState == TRACKER_MODE then
		love.graphics.draw(renderer[2], borderX, borderY + ((gmode[currentMode][2] + 8) * 2 * screenScaleY), 0, 2 * screenScaleX, 2 * screenScaleY, 0, 0, 0, 0)
	end

	-- afficher le renderer de message d'erreur
	if appState == EDIT_MODE or appState == READY_MODE or (appState == RUN_MODE and stepsMode) then
		love.graphics.draw(renderer[3], borderX, borderY + ((gmode[currentMode][2] + 16) * 2 * screenScaleY), 0, 2 * screenScaleX, 2 * screenScaleY, 0, 0, 0, 0)
	end
	
	-- afficher le renderer de menu outils
	if appState == EDIT_MODE then
		PrintInfosString(Chr(1) .. " " ..Chr(2) .. " " ..Chr(3) .. " " .. Chr(4), 4, "orange")
		PrintInfosString("?", 4, "green", 8)
		PrintInfosString(Chr(158) .. " " .. Chr(157), 4, "black", 16)
		PrintInfosString(Chr(160) .. " " .. Chr(161), 4, "red", 11)
		PrintInfosString("I E", 4, "blue", 21)
		PrintInfosString(Chr(255), 4, "red", 26)
		PrintInfosString("X", 4, "black", 39)
		love.graphics.draw(renderer[4], borderX, borderY - (16 * 2 * screenScaleY), 0, 2 * screenScaleX, 2 * screenScaleY, 0, 0, 0, 0)
	end

	-- afficher un message de débogage
	if dbg ~= nil then
		love.window.showMessageBox("Debug", dbg, "info", true)
		print("Debug: " .. dbg)
		dbg = nil
	end
end
