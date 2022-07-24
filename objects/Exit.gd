extends Area2D

func _on_Exit_body_entered(body):
	if (body.is_in_group('player') && !body.frozen):
		body.velocity.x /= 10
		body.frozen = true
		Global.win()
