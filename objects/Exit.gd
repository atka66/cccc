extends Area2D

func _on_Exit_body_entered(body):
	if (body.is_in_group('player') && !Global.playersFrozen):
		body.velocity.x /= 10
		Global.playersFrozen = true
		Global.win()
