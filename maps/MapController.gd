extends Node2D

var firstTick = true

func _ready():
	if OS.has_touchscreen_ui_hint():
		add_child(Res.TouchControl.instance())
	
	Global.mapParent = self
	spawnPlayers()
	Global.playersFrozen = false
	add_child(Res.StartDim.instance())
	
	if has_node("IceTiles"):
		makeIceTilesGlow()
	
	if has_node("Spikes"):
		spawnSpikes()

func _process(delta):
	if Input.is_action_just_pressed("menu") && !firstTick:
		if (!Global.playersFrozen && !Global.isMenu()):
			Global.add_child(Res.Menu.instance())
	if firstTick:
		firstTick = false

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

func spawnSpikes():
	for cellpos in $Spikes.get_used_cells():
		var cell = $Spikes.get_cellv(cellpos)
		if cell >= 15 && cell <= 18:
			var spikePos = to_global($Spikes.map_to_world(cellpos))
			var spike = Res.Spike.instance()
			spike.global_position = (spikePos + Vector2(16, 16)) / scale
			if cell == 16:
				spike.rotation_degrees = 90
			if cell == 17:
				spike.rotation_degrees = 180
			if cell == 18:
				spike.rotation_degrees = 270
			
			add_child(spike)
			$Spikes.set_cellv(cellpos, -1)
