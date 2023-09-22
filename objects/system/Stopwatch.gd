extends Node2D

var mapTime = 0.0

func _ready():
	pass # Replace with function body.

func _process(delta):
	if !Global.playersFrozen:
		mapTime += delta * 1000
		$TimeLabel.set_text(Global.formatTime(mapTime, false))
