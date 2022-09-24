extends Node2D

func _ready():
	$BgPlains.margin_left = -(randi() % 400)
	get_node('/root/Music').play(Res.AudioMusicChapterRainy)
