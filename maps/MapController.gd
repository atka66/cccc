extends Node2D

func _ready():
	Global.mapParent = self
	Global.spawnPlayer()
