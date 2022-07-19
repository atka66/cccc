extends Node2D

func _ready():
	var offset = -(randi() % 400)
	$BgForest.margin_left = offset
	$Leaves1.margin_left = offset
	$Leaves2.margin_left = offset
