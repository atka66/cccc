extends Node2D

export var playerId : int = 0

func _ready():
	if (playerId != 2):
		$SquirrelTail.hide()
	if (playerId != 3):
		$BunnyEars.hide()
	
	$Sprite.frames = Res.PlayerSkins[playerId]

func wakeup():
	modulate = Color(1.0, 1.0, 1.0)
	$Sprite.animation = "idle"

func sleep():
	modulate = Color(0.4, 0.4, 0.4)
	$Sprite.animation = "sleep"
