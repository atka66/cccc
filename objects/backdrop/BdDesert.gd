extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$BgDesert.margin_left = -(randi() % 400)
	# TODO desert music
	#get_node('/root/Music').play(Res.AudioMusicChapterRainy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
