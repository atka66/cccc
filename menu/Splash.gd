extends Node2D

func _ready():
	get_node('/root/Music').play('splash')
	$Anim.play("splash")

func toGame():
	Global.gotoCurrentMap()