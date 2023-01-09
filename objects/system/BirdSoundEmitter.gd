extends Node

var chirpMaxDelay : int = 5

func _ready():
	$ChirpTimer.start(randf() * chirpMaxDelay)

func _on_ChirpTimer_timeout():
	chirp()
	$ChirpTimer.start(randf() * chirpMaxDelay)
	
func chirp():
	var birdSound = Res.BirdSound.instance()
	birdSound.position.x = randf() * 1000
	add_child(birdSound)
