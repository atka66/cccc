extends Node2D

var page = 0

func _ready():
	$VersionLabel.set_text('v' + Global.VERSION)
	$MapSelection.hide()
	$ResetPrompt.hide()
	$AppearAudio.stream = Res.AudioPageflip[randi() % len(Res.AudioPageflip)]
	$AppearAudio.play()

func _input(event):
	if $MapSelection.visible:
		if event.is_action_pressed("ui_cancel"):
			$ActionAudio.play()
			$MapSelection.hide()
			$MainContainer.show()
		if event.is_action_pressed("ui_left"):
			flipPage(false)
		if event.is_action_pressed("ui_right"):
			flipPage(true)
	elif $ResetPrompt.visible:
		if event.is_action_pressed("reset"):
			Global.resetGame()
		if event.is_action_pressed("ui_cancel"):
			$ResetPrompt.hide()
	else:
		if event.is_action_pressed("map"):
			page = Res.Maps[Global.currentMap].chapter
			updateImages()
			$ActionAudio.play()
			$MainContainer.hide()
			$MapSelection.show()
		if event.is_action_pressed("reset"):
			$ResetPrompt.show()
			$ResetPrompt/Anim.play("appear")
		if event.is_action_pressed("ui_cancel"):
			close()

func close():
	queue_free()

# map selection related logic

func flipPage(forward: bool):
	# can I flip?
	if !(forward && page >= Res.Maps[Global.currentMap].chapter) && !(!forward && page < 1):
		page = page + (1 if forward else -1)
		if (!$MapSelection/MapAnim.is_playing()):
			$MapSelection/MapAnim.play("flipnext" if forward else "flipback")
			$PageflipAudio.stream = Res.AudioPageflip[randi() % len(Res.AudioPageflip)]
			$PageflipAudio.play()

func updateImages():
	$MapSelection/RightSide/Finished.hide()
	$MapSelection/LeftSide/Frame.rotation_degrees = (randi() % 5) - 2
	$MapSelection/RightSide/Frame.rotation_degrees = (randi() % 5) - 2

	$MapSelection/LeftSide/ChapterLabel.set_text(Res.Chapters[page].title)
	$MapSelection/LeftSide/Frame/Story.texture = Res.Chapters[page].leftImage
	if (page < Res.Maps[Global.currentMap].chapter):
		$MapSelection/RightSide/Finished.show()
		$MapSelection/RightSide/Frame.show()
		$MapSelection/RightSide/Frame/Story.texture = Res.Chapters[page].rightImage
	else:
		$MapSelection/RightSide/Frame.hide()

