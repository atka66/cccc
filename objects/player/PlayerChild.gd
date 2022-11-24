extends KinematicBody2D

var velocity = Vector2.ZERO
var right = true
var isRunning = false
var isJumping = false

var mommy = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if len(mommy.positions) > 4:
		var newPosition = mommy.positions[0] + Vector2(-5, 0)
		velocity = newPosition - position
		position = newPosition
	
	determineSprite()

func _process(delta):
	if !is_instance_valid(mommy):
		queue_free()

func determineSprite():
	$Sprite.flip_h = false
	right = velocity.x > 0
	isRunning = abs(velocity.x) > 1
	isJumping = abs(velocity.y) > 1
			
	if isJumping:
		$Sprite.flip_h = !right
		if velocity.y < 0:
			$Sprite.animation = "jump"
		else:
			$Sprite.animation = "fall"
	elif isRunning:
		$Sprite.flip_h = !right
		$Sprite.animation = "run"
	else:
		$Sprite.animation = "idle"
