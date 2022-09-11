extends Node

onready var Player = preload("res://objects/player/Player.tscn")
onready var PlayerCorpse = preload("res://objects/player/PlayerCorpse.tscn")
onready var BloodPar = preload("res://objects/blood/BloodPar.tscn")
onready var BloodTrail = preload("res://objects/blood/BloodTrail.tscn")

onready var CustomLabel = preload("res://objects/system/label/CustomLabel.tscn")

onready var StartDim = preload("res://objects/hud/MapStartDim.tscn")
onready var FinishDim = preload("res://objects/hud/FinishDim.tscn")
onready var Menu = preload("res://objects/system/menu/Menu.tscn")
onready var PlayerDummy = preload("res://objects/system/menu/PlayerDummy.tscn")

var Maps = [
	{"name":"the journey begins", "path":"res://maps/Map01.tscn"},
	{"name":"going up", "path":"res://maps/Map03.tscn"},
	{"name":"the pits", "path":"res://maps/Map02.tscn"},
	{"name":"a spiky situation", "path":"res://maps/Map07.tscn"},
	{"name":"rollercoaster of emotions", "path":"res://maps/Map04.tscn"},
	{"name":"duodenum", "path":"res://maps/Map05.tscn"},
	{"name":"cliff hanger", "path":"res://maps/Map06.tscn"},
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
