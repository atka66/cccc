extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.frame = randi() % $Sprite.hframes
	$StrobeAnim.seek(randf() * $StrobeAnim.current_animation_length)
	$HueAnim.seek(randf() * $HueAnim.current_animation_length)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
