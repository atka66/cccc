extends RigidBody2D

func _ready():
	var randScale = randf() * 3
	$Poly.rotation = randi() % 90
	$Poly.color.r += (randf() / 5) - 0.1
	$Poly.scale = Vector2(randScale, randScale)
	apply_central_impulse((Vector2(randf(), randf()) - Vector2(0.5, 0.7)) * 2000)
	
	$Timer.wait_time = randf() * 10
	$Timer.start()

func _on_Timer_timeout():
	queue_free()
