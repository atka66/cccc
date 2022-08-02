extends Node2D

export var playerId : int = 0
var playerSkin : int = 0

func _ready():
	playerSkin = Global.playersSkins[playerId]
	if (playerSkin != 2):
		$SquirrelTail.hide()
	if (playerSkin != 3):
		$BunnyEars.hide()
	
	$Sprite.frames = Res.PlayerSkins[playerSkin]

func wakeup():
	modulate.a = 1.0
	$Sprite.animation = "idle"

func sleep():
	modulate.a = 0.3
	$Sprite.animation = "sleep"
