extends AudioStreamPlayer2D

func _ready():
	stream = Res.AudioBirds[randi() % len(Res.AudioBirds)]
	play()


func _on_BirdSound_finished():
	queue_free()
