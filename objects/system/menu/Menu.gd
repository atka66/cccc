extends Node2D

func _ready():
	$AppearAudio.play()

func _input(event):
	if event.is_action_pressed("quit"):
		Global.saveGame()
		get_tree().quit()
	if event.is_action_pressed("reset"):
		Global.resetGame()
	if event.is_action_pressed("ui_cancel"):
		close()

func close():
	queue_free()
