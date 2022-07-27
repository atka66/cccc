extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("toggle_player_1"):
		Global.playersJoined[0] = !Global.playersJoined[0]
	if event.is_action_pressed("toggle_player_2"):
		Global.playersJoined[1] = !Global.playersJoined[1]
	if event.is_action_pressed("toggle_player_3"):
		Global.playersJoined[2] = !Global.playersJoined[2]
	if event.is_action_pressed("toggle_player_4"):
		Global.playersJoined[3] = !Global.playersJoined[3]
	
	if event.is_action_pressed("quit"):
		Global.saveGame()
		get_tree().quit()
	if event.is_action_pressed("reset"):
		Global.resetGame()
	if event.is_action_pressed("ui_cancel"):
		close()

func close():
	queue_free()
