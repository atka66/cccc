extends Node2D

func _ready():
	var offset = Global.getOffsetForActualMap()
	$BgPlains.margin_left = offset
	# TODO plains music
	get_node('/root/Music').mute()
