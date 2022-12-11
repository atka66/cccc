extends Node2D

const thunderMaxDelay : int = 20

func _ready():
	var offset = Global.getOffsetForActualMap()
	$BgPlains.margin_left = offset
	get_node('/root/Music').play(Res.AudioMusicChapterRainy)
	$ThunderTimer.start(randf() * thunderMaxDelay)

func _on_ThunderTimer_timeout():
	$ThunderAnim.play("thunder")
	$ThunderTimer.start(randf() * thunderMaxDelay)
