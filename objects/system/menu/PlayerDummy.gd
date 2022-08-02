extends Node2D

export var playerId : int = 0

func _ready():
	if (playerId != 2):
		$SquirrelTail.hide()
	if (playerId != 3):
		$BunnyEars.hide()
	
	$Sprite.frames = Res.PlayerSkins[playerId]

func wakeup():
	modulate.a = 1.0
	$Sprite.animation = "idle"

func sleep():
	modulate.a = 0.3
	$Sprite.animation = "sleep"
