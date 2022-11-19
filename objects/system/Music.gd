extends Node

func play(stream):
	if $Audio.stream != stream:
		$Audio.stream = stream
		$Audio.play()

func mute():
	play(null)
