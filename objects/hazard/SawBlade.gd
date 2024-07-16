extends Node2D

export(Array, Vector2) var path
export(int) var speed = 0

var velocity = Vector2.ZERO
var targetPosIndex = 1

func _ready():
	$SawBlade/Delay.start(randf())

	if path:
		path.push_front(Vector2(0, 0))
		for i in range(len(path) - 1):
			drawSawLine(path[i], path[i + 1])
		if len(path) > 1:
			drawSawLine(path[len(path) - 1], path[0])

func drawSawLine(start: Vector2, end: Vector2):
	var sawLine = Res.SawLine.instance()
	sawLine.position = start
	sawLine.destination = end - start
	add_child(sawLine)

func _process(delta):
	$SawBlade/SpinningSprite.position = Vector2((randi() % 2) - 1, (randi() % 2) - 1)
	
func _physics_process(delta):
	if path:
		velocity = $SawBlade.position.direction_to(path[targetPosIndex]) * (speed * 0.7)
		if $SawBlade.position.distance_to(path[targetPosIndex]) < speed:
			targetPosIndex = (targetPosIndex + 1) % len(path) 
		$SawBlade.position += velocity

func _on_Delay_timeout():
	$SawBlade/Anim.play("anim")
