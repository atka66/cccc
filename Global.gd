extends Node

func spawnPlayer(parent):
	var player = Res.Player.instance()
	player.position = get_tree().get_nodes_in_group("spawn")[0].position
	parent.add_child(player)
