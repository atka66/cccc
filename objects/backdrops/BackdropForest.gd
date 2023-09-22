extends Node2D

func _ready():
	var offset = Global.getBgOffsetForActualMap()
	$BgForest.position.x = offset
	$BgLeaves1.position.x = offset
	## TODO
	#get_node('/root/Music').play(Res.AudioMusicChapterForest)
