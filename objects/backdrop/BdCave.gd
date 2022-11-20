extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$BgCave.margin_left = -(randi() % 400)
	get_node('/root/Music').play(Res.AudioMusicChapterCave)
