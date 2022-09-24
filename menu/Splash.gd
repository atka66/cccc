extends Node2D

func _ready():
	get_node('/root/Music').play(Res.AudioMusicSplash)
	$Anim.play("splash")

func toGame():
	get_tree().change_scene("res://menu/Story.tscn")
