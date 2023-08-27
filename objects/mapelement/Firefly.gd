extends Node2D

export(Vector2) var origin = Vector2.ZERO

const P_GOTO_ORIGIN = 10



func _on_FlickerTimer_timeout():
	$Light2D.energy = randf() + 0.7
	$FlickerTimer.start(0.15)


func _on_MoveTimer_timeout():
	if (randi() % P_GOTO_ORIGIN == 0):
		global_position = global_position.move_toward(origin, 1)
	else:
		position += Vector2((randi() % 3) - 1, (randi() % 3) - 1)
	$MoveTimer.start(0.1)
