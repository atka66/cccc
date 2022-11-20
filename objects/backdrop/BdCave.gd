extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var offset = -(randi() % 400)
	$BgCave.margin_left = offset
	$BgCrystals1.margin_left = offset
	$BgCrystals2.margin_left = offset
	$Anim.seek(randf() * $Anim.current_animation_length)
	get_node('/root/Music').play(Res.AudioMusicChapterCave)
