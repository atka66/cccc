extends Node2D

func _ready():
	$QuitPrompt.hide()
	$AppearAudio.stream = Res.AudioPageflip[randi() % len(Res.AudioPageflip)]
	$AppearAudio.play()

func _input(event):
	if $QuitPrompt.visible:
		if event.is_action_pressed("quit"):
			Global.saveGame()
			get_tree().quit()
		if event.is_action_pressed("ui_cancel"):
			$QuitPrompt.hide()
	else:
		if event.is_action_pressed("quit"):
			$QuitPrompt.show()
			$QuitPrompt/Anim.play("appear")
		if event.is_action_pressed("reset"):
			Global.resetGame()
		if event.is_action_pressed("ui_cancel"):
			close()

func close():
	queue_free()
