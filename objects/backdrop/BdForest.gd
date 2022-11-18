extends Node2D

func _ready():
	var offset = -(randi() % 400) + 20
	$BgForest.margin_left = offset
	$Leaves1.margin_left = offset
	$Leaves2.margin_left = offset
	get_node('/root/Music').play(Res.AudioMusicChapterForest)
