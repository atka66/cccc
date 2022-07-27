extends Node

const SAVE_PATH = "user://cccc.sav"

var mapParent = null
var currentMap = 0

var playersJoined = [true, false, false, false]
var playersSkins = [0, 1 ,0, 1]

# 0 : WASD
# 1 : arrow keys
# 2-5 : controllers
var playersControlScheme = [0, 1, 2, 3]
var playersFrozen = false

func _ready():
	randomize()
	loadGame()

func spawnPlayer(playerId):
	var player = Res.Player.instance()
	player.position = get_tree().get_nodes_in_group("spawn")[0].position
	player.position.x += (playerId - 1) * 8
	player.playerId = playerId
	mapParent.add_child(player)

func win():
	closeMenu()
	var dim = Res.FinishDim.instance()
	getMap().add_child(dim)

func getMap():
	return get_tree().get_nodes_in_group('map')[0]

func gotoNextMap():
	currentMap += 1
	saveGame()
	gotoMap(currentMap)

func gotoMap(i):
	get_tree().change_scene(Res.MapPaths[i])

func resetGame():
	closeMenu()
	deleteSave()
	currentMap = 0
	gotoCurrentMap()

func gotoCurrentMap():
	gotoMap(currentMap)

func saveGame():
	var gameState = {
		'currentMap' : currentMap
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

func deleteSave():
	var file = Directory.new()
	file.remove(SAVE_PATH)

func isMenu():
	return len(get_tree().get_nodes_in_group("menu")) > 0

func closeMenu():
	if (isMenu()):
		get_tree().get_nodes_in_group("menu")[0].close()
