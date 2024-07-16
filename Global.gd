extends Node

const SAVE_PATH = "user://cccc.sav"
const VERSION = '1.2.10'

const GRAVITY = 32

var showWholeStory = true
var mapParent = null
var currentMap = 0
var actualMap = 0
var gameFinished : bool = false

var playersJoined = [true, false, false, false]
var audio = 0
var times = []

var deathCnt = [0, 0, 0, 0]

# 0 : arrow keys
# 1 : WASD
# 2-5 : controllers
var playersControlScheme = [0, -1, -1, -1]
var joyConnected = [false, false, false, false]
var playersFrozen = false

var phoneMode = OS.has_touchscreen_ui_hint()

func _ready():
	initJoys()
	Input.connect("joy_connection_changed", self, "_joy_connection_changed")
	
	randomize()
	loadGame()
	if !times or times.size() != 40:
		resetTimes()
	updateAudio()
	gameFinished = currentMap >= len(Res.Maps)
	
	if phoneMode:
		add_child(Res.TouchControl.instance())

func resetTimes():
	times = []
	for i in range(40):
		times.append(0)

func _joy_connection_changed(id, connected):
	if id < joyConnected.size() && connected:
			joyConnected[id] = true

func initJoys():
	var joys = Input.get_connected_joypads()
	for i in range(joyConnected.size()):
		if joys.has(i):
			joyConnected[i] = true


func updateAudio():
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
	var musicBus = AudioServer.get_bus_index("Music")
	var soundBus = AudioServer.get_bus_index("Sound")
	AudioServer.set_bus_mute(musicBus, musicMute)
	AudioServer.set_bus_mute(soundBus, soundMute)

func spawnPlayer(playerId, silent : bool):
	if !Global.playersJoined[playerId]:
		return
	for player in get_tree().get_nodes_in_group("player"):
		if player.playerId == playerId:
			return
	var player = Res.Player.instance()
	player.position = get_tree().get_nodes_in_group("spawn")[0].position
	player.position.x += (playerId - 1) * 8
	player.playerId = playerId
	mapParent.add_child(player)
	
	if !silent:
		var spawning = Res.Spawning.instance()
		spawning.position = player.position
		spawning.deathCnt = Global.deathCnt[playerId]
		mapParent.add_child(spawning)

func togglePlayer(playerId):
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

func rollNextControlScheme(playerId, from):
	var tmpScheme = from
	while Global.playersControlScheme.has(tmpScheme):
		tmpScheme += 1
	Global.playersControlScheme[playerId] = tmpScheme

func win():
	closeMenu()
	var dim = Res.FinishDim.instance()
	getMap().add_child(dim)

func getMap():
	return get_tree().get_nodes_in_group('map')[0]

func saveTimeToMap():
	if times[actualMap] == 0 or Stopwatch.currentMapTime < times[actualMap]:
		times[actualMap] = Stopwatch.currentMapTime
	saveGame()

func gotoNextMap():
	actualMap += 1
	
	var gameJustFinished = false
	
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
		var finishedChapter = Res.Maps[currentMap].chapter
		currentMap = actualMap
		saveGame()
		if Res.Maps[actualMap].chapter > finishedChapter: # play cutscene since we finished a chapter
			get_tree().change_scene("res://menu/Story.tscn")
		else: # cutsceneless map progression
			gotoMap(actualMap)
	else: # map progression while the game is finished (doesn't get saved)
		gotoMap(actualMap)

func gotoMap(i):
	actualMap = i
	Stopwatch.resetStopwatch()
	get_tree().change_scene(Res.Maps[i].path)

func resetGame():
	closeMenu()
	deleteSave()
	Global.mapParent = null
	gameFinished = false
	showWholeStory = true
	currentMap = 0
	actualMap = 0
	deathCnt = [0, 0, 0, 0]
	resetTimes()
	get_tree().change_scene("res://menu/Story.tscn")

func gotoCurrentMap():
	gotoMap(currentMap)

func saveGame():
	var gameState = {
		'currentMap' : currentMap,
		'joined' : playersJoined,
		'control' : playersControlScheme,
		'deathCnt' : deathCnt,
		'audio' : audio,
		'times' : times
	}
	var file = File.new()
	file.open(SAVE_PATH, File.WRITE)
	file.store_line(to_json(gameState))
	file.close()

func loadGame():
	var file = File.new()
	if file.file_exists(SAVE_PATH):
		file.open(SAVE_PATH, File.READ)
		var gameState = parse_json(file.get_line())
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
		if (gameState.has('times')):
			var tmp = []
			for i in gameState['times']:
				tmp.append(float(i))
			times = tmp

func deleteSave():
	var file = Directory.new()
	file.remove(SAVE_PATH)

func isMenu():
	return len(get_tree().get_nodes_in_group("menu")) > 0

func closeMenu():
	if (isMenu()):
		get_tree().get_nodes_in_group("menu")[0].close()

func getMenu():
	return get_tree().get_nodes_in_group("menu")[0]

func getOffsetForActualMap():
	var determRandom = RandomNumberGenerator.new()
	determRandom.set_seed(actualMap)
	return -(determRandom.randi() % 500) - 20
	
func formatTime(totalTime: float, withHours: bool) -> String:
	var millis: int = fmod(totalTime, 1.0) * 10
	var seconds: int = fmod(totalTime, 60.0)
	if withHours:
		var minutes: int = int(totalTime / 60.0) % 60
		var hours: int = int(totalTime / 3600.0)
		return "%d:%02d:%02d.%01d" % [hours, minutes, seconds, millis]
	else:
		var minutes: int = int(totalTime / 60.0)
		return "%d:%02d.%01d" % [minutes, seconds, millis]

func getTotalTime():
	var result = 0.0
	for i in times:
		result += i
	return result

func getTotalDeaths():
	var result = 0
	for i in deathCnt:
		result += i
	return result
