extends KinematicBody2D

const SPEED_RUN = 70
const SPEED_JUMP = 1000
const SPEED_JUMPBRAKE = 500
const SPEED_DASH = 800
const GRAVITY = 50
const JUMP_FRAMES = 5
const FRICTION = 0.1

var frozen = false
var right = true
var velocity = Vector2.ZERO
var canJumpFrames = 0
var canDash = true
var isBeingKilled = false
var isWinning = false
var isRunning = false

func _process(delta):
	if (is_on_floor()):
		canJumpFrames = JUMP_FRAMES
	elif (canJumpFrames > 0):
		canJumpFrames -= 1
	
	if (is_on_floor() && abs(velocity.x) > 200):
		$RunParticles.emitting = true
		if (right):
			$RunParticles.direction.x = -1
		else:
			$RunParticles.direction.x = 1
	else:
		$RunParticles.emitting = false

func _physics_process(delta):
	if (!frozen):
		if (is_on_floor()):
			canDash = true
		
		if (!Global.isMenu()):
			_handlePlayerInput()
	
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	velocity.x = lerp(velocity.x, 0, FRICTION if !is_on_floor() else 2 * FRICTION)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if (collision.collider.is_in_group('killer')):
			isBeingKilled = true
	
	if (!frozen && isBeingKilled):
		die()
	
	determineSprite()
	
	if (isRunning):
		if (!$AudioRun.playing):
			$AudioRun.play()
	else:
		$AudioRun.stop()

func determineSprite():
	isRunning = false
	$AnimatedSprite.flip_h = false
	if (!is_on_floor()):
		if (velocity.y < 0):
			$AnimatedSprite.animation = "jump"
		else:
			$AnimatedSprite.animation = "fall"
		if (!right):
			$AnimatedSprite.flip_h = true
	elif (abs(velocity.x) > 30):
		isRunning = true
		$AnimatedSprite.animation = "run"
		if (!right):
			$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.animation = "idle"

func _handlePlayerInput():
	if (Input.is_action_just_pressed("reset")):
		die()

	if (Input.is_action_just_released("ui_up") && velocity.y < 0):
		velocity.y += lerp(0, SPEED_JUMPBRAKE, (-velocity.y) / SPEED_JUMP)
		
	if (Input.is_action_just_pressed("ui_up") && canJumpFrames > 0):
		velocity.y = -SPEED_JUMP
		canJumpFrames = 0
		$JumpParticles.restart()
		$AudioJump.stream = Res.AudioJump[randi() % len(Res.AudioJump)]
		$AudioJump.play()
	
	if (Input.is_action_just_pressed("ui_down") && canDash):
		canDash = false
		velocity.y = -300
		if (right):
			velocity.x += SPEED_DASH
		else:
			velocity.x -= SPEED_DASH
		$JumpParticles.restart()
		$AudioJump.stream = Res.AudioJump[randi() % len(Res.AudioJump)]
		$AudioJump.play()
		
	if (Input.is_action_pressed("ui_left")):
		right = false
		velocity.x -= SPEED_RUN
	if (Input.is_action_pressed("ui_right")):
		right = true
		velocity.x += SPEED_RUN

func die():
	var corpse = Res.PlayerCorpse.instance()
	corpse.position = position
	Global.mapParent.add_child(corpse)
	queue_free()
