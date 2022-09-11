extends Node

var muted = false

func play(stage):
	var audioStream = Res.AudioMusicSplash
	match stage:
		'splash':
			audioStream = Res.AudioMusicSplash
		'story_pre':
			audioStream = Res.AudioMusicStoryPre
		'story':
			audioStream = Res.AudioMusicStory
	if $Audio.stream != audioStream:
		$Audio.stream = audioStream
		if !muted:
			$Audio.play()

func mute():
	$Audio.stop()
