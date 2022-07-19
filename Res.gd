extends Node

onready var Player = preload("res://objects/Player.tscn")
onready var PlayerCorpse = preload("res://objects/PlayerCorpse.tscn")
onready var BloodPar = preload("res://objects/blood/BloodPar.tscn")
onready var BloodTrail = preload("res://objects/blood/BloodTrail.tscn")

onready var FinishDim = preload("res://objects/hud/FinishDim.tscn")

var MapPaths = [
	"res://maps/Map01.tscn",
	"res://maps/Map02.tscn",
	"res://maps/Map03.tscn",
	"res://maps/Map04.tscn",
]
