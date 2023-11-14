extends Node2D

func _ready():
	Global.currentMapTime = 0.0

func _process(delta):
	if !Global.playersFrozen:
		Global.currentMapTime += delta# * 1000
		$TimeLabel.set_text(Global.formatTime(Global.currentMapTime, false))
