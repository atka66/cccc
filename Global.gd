extends Node

var mapParent = null

func _ready():
	randomize()

func spawnPlayer():
	var player = Res.Player.instance()
	player.position = get_tree().get_nodes_in_group("spawn")[0].position
	mapParent.add_child(player)
