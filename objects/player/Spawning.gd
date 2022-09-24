extends Node2D

export var deathCnt : int = 0

func _ready():
	$DeathCntLabel.set_text(str(deathCnt))
