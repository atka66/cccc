extends Node2D

func _ready():
	get_node('/root/Music').mute()
	Global.mapParent = self
	spawnPlayers()
	Global.playersFrozen = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if (!Global.isMenu()):
			Global.add_child(Res.Menu.instance())

func spawnPlayers():
	for i in range(4):
		if (Global.playersJoined[i]):
			Global.spawnPlayer(i)
