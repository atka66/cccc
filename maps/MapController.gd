extends Node2D

func _ready():
	get_node('/root/Music').mute()
	Global.mapParent = self
	spawnMapName()
	spawnPlayers()
	Global.playersFrozen = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if (!Global.isMenu()):
			Global.add_child(Res.Menu.instance())

func spawnMapName():
	var label = Res.CustomLabel.instance()
	label.position = Vector2(256, 8)
	label.text = Res.Maps[Global.currentMap].name
	label.fontSize = 2
	label.outline = true
	label.aliveTime = 2
	label.alignment = Label.ALIGN_CENTER
	add_child(label)

func spawnPlayers():
	for i in range(4):
		if (Global.playersJoined[i]):
			Global.spawnPlayer(i)
