extends AnimatedSprite

func _ready():
	play()

func _on_IceGlow_animation_finished():
	queue_free()
