extends Node

onready var Player = preload("res://objects/player/Player.tscn")
onready var PlayerCorpse = preload("res://objects/player/PlayerCorpse.tscn")
onready var Spawning = preload("res://objects/player/Spawning.tscn")
onready var BloodPar = preload("res://objects/blood/BloodPar.tscn")
onready var BloodTrail = preload("res://objects/blood/BloodTrail.tscn")
onready var PlayerChild = preload("res://objects/player/PlayerChild.tscn")

onready var CustomLabel = preload("res://objects/system/label/CustomLabel.tscn")

onready var StartDim = preload("res://objects/hud/MapStartDim.tscn")
onready var FinishDim = preload("res://objects/hud/FinishDim.tscn")
onready var Menu = preload("res://objects/system/menu/Menu.tscn")
onready var PlayerDummy = preload("res://objects/system/menu/PlayerDummy.tscn")

onready var SawLine = preload("res://objects/hazard/SawLine.tscn")

onready var IceGlowEmitter = preload("res://objects/mapelement/IceGlowEmitter.tscn")
onready var IceGlow = preload("res://objects/mapelement/IceGlow.tscn")

onready var Spike = preload("res://objects/hazard/Spike.tscn")

onready var Firefly = preload("res://objects/mapelement/Firefly.tscn")

onready var BirdSound = preload("res://objects/system/BirdSound.tscn")

onready var TouchControl = preload("res://objects/system/TouchControl.tscn")

const Maps = [
	{"chapter": 0, "name":"the journey begins", "path":"res://maps/Map01.tscn"},
	{"chapter": 0, "name":"going up", "path":"res://maps/Map02.tscn"},
	{"chapter": 0, "name":"do not fall", "path":"res://maps/Map03.tscn"},
	{"chapter": 0, "name":"reaching the top", "path":"res://maps/Map04.tscn"},
	{"chapter": 0, "name":"the great tree", "path":"res://maps/Map05.tscn"},
	
	{"chapter": 1, "name":"the great root", "path":"res://maps/Map11.tscn"},
	{"chapter": 1, "name":"cliffhanger", "path":"res://maps/Map12.tscn"},
	{"chapter": 1, "name":"a spiky situation", "path":"res://maps/Map13.tscn"},
	{"chapter": 1, "name":"rollercoaster", "path":"res://maps/Map14.tscn"},
	{"chapter": 1, "name":"u turn", "path":"res://maps/Map15.tscn"},
	
	{"chapter": 2, "name":"resurfaced", "path":"res://maps/Map21.tscn"},
	{"chapter": 2, "name":"climb again", "path":"res://maps/Map22.tscn"},
	{"chapter": 2, "name":"branching out", "path":"res://maps/Map23.tscn"},
	{"chapter": 2, "name":"leap of faith", "path":"res://maps/Map24.tscn"},
	{"chapter": 2, "name":"thorn bush", "path":"res://maps/Map25.tscn"},
	
	{"chapter": 3, "name":"sand in your eyes", "path":"res://maps/Map31.tscn"},
	{"chapter": 3, "name":"ancient monument", "path":"res://maps/Map32.tscn"},
	{"chapter": 3, "name":"the ruins", "path":"res://maps/Map33.tscn"},
	{"chapter": 3, "name":"the trial", "path":"res://maps/Map34.tscn"},
	{"chapter": 3, "name":"hall of the ancient", "path":"res://maps/Map35.tscn"},
	
	{"chapter": 4, "name":"the two towers", "path":"res://maps/Map41.tscn"},
	{"chapter": 4, "name":"at the gate", "path":"res://maps/Map42.tscn"},
	{"chapter": 4, "name":"courtyard", "path":"res://maps/Map43.tscn"},
	{"chapter": 4, "name":"entering the castle", "path":"res://maps/Map44.tscn"},
	{"chapter": 4, "name":"the hallway", "path":"res://maps/Map45.tscn"},
	
	{"chapter": 5, "name":"bottom of the well", "path":"res://maps/Map51.tscn"},
	{"chapter": 5, "name":"in small steps", "path":"res://maps/Map52.tscn"},
	{"chapter": 5, "name":"the great pit", "path":"res://maps/Map53.tscn"},
	{"chapter": 5, "name":"dangerous cellars", "path":"res://maps/Map54.tscn"},
	{"chapter": 5, "name":"grinder", "path":"res://maps/Map55.tscn"},
	
	{"chapter": 6, "name":"follow the light", "path":"res://maps/Map61.tscn"},
	{"chapter": 6, "name":"dangerous depths", "path":"res://maps/Map62.tscn"},
	{"chapter": 6, "name":"crevices", "path":"res://maps/Map63.tscn"},
	{"chapter": 6, "name":"canyon in the deep", "path":"res://maps/Map64.tscn"},
	{"chapter": 6, "name":"light at the end", "path":"res://maps/Map65.tscn"},
	
	{"chapter": 7, "name":"cold reception", "path":"res://maps/Map71.tscn"},
	{"chapter": 7, "name":"ice slide", "path":"res://maps/Map72.tscn"},
	{"chapter": 7, "name":"deadly momentum", "path":"res://maps/Map73.tscn"},
	{"chapter": 7, "name":"ice rift", "path":"res://maps/Map74.tscn"},
	{"chapter": 7, "name":"the final stretch", "path":"res://maps/Map75.tscn"},
]

const PreSlides = [
	{ "leftImage": preload("res://sprites/story/pre_1.png"),"rightImage": preload("res://sprites/story/pre_2.png"), "leftText": "a cozy old oak", "rightText": "i call it home" },
	{ "leftImage": preload("res://sprites/story/pre_3.png"),"rightImage": preload("res://sprites/story/pre_4.png"), "leftText": "my precious egg", "rightText": "fell down below" },
	{ "leftImage": preload("res://sprites/story/pre_5.png"),"rightImage": preload("res://sprites/story/pre_6.png"), "leftText": "wherever you went", "rightText": "i will follow..." }
]
const EndSlides = [
	{ "leftImage": preload("res://sprites/story/post_1.png"),"rightImage": preload("res://sprites/story/post_2.png"), "leftText": "found you cold", "rightText": "but no longer alone" },
	{ "leftImage": preload("res://sprites/story/pre_1.png"),"rightImage": preload("res://sprites/story/post_3.png"), "leftText": "a cozy old oak", "rightText": "we call it home" }
]

const Chapters = [
	{ 
		"title": "the forest",
		"leftImage": preload("res://sprites/story/cha_1a.png"),"rightImage": preload("res://sprites/story/cha_1b.png"),
		"leftText": "into the woods", "rightText": "leaves swirl around"
	},
	{ 
		"title": "the rain",
		"leftImage": preload("res://sprites/story/cha_2a.png"),"rightImage": preload("res://sprites/story/cha_2b.png"),
		"leftText": "rain begins", "rightText": "wetting the ground"
	},
	{ 
		"title": "the plains",
		"leftImage": preload("res://sprites/story/cha_3a.png"),"rightImage": preload("res://sprites/story/cha_3b.png"),
		"leftText": "reached the plains", "rightText": "a perilous land"
	},
	{ 
		"title": "the desert",
		"leftImage": preload("res://sprites/story/cha_4a.png"),"rightImage": preload("res://sprites/story/cha_4b.png"),
		"leftText": "deserts and ruins", "rightText": "covered in sand"
	},
	{ 
		"title": "the castle",
		"leftImage": preload("res://sprites/story/cha_5a.png"),"rightImage": preload("res://sprites/story/cha_5b.png"),
		"leftText": "ancient castle", "rightText": "without a crown"
	},
	{ 
		"title": "the dungeon",
		"leftImage": preload("res://sprites/story/cha_6a.png"),"rightImage": preload("res://sprites/story/cha_6b.png"),
		"leftText": "a spooky dungeon", "rightText": "do not look down"
	},
	{ 
		"title": "the cave",
		"leftImage": preload("res://sprites/story/cha_7a.png"),"rightImage": preload("res://sprites/story/cha_7b.png"),
		"leftText": "underground caves", "rightText": "with lights so nice"
	},
	{ 
		"title": "the mountain",
		"leftImage": preload("res://sprites/story/cha_8a.png"),"rightImage": preload("res://sprites/story/cha_8b.png"),
		"leftText": "on snowy peaks", "rightText": "slipping on ice"
	}
]

onready var PlayerSkins = [
	preload("res://res/player_owl.tres"),
	preload("res://res/player_hedgehog.tres"),
	preload("res://res/player_squirrel.tres"),
	preload("res://res/player_bunny.tres"),
	preload("res://res/player_child.tres")
]
onready var PlayerSkinSuperdark = preload("res://res/player_superdark.tres")
onready var PlayerSkinSuperdarkChild = preload("res://res/player_superdark_child.tres")

onready var ExitLight = preload("res://sprites/exit_2.png")

#Sound
onready var AudioPageflip = [
	preload("res://sounds/book_pageflip_1.ogg"),
	preload("res://sounds/book_pageflip_2.ogg"),
	preload("res://sounds/book_pageflip_3.ogg")
]

onready var AudioDeathPop = [
	preload("res://sounds/death_1.ogg"),
	preload("res://sounds/death_2.ogg"),
	preload("res://sounds/death_3.ogg")
]
onready var AudioDrip = [
	preload("res://sounds/blood_1.ogg"),
	preload("res://sounds/blood_2.ogg"),
	preload("res://sounds/blood_3.ogg"),
	preload("res://sounds/blood_4.ogg"),
	preload("res://sounds/blood_5.ogg")
]
onready var AudioJump = [
	preload("res://sounds/jump_1_1.ogg"),
	preload("res://sounds/jump_1_2.ogg"),
	preload("res://sounds/jump_1_3.ogg")
]
onready var AudioBirds = [
	preload("res://sounds/birds_1.ogg"),
	preload("res://sounds/birds_2.ogg"),
	preload("res://sounds/birds_3.ogg"),
	preload("res://sounds/birds_4.ogg"),
	preload("res://sounds/birds_5.ogg")
]

#Music 
onready var AudioMusicSplash = preload("res://music/splash.ogg")
onready var AudioMusicStoryPre = preload("res://music/story_pre.ogg")
onready var AudioMusicStory = preload("res://music/story.ogg")

onready var AudioMusicChapterForest = preload("res://music/forest.ogg")
onready var AudioMusicChapterRainy = preload("res://music/rainy.ogg")
onready var AudioMusicChapterPlains = preload("res://music/plains.ogg")
onready var AudioMusicChapterDesert = preload("res://music/desert.ogg")
onready var AudioMusicChapterCastle = preload("res://music/castle.ogg")
onready var AudioMusicChapterDungeon = preload("res://music/dungeon.ogg")
onready var AudioMusicChapterCave = preload("res://music/cave.ogg")
onready var AudioMusicChapterCaveEntrance = preload("res://music/caveentrance.ogg")
onready var AudioMusicChapterSnow = preload("res://music/snow.ogg")
