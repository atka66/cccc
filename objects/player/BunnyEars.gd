extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$LeftTip/Sprite.scale = global_scale
	$RightTip/Sprite.scale = global_scale
