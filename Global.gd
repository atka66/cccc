extends Node

const SAVE_PATH = "user://cccc.sav"

var showWholeStory = true
var mapParent = null
var currentMap = 0

var playersJoined = [true, false, false, false]

var deathCnt = [0, 0, 0, 0]

# 0 : WASD
# 1 : arrow keys
# 2-5 : controllers
var playersControlScheme = [0, -1, -1, -1]
var playersFrozen = false

func _ready():
	randomize()
	loadGame()

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

func gotoNextMap():
	var finishedChapter = Res.Maps[currentMap].chapter
	currentMap += 1
	saveGame()
	if Res.Maps[currentMap].chapter > finishedChapter:
		get_tree().change_scene("res://menu/Story.tscn")
	else:
		gotoMap(currentMap)

func gotoMap(i):
	get_tree().change_scene(Res.Maps[i].path)

func resetGame():
	closeMenu()
	deleteSave()
	showWholeStory = true
	currentMap = 0
	deathCnt = [0, 0, 0, 0]
	get_tree().change_scene("res://menu/Story.tscn")

func gotoCurrentMap():
	gotoMap(currentMap)

func saveGame():
	var gameState = {
		'currentMap' : currentMap,
		'joined' : playersJoined,
		'control' : playersControlScheme,
		'deathCnt' : deathCnt
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

func deleteSave():
	var file = Directory.new()
	file.remove(SAVE_PATH)

func isMenu():
	return len(get_tree().get_nodes_in_group("menu")) > 0

func closeMenu():
	if (isMenu()):
		get_tree().get_nodes_in_group("menu")[0].close()
