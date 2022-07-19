extends Node

var mapParent = null
var currentMap = 0

func _ready():
	randomize()
	currentMap = 0

func spawnPlayer():
	var player = Res.Player.instance()
	player.position = get_tree().get_nodes_in_group("spawn")[0].position
	mapParent.add_child(player)

func win():
	var dim = Res.FinishDim.instance()
	getMap().add_child(dim)

func getMap():
	return get_tree().get_nodes_in_group('map')[0]

func gotoNextMap():
	currentMap += 1
	get_tree().change_scene(Res.MapPaths[currentMap])
