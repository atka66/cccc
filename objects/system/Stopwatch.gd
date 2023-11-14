extends Node2D

var currentMapTime = 0.0

func _ready():
	currentMapTime = 0.0

func _process(delta):
	if !Global.playersFrozen:
		currentMapTime += delta
		pass

func resetStopwatch():
	currentMapTime = 0.0
