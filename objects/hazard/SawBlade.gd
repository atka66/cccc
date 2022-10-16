extends StaticBody2D

func _process(delta):
	$SpinningSprite.position = Vector2((randi() % 2) - 1, (randi() % 2) - 1)
