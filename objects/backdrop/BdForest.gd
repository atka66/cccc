extends Node2D

func _ready():
	var offset = Global.getOffsetForActualMap()
	$BgForest.margin_left = offset
	$Leaves1.margin_left = offset
	get_node('/root/Music').play(Res.AudioMusicChapterForest)
