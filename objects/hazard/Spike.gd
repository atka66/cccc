extends StaticBody2D

func _on_AnimTimer_timeout():
	$Sprite.frame = 0
	$Sprite.play()
