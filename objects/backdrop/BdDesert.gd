extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var offset = Global.getOffsetForActualMap()
	$BgDesert.margin_left = offset
	get_node('/root/Music').mute()
