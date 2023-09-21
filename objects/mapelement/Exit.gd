extends Area2D

export(bool) var light = false

func _ready():
	if light:
		$Sprite.texture = Res.ExitLight
	else:
		$Anim.play("show")

func _on_Exit_body_entered(body):
	if (body.is_in_group('player') && !Global.playersFrozen):
		body.velocity.x /= 10
		Global.playersFrozen = true
		Global.win()
