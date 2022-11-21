extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$BgSnow.margin_left = -(randi() % 400)
	get_node('/root/Music').play(Res.AudioMusicChapterSnow)
