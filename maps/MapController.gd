extends Node2D

func _ready():
	get_node('/root/Music').mute()
	Global.mapParent = self
	Global.spawnPlayer()
