extends Node2D

func _ready():
	get_node('/root/Music').mute()
	Global.mapParent = self
	Global.spawnPlayer()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if (!Global.isMenu()):
			Global.add_child(Res.Menu.instance())
