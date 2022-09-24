extends Node

var muted = false

func play(stream):
	if $Audio.stream != stream:
		$Audio.stream = stream
		if !muted:
			$Audio.play()

func mute():
	$Audio.stop()
