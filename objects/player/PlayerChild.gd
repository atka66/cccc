extends KinematicBody2D

const SLEEP_TIME = 10.3

var velocity = Vector2.ZERO
var right = true
var isRunning = false
var isJumping = false

var mommy = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if len(get_tree().get_nodes_in_group("superdark")) > 0:
		$Sprite.frames = Res.PlayerSkinSuperdarkChild
	
	$SleepTimer.start(SLEEP_TIME)

func _physics_process(delta):
	if is_instance_valid(mommy):
		if len(mommy.positions) > 4:
			var newPosition = mommy.positions[0] + Vector2(-5, 0)
			velocity = newPosition - position
			position = newPosition
		determineSprite()
	else:
		queue_free()
		
	if ($SleepTimer.time_left > 0 && $SleepParticles.emitting):
		$SleepParticles.emitting = false
	if ($SleepTimer.time_left == 0 && !$SleepParticles.emitting):
		$SleepParticles.emitting = true


func determineSprite():
	$Sprite.flip_h = false
	right = velocity.x > 0
	isRunning = abs(velocity.x) > 1
	isJumping = abs(velocity.y) > 1
			
	var awake = true
	if isJumping:
		$Sprite.flip_h = !right
		if velocity.y < 0:
			$Sprite.animation = "jump"
		else:
			$Sprite.animation = "fall"
	elif isRunning:
		$Sprite.flip_h = !right
		$Sprite.animation = "run"
	elif ($SleepTimer.time_left > 0):
		$Sprite.animation = "idle"
		awake = false
	else:
		$Sprite.animation = "sleep"
		awake = false

	if awake:
		$SleepTimer.start(SLEEP_TIME)
