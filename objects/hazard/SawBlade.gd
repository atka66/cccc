extends StaticBody2D

export(Array, Vector2) var path
export(int) var speed = 0

var velocity = Vector2.ZERO
var targetPosIndex = 1

func _ready():
	$Delay.start(randf())

func _process(delta):
	$SpinningSprite.position = Vector2((randi() % 2) - 1, (randi() % 2) - 1)
	
func _physics_process(delta):
	if path:
		velocity = position.direction_to(path[targetPosIndex]) * speed
		if position.distance_to(path[targetPosIndex]) < speed:
			targetPosIndex = (targetPosIndex + 1) % len(path) 
		position += velocity

func _on_Delay_timeout():
	$Anim.play("anim")
