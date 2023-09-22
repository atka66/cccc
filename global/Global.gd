extends Node

const SAVE_PATH = "user://cccc.sav"
const VERSION = '1.3.0'

var showWholeStory: bool = true
var mapParent = null
var gameFinished: bool = false

var currentMap: int = 0
var actualMap: int = 0

var playersJoined: Array[bool] = [true, false, false, false]
var audio: int = 0

var deathCnt: Array[int] = [0, 0, 0, 0]

# 0 : WASD
# 1 : arrow keys
# 2-5 : controllers
var playersControlScheme: Array[int] = [0, -1, -1, -1]
var joyConnected: Array[bool] = [false, false, false, false]
var playersFrozen: bool = false

func _ready():
	initJoys()
	Input.connect("joy_connection_changed", _joy_connection_changed)
	
	randomize()
	loadGame()
	updateAudio()
	gameFinished = currentMap >= len(Res.Maps)
	
	# todo phone mode

func _joy_connection_changed(id: int, connected: bool) -> void:
	if id < joyConnected.size() && connected:
		joyConnected[id] = true

func initJoys() -> void:
	var joys: Array[int] = Input.get_connected_joypads()
	for i in range(joyConnected.size()):
		if joys.has(i):
			joyConnected[i] = true

func updateAudio() -> void:
	match int(audio):
		0:
			setMute(false, false)
		1:
			setMute(false, true)
		2:
			setMute(true, false)
		3:
			setMute(true, true)

func setMute(musicMute: bool, soundMute: bool):
	var musicBus: int = AudioServer.get_bus_index("Music")
	var soundBus: int = AudioServer.get_bus_index("Sound")
	AudioServer.set_bus_mute(musicBus, musicMute)
	AudioServer.set_bus_mute(soundBus, soundMute)

func spawnPlayer(playerId: int, silent: bool) -> void:
	if !Global.playersJoined[playerId]:
		return
	for player in get_tree().get_nodes_in_group("player"):
		if player.playerId == playerId:
			return
	var player = Res.Player.instantiate()
	player.position = get_tree().get_nodes_in_group("spawn")[0].position
	player.position.x += (playerId - 1) * 8
	player.playerId = playerId
	mapParent.add_child(player)
	
	if !silent:
		var spawning = Res.Spawning.instantiate()
		spawning.position = player.position
		spawning.deathCnt = Global.deathCnt[playerId]
		mapParent.add_child(spawning)

func togglePlayer(playerId: int) -> void:
	if !Global.playersJoined[playerId]:
		Global.playersJoined[playerId] = true
		rollNextControlScheme(playerId, 0)
	else:
		rollNextControlScheme(playerId, Global.playersControlScheme[playerId])
		for player in get_tree().get_nodes_in_group("player"):
			if player.playerId == playerId:
				player.setupInputMaps()
		if Global.playersControlScheme[playerId] > 5:
			Global.playersJoined[playerId] = false
			Global.playersControlScheme[playerId] = -1
	
	if (Global.playersJoined[playerId]):
		spawnPlayer(playerId, false)
	else:
		for player in get_tree().get_nodes_in_group("player"):
			if player.playerId == playerId:
				player.die(false)
	saveGame()

func rollNextControlScheme(playerId: int, from: int) -> void:
	var tmpScheme = from
	while Global.playersControlScheme.has(tmpScheme):
		tmpScheme += 1
	Global.playersControlScheme[playerId] = tmpScheme

func win() -> void:
	closeMenu()
	var dim = Res.FinishDim.instance()
	getMap().add_child(dim)

func getMap() -> Node:
	return get_tree().get_nodes_in_group('map')[0]

func gotoNextMap() -> void:
	actualMap += 1
	
	var gameJustFinished: bool = false
	
	if !gameFinished:
		if actualMap >= len(Res.Maps):
			gameFinished = true
			gameJustFinished = true
	
	if gameJustFinished: # the game just finished
		currentMap = len(Res.Maps)
		saveGame()
		get_tree().change_scene("res://menu/Story.tscn")
	elif actualMap >= len(Res.Maps): # finished the last level (the game was already finished)
		gotoMap(0)
	elif actualMap >= currentMap: # regular map progression
		var finishedChapter: int = Res.Maps[currentMap].chapter
		currentMap = actualMap
		saveGame()
		if Res.Maps[actualMap].chapter > finishedChapter: # play cutscene since we finished a chapter
			get_tree().change_scene("res://menu/Story.tscn")
		else: # cutsceneless map progression
			gotoMap(actualMap)
	else: # map progression while the game is finished (doesn't get saved)
		gotoMap(actualMap)

func gotoMap(i) -> void:
	actualMap = i
	get_tree().change_scene(Res.Maps[i].path)

func resetGame() -> void:
	closeMenu()
	Global.mapParent = null
	gameFinished = false
	showWholeStory = true
	currentMap = 0
	actualMap = 0
	deathCnt = [0, 0, 0, 0]
	saveGame()
	get_tree().change_scene("res://menu/Story.tscn")

func gotoCurrentMap() -> void:
	gotoMap(currentMap)

func saveGame() -> void:
	var gameState = {
		'currentMap' : currentMap,
		'joined' : playersJoined,
		'control' : playersControlScheme,
		'deathCnt' : deathCnt,
		'audio' : audio
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_line(JSON.stringify(gameState))
	file.close()

func loadGame() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var gameState = JSON.parse_string(file.get_line())
		if (gameState.has('currentMap')):
			currentMap = gameState['currentMap']
		if (gameState.has('joined')):
			playersJoined = gameState['joined']
		if (gameState.has('control')):
			var scheme = []
			for i in gameState['control']:
				scheme.append(int(i))
			playersControlScheme = scheme
		if (gameState.has('deathCnt')):
			deathCnt = gameState['deathCnt']
		if (gameState.has('audio')):
			audio = gameState['audio']

func isMenu() -> bool:
	return len(get_tree().get_nodes_in_group("menu")) > 0

func closeMenu() -> void:
	if (isMenu()):
		get_tree().get_nodes_in_group("menu")[0].close()

func getMenu() -> Node:
	return get_tree().get_nodes_in_group("menu")[0]

func getBgOffsetForActualMap():
	var determRandom = RandomNumberGenerator.new()
	determRandom.set_seed(actualMap)
	return -(determRandom.randi() % 500) - 20
