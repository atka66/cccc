extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var offset = Global.getOffsetForActualMap()
	$BgDungeon.margin_left = offset
	get_node('/root/Music').play(Res.AudioMusicChapterDungeon)
