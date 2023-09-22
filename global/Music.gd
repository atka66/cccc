extends Node

func play(stream: AudioStream) -> void:
	if $Audio.stream != stream:
		$Audio.stream = stream
		$Audio.play()
