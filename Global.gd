extends Node

const SAVE_PATH = "user://cccc.sav"

var mapParent = null
var currentMap = 0

func _ready():
	randomize()
	deleteSave()
	#loadGame()

func spawnPlayer():
	var player = Res.Player.instance()
	player.position = get_tree().get_nodes_in_group("spawn")[0].position
	mapParent.add_child(player)

func win():
	closeMenu()
	var dim = Res.FinishDim.instance()
	getMap().add_child(dim)

func getMap():
	return get_tree().get_nodes_in_group('map')[0]

func gotoCurrentMap():
	gotoMap(currentMap)

func gotoNextMap():
	currentMap += 1
	saveGame()
	gotoMap(currentMap)

func gotoMap(i):
	get_tree().change_scene(Res.MapPaths[i])

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
		print(gameState)
		if (gameState.has('currentMap')):
			currentMap = gameState['currentMap']

func deleteSave():
	var file = Directory.new()
	file.remove(SAVE_PATH)

func _input(event):
	if Input.is_action_just_pressed("mute"):
		get_node('/root/Music').mute()

func isMenu():
	return len(get_tree().get_nodes_in_group("menu")) > 0

func toggleMenu():
	if (isMenu()):
		closeMenu()
	else:
		add_child(Res.Menu.instance())

func closeMenu():
	if (isMenu()):
		get_tree().get_nodes_in_group("menu")[0].close()
