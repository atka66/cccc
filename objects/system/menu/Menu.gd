extends Node2D

func _ready():
	$VersionLabel.set_text('v' + Global.VERSION)
	$MapPrompt.hide()
	$ResetPrompt.hide()
	$AppearAudio.stream = Res.AudioPageflip[randi() % len(Res.AudioPageflip)]
	$AppearAudio.play()

func _input(event):
	if $MapPrompt.visible:
		if event.is_action_pressed("ui_cancel"):
			$MapPrompt.hide()
	elif $ResetPrompt.visible:
		if event.is_action_pressed("reset"):
			Global.resetGame()
		if event.is_action_pressed("ui_cancel"):
			$ResetPrompt.hide()
	else:
		if event.is_action_pressed("map"):
			$MapPrompt.show()
		if event.is_action_pressed("reset"):
			$ResetPrompt.show()
			$ResetPrompt/Anim.play("appear")
		if event.is_action_pressed("ui_cancel"):
			close()

func close():
	queue_free()
