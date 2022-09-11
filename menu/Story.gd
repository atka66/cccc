extends Node2D

func flipPage(forward: bool):
	if (!$Anim.is_playing()):
		$Anim.play("flipnext" if forward else "flipback")
		$PageflipAudio.stream = Res.AudioPageflip[randi() % len(Res.AudioPageflip)]
		$PageflipAudio.play()
