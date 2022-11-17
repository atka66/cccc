extends Node2D

const thunderMaxDelay : int = 30

func _ready():
	$BgCastle.margin_left = -(randi() % 400)
	# todo castle music
	get_node('/root/Music').mute()
	$ThunderTimer.start(randf() * thunderMaxDelay)

func _on_ThunderTimer_timeout():
	$ThunderAnim.play("thunder")
	$ThunderTimer.start(randf() * thunderMaxDelay)
