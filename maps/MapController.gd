extends Node2D

func _ready():
	Global.mapParent = self
	spawnPlayers()
	Global.playersFrozen = false
	add_child(Res.StartDim.instance())
	
	if has_node("IceTiles"):
		makeIceTilesGlow()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if (!Global.isMenu()):
			Global.add_child(Res.Menu.instance())

func spawnPlayers():
	for i in range(4):
		if (Global.playersJoined[i]):
			Global.spawnPlayer(i, true)

func makeIceTilesGlow():
	for cell in $IceTiles.get_used_cells():
		var glowPos = to_global($IceTiles.map_to_world(cell))
		var emitter = Res.IceGlowEmitter.instance()
		emitter.global_position = glowPos / scale
		add_child(emitter)
