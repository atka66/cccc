extends Node2D

func _ready():
	$BgPlains.margin_left = -(randi() % 400)
	# TODO plains music
	#get_node('/root/Music').play(Res.AudioMusicChapterRainy)
