extends Node2D

func _ready():
	$MapNameLabel.set_text(Res.Maps[Global.currentMap].name)
