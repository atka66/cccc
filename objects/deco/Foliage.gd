extends Area2D


func _ready():
	$Sprite.frame = randi() % $Sprite.hframes

func _on_Grass_body_entered(body):
	$Anim.play("bump")
