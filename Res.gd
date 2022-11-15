extends Node

onready var Player = preload("res://objects/player/Player.tscn")
onready var PlayerCorpse = preload("res://objects/player/PlayerCorpse.tscn")
onready var Spawning = preload("res://objects/player/Spawning.tscn")
onready var BloodPar = preload("res://objects/blood/BloodPar.tscn")
onready var BloodTrail = preload("res://objects/blood/BloodTrail.tscn")

onready var CustomLabel = preload("res://objects/system/label/CustomLabel.tscn")

onready var StartDim = preload("res://objects/hud/MapStartDim.tscn")
onready var FinishDim = preload("res://objects/hud/FinishDim.tscn")
onready var Menu = preload("res://objects/system/menu/Menu.tscn")
onready var PlayerDummy = preload("res://objects/system/menu/PlayerDummy.tscn")

onready var SawLine = preload("res://objects/hazard/SawLine.tscn")

const Maps = [
	{"chapter": 0, "name":"the journey begins", "path":"res://maps/Map01.tscn"},
	{"chapter": 0, "name":"watch your step", "path":"res://maps/Map02.tscn"},
	{"chapter": 0, "name":"going up", "path":"res://maps/Map03.tscn"},
	{"chapter": 0, "name":"reaching the top", "path":"res://maps/Map04.tscn"},
	{"chapter": 0, "name":"inside the great tree", "path":"res://maps/Map05.tscn"},
	
	{"chapter": 1, "name":"at the root of the great tree", "path":"res://maps/Map11.tscn"},
	{"chapter": 1, "name":"cliffhanger", "path":"res://maps/Map12.tscn"},
	{"chapter": 1, "name":"a spiky situation", "path":"res://maps/Map13.tscn"},
	{"chapter": 1, "name":"rollercoaster", "path":"res://maps/Map14.tscn"},
	{"chapter": 1, "name":"u turn", "path":"res://maps/Map15.tscn"},
	
	{"chapter": 2, "name":"resurfaced", "path":"res://maps/Map21.tscn"},
	{"chapter": 2, "name":"todo", "path":"res://maps/Map22.tscn"},
	{"chapter": 2, "name":"todo", "path":"res://maps/Map23.tscn"},
	{"chapter": 2, "name":"leap of faith", "path":"res://maps/Map24.tscn"},
	{"chapter": 2, "name":"thorn bush", "path":"res://maps/Map25.tscn"},
	
	{"chapter": 3, "name":"todo", "path":"res://maps/Map31.tscn"},
	{"chapter": 3, "name":"todo", "path":"res://maps/Map32.tscn"},
	{"chapter": 3, "name":"todo", "path":"res://maps/Map33.tscn"},
	{"chapter": 3, "name":"todo", "path":"res://maps/Map34.tscn"},
	{"chapter": 3, "name":"todo", "path":"res://maps/Map35.tscn"},
	
	{"chapter": 4, "name":"the two towers", "path":"res://maps/Map41.tscn"},
	{"chapter": 4, "name":"at the gate", "path":"res://maps/Map42.tscn"},
	{"chapter": 4, "name":"the bailey", "path":"res://maps/Map43.tscn"},
	{"chapter": 4, "name":"entering the castle", "path":"res://maps/Map44.tscn"},
	{"chapter": 4, "name":"the hallway", "path":"res://maps/Map45.tscn"},
	
	{"chapter": 5, "name":"todo", "path":"res://maps/Map51.tscn"},
	{"chapter": 5, "name":"todo", "path":"res://maps/Map52.tscn"},
	{"chapter": 5, "name":"todo", "path":"res://maps/Map53.tscn"},
	{"chapter": 5, "name":"todo", "path":"res://maps/Map54.tscn"},
	{"chapter": 5, "name":"todo", "path":"res://maps/Map55.tscn"},
]

const PreSlides = [
	{ "leftImage": preload("res://sprites/story/pre_1.png"),"rightImage": preload("res://sprites/story/pre_2.png") },
	{ "leftImage": preload("res://sprites/story/pre_3.png"),"rightImage": preload("res://sprites/story/pre_4.png") },
	{ "leftImage": preload("res://sprites/story/pre_5.png"),"rightImage": preload("res://sprites/story/pre_6.png") }
]
const Chapters = [
	{ 
		"title": "searching in the woods",
		"leftImage": preload("res://sprites/story/cha_1a.png"),"rightImage": preload("res://sprites/story/pre_1.png")
	},
	{ 
		"title": "hit by a huge storm",
		"leftImage": preload("res://sprites/story/cha_2a.png"),"rightImage": preload("res://sprites/story/pre_1.png")
	},
	{ 
		"title": "reaching the plains",
		"leftImage": preload("res://sprites/story/cha_2a.png"),"rightImage": preload("res://sprites/story/pre_1.png")
	},
	{ 
		"title": "wandering the desert",
		"leftImage": preload("res://sprites/story/cha_4a.png"),"rightImage": preload("res://sprites/story/pre_1.png")
	},
	{ 
		"title": "the abandoned castle",
		"leftImage": preload("res://sprites/story/cha_4a.png"),"rightImage": preload("res://sprites/story/pre_1.png")
	},
	{ 
		"title": "a grim dungeon",
		"leftImage": preload("res://sprites/story/cha_4a.png"),"rightImage": preload("res://sprites/story/pre_1.png")
	},
]

onready var PlayerSkins = [
	preload("res://res/player_owl.tres"),
	preload("res://res/player_hedgehog.tres"),
	preload("res://res/player_squirrel.tres"),
	preload("res://res/player_bunny.tres")
]

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

#Music 
onready var AudioMusicSplash = preload("res://music/splash.ogg")
onready var AudioMusicStoryPre = preload("res://music/story_pre.ogg")
onready var AudioMusicStory = preload("res://music/story.ogg")

onready var AudioMusicChapterForest = preload("res://music/forest.ogg")
onready var AudioMusicChapterRainy = preload("res://music/rainy.ogg")
onready var AudioMusicChapterSnow = preload("res://music/snow.ogg")
