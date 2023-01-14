extends Node2D

const thunderMaxDelay : int = 30

func _ready():
	var offset = Global.getOffsetForActualMap()
	$BgCastle.margin_left = offset
	# todo castle music
	get_node('/root/Music').play(Res.AudioMusicChapterCastle)
	$ThunderTimer.start(randf() * thunderMaxDelay)

func _on_ThunderTimer_timeout():
	$ThunderAnim.play("thunder")
	$ThunderTimer.start(randf() * thunderMaxDelay)
