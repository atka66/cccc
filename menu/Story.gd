extends Node2D

func _ready():
	get_node('/root/Music').play('story_pre')

func startStoryMusic():
	get_node('/root/Music').play('story')

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func flipPage(forward: bool):
	if (!$Anim.is_playing()):
		$Anim.play("flipnext" if forward else "flipback")
		$PageflipAudio.stream = Res.AudioPageflip[randi() % len(Res.AudioPageflip)]
		$PageflipAudio.play()
