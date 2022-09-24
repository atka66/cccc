extends Node2D

func _ready():
	Global.mapParent = self
	spawnPlayers()
	Global.playersFrozen = false
	add_child(Res.StartDim.instance())

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if (!Global.isMenu()):
			Global.add_child(Res.Menu.instance())

func spawnPlayers():
	for i in range(4):
		if (Global.playersJoined[i]):
			Global.spawnPlayer(i, true)
