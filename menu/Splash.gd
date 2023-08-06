extends Node2D

func _ready():
	# delayed start for browser
	yield(get_tree().create_timer(1.0), "timeout")
	get_node('/root/Music').play(Res.AudioMusicSplash)
	$Anim.play("splash")

func _input(event):
	if event.is_action_pressed("skip"):
		toGame()

func toGame():
	get_tree().change_scene("res://menu/Story.tscn")
