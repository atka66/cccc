extends TileMap

export(float) var delay = 0.0
export(float) var duration = 2.0

export(bool) var toggled = true

func _ready():
	toggle()
	$Timer.start(delay)


func _on_Timer_timeout():
	toggle()
	$Timer.start(duration)

func toggle():
	$Anim.play("hide" if toggled else "appear")
