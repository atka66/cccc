extends StaticBody2D

func _ready():
	$Delay.start(randf())

func _process(delta):
	$SpinningSprite.position = Vector2((randi() % 2) - 1, (randi() % 2) - 1)

func _on_Delay_timeout():
	$Anim.play("anim")
