extends Node2D

func _on_FlickerTimer_timeout():
	$Light2D.energy = randf() + 0.5
	$FlickerTimer.start(0.1)
