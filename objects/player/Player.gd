extends KinematicBody2D

const SPEED_RUN = 70
const SPEED_RUN_SLIPPERY = 30

const SPEED_JUMP = 1000
const SPEED_JUMP_SLIPPERY = 300

const SPEED_JUMPBRAKE = 500
const SPEED_DASH = 800
const JUMP_FRAMES = 5

const FRICTION = 0.1
const FRICTION_SLIPPERY = 0.01

const SLEEP_TIME = 10

var positions = []

export var playerId : int = 0

var inputMaps = {}
var right = true
var velocity = Vector2.ZERO
var canJumpFrames = 0
var canDash = true
var isBeingKilled = false
var isWinning = false
var isRunning = false

var currSpeedRun = SPEED_RUN
var currSpeedJump = SPEED_JUMP
var currFriction = FRICTION

func _ready():
	var isSuperdark = len(get_tree().get_nodes_in_group("superdark")) > 0
	
	if (playerId != 2 || isSuperdark):
		$SquirrelTail.hide()
	if (playerId != 3 || isSuperdark):
		$BunnyEars.hide()
	
	setupInputMaps()
	
	$SleepTimer.start(SLEEP_TIME)

	if isSuperdark:
		$Sprite.frames = Res.PlayerSkinSuperdark
	else:
		$Sprite.frames = Res.PlayerSkins[playerId]
	
	if Global.gameFinished && playerId == 0:
		var child = Res.PlayerChild.instance()
		child.position = position + Vector2(-4, 0)
		child.mommy = self
		Global.mapParent.add_child(child)

func setupInputMaps():
	match str(Global.playersControlScheme[playerId]):
		'0':
			inputMaps = {
				"left" : "left_1",
				"right" : "right_1",
				"jump" : "jump_1",
				"dash" : "dash_1",
				"death" : "death_1"
			}
		'1':
			inputMaps = {
				"left" : "left_2",
				"right" : "right_2",
				"jump" : "jump_2",
				"dash" : "dash_2",
				"death" : "death_2"
			}
		_:
			inputMaps = {
				"left" : "left_gamepad",
				"right" : "right_gamepad",
				"jump" : "jump_gamepad",
				"dash" : "dash_gamepad",
				"death" : "death_gamepad"
			}

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
	if playerId == 0:
		positions.push_back(position)
		if len(positions) > 5:
			positions.pop_front()
	
	if (!Global.playersFrozen):
		if (is_on_floor()):
			canDash = true
		
		if (!Global.isMenu()):
			_handlePlayerInput()
	
	velocity.y += Global.GRAVITY
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	velocity.x = lerp(velocity.x, 0, currFriction if !is_on_floor() else 2 * currFriction)
	
	if is_on_floor():
		setSlippery(false)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if (collision.collider.is_in_group('killer')):
			isBeingKilled = true
		if (collision.collider.is_in_group('slippery')) && is_on_floor():
			setSlippery(true)
	
	if (!Global.playersFrozen && isBeingKilled):
		die(true)
	
	determineSprite()
	
	if (isRunning):
		if (!$AudioRun.playing):
			$AudioRun.play()
	else:
		$AudioRun.stop()

	if ($SleepTimer.time_left > 0 && $SleepParticles.emitting):
		$SleepParticles.emitting = false
	if ($SleepTimer.time_left == 0 && !$SleepParticles.emitting):
		$SleepParticles.emitting = true

func determineSprite():
	isRunning = false
	
	match playerId:
		0, 2, 3:
			$Sprite.flip_h = false
			if (!is_on_floor()):
				if (velocity.y < 0):
					$Sprite.animation = "jump"
				else:
					$Sprite.animation = "fall"
				if (!right):
					$Sprite.flip_h = true
			elif (abs(velocity.x) > 30):
				isRunning = true
				$Sprite.animation = "run"
				if (!right):
					$Sprite.flip_h = true
			elif ($SleepTimer.time_left > 0):
				$Sprite.animation = "idle"
			else:
				$Sprite.animation = "sleep"
		1:
			if (!is_on_floor()):
				$Sprite.animation = "roll"
			elif (abs(velocity.x) > 30):
				isRunning = true
				$Sprite.animation = "roll"
			elif ($SleepTimer.time_left > 0):
				$Sprite.animation = "idle"
			else:
				$Sprite.animation = "sleep"

			if ($Sprite.animation == "roll"):
				$Sprite.rotate(velocity.x / 500)
			else:
				$Sprite.rotation = 0

func _handlePlayerInput():
	if (Input.is_action_just_pressed(inputMaps["death"])):
		die(true)

	if (Input.is_action_just_released(inputMaps["jump"]) && velocity.y < 0):
		velocity.y += lerp(0, SPEED_JUMPBRAKE, (-velocity.y) / currSpeedJump)

	if (Input.is_action_just_pressed(inputMaps["jump"]) && canJumpFrames > 0):
		velocity.y = -currSpeedJump
		canJumpFrames = 0
		$JumpParticles.restart()
		$AudioJump.stream = Res.AudioJump[randi() % len(Res.AudioJump)]
		$AudioJump.play()
		$SleepTimer.start(SLEEP_TIME)
	
	if (Input.is_action_just_pressed(inputMaps["dash"]) && canDash):
		canDash = false
		velocity.y = -300
		if (right):
			velocity.x += SPEED_DASH
		else:
			velocity.x -= SPEED_DASH
		$JumpParticles.restart()
		$AudioJump.stream = Res.AudioJump[randi() % len(Res.AudioJump)]
		$AudioJump.play()
		$SleepTimer.start(SLEEP_TIME)
		
	if (Input.is_action_pressed(inputMaps["left"])):
		right = false
		velocity.x -= currSpeedRun
		$SleepTimer.start(SLEEP_TIME)
	if (Input.is_action_pressed(inputMaps["right"])):
		right = true
		velocity.x += currSpeedRun
		$SleepTimer.start(SLEEP_TIME)

func die(count : bool):
	if count: 
		Global.deathCnt[playerId] += 1
		Global.saveGame()
	var corpse = Res.PlayerCorpse.instance()
	corpse.playerId = playerId
	corpse.position = position
	Global.mapParent.add_child(corpse)
	queue_free()

func setSlippery(slippery : bool):
	if slippery:
		currSpeedRun = SPEED_RUN_SLIPPERY
		currSpeedJump = SPEED_JUMP_SLIPPERY
		currFriction = FRICTION_SLIPPERY
	else:
		currSpeedRun = SPEED_RUN
		currSpeedJump = SPEED_JUMP
		currFriction = FRICTION
