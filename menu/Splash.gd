extends Node2D

func _ready():
	get_node('/root/Music').play('splash')
	$Anim.play("splash")

func _input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func toGame():
	get_tree().change_scene("res://maps/Map01.tscn")
