extends Area2D

const GRAVITY = 0.2

var velocity = Vector2.ZERO
var drip = false
var stopped = false

func _ready():
	var randScale = (randf()) + 0.5
	$Poly.rotation = randi() % 90
	$Poly.color.r += (randf() / 5) - 0.1
	$Poly.scale = Vector2(randScale, randScale)
	$Trail.color = $Poly.color
	$Trail.scale_amount = randScale * 6
	$Trail.lifetime = (randf() * 10) + 10
	velocity = (Vector2(randf(), randf()) - Vector2(0.5, 0.7)) * 10
	
	$StopTimer.start(randf() * 10)

func _physics_process(delta):
	if !stopped:
		if (drip):
			var velClamp = velocity.clamped(0.19)
			velocity = velClamp
			velocity.y = 0.2
		else:
			velocity.y += GRAVITY
		position += velocity

func _on_StopTimer_timeout():
	stopped = true
	$Trail.emitting = false
	$Poly.hide()
	$DeleteTimer.start($Trail.lifetime)


func _on_BloodTrail_body_entered(body):
	if !stopped && body.is_in_group('leavetrail'):
		drip = true
		$Trail.emitting = true


func _on_BloodTrail_body_exited(body):
	if !stopped && body.is_in_group('leavetrail'):
		drip = false
		$Trail.emitting = false


func _on_DeleteTimer_timeout():
	queue_free()
