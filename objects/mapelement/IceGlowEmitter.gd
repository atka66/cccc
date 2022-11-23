extends Node2D

func _ready():
	startTimer()

func _on_Timer_timeout():
	var glow = Res.IceGlow.instance()
	glow.position = position + Vector2(randi() % 16, (randi() % 16)) 
	Global.mapParent.add_child(glow)
	
	startTimer()

func startTimer():
	$Timer.start(randf())
