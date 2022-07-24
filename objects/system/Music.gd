extends Node

var muted = false

func play(stage):
	var audioStream = Res.AudioMusicSplash
	match stage:
		'splash':
			audioStream = Res.AudioMusicSplash
	if $Audio.stream != audioStream:
		$Audio.stream = audioStream
		if !muted:
			$Audio.play()

func mute():
	$Audio.stop()
