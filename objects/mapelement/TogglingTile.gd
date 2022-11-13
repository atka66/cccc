extends TileMap

export(float) var delay = 0.0
export(float) var duration = 2.0

export(bool) var toggled = true

func _ready():
	$Timer.start(delay)


func _on_Timer_timeout():
	match (toggled):
		true:
			$Anim.play("hide")
		false:
			$Anim.play("appear")
	$Timer.start(duration)
