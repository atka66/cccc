extends CanvasLayer

var page = 0
var selectedScene = 0

func _ready():
	$VersionLabel.set_text('v' + Global.VERSION)
	$MapSelection.hide()
	$ResetPrompt.hide()
	$AppearAudio.stream = Res.AudioPageflip[randi() % len(Res.AudioPageflip)]
	$AppearAudio.play()
	updateAudio()

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
		if event.is_action_pressed("ui_up"):
			if selectedScene > 0:
				selectedScene = (selectedScene + 4) % 5
				$ActionAudio.play()
				updateScene()
		if event.is_action_pressed("ui_down"):
			if int(Global.currentMap) - (page * 5) > selectedScene && selectedScene < 4:
				selectedScene = (selectedScene + 1) % 5
				$ActionAudio.play()
				updateScene()
		if event.is_action_pressed("map"):
			Global.closeMenu()
			Global.gotoMap((page * 5) + selectedScene)
	elif $ResetPrompt.visible:
		if event.is_action_pressed("reset"):
			Global.resetGame()
		if event.is_action_pressed("ui_cancel"):
			$ResetPrompt.hide()
	else:
		if event.is_action_pressed("map"):
			page = Res.Maps[Global.actualMap].chapter
			updateImages()
			$ActionAudio.play()
			$MainContainer.hide()
			$MapSelection.show()
		if event.is_action_pressed("reset"):
			$ResetPrompt.show()
			$ResetPrompt/Anim.play("appear")
		if event.is_action_pressed("ui_cancel"):
			close()
		if event.is_action_pressed("mute"):
			Global.audio = int(Global.audio + 1) % 4
			Global.saveGame()
			updateAudio()

func close():
	queue_free()

# map selection related logic

var flipLimit = Res.Maps[Global.currentMap].chapter if !Global.gameFinished else len(Res.Chapters) - 1

func flipPage(forward: bool):
	# can I flip?
	if !(forward && page >= flipLimit) && !(!forward && page < 1):
		if (!$MapSelection/MapAnim.is_playing()):
			page = page + (1 if forward else -1)
			$MapSelection/MapAnim.play("flipnext" if forward else "flipback")
			$PageflipAudio.stream = Res.AudioPageflip[randi() % len(Res.AudioPageflip)]
			$PageflipAudio.play()

func updateImages():
	selectedScene = 0
	var chaptersToShow = int(Global.currentMap) - (page * 5)
	$MapSelection/RightSide/Scene1Label.set_text(Res.Maps[page * 5].name)
	if chaptersToShow > 0:
		$MapSelection/RightSide/Scene2Label.show()
		$MapSelection/RightSide/Scene2Label.set_text(Res.Maps[(page * 5) + 1].name)
	else:
		$MapSelection/RightSide/Scene2Label.hide()
	if chaptersToShow > 1:
		$MapSelection/RightSide/Scene3Label.show()
		$MapSelection/RightSide/Scene3Label.set_text(Res.Maps[(page * 5) + 2].name)
	else:
		$MapSelection/RightSide/Scene3Label.hide()
	if chaptersToShow > 2:
		$MapSelection/RightSide/Scene4Label.show()
		$MapSelection/RightSide/Scene4Label.set_text(Res.Maps[(page * 5) + 3].name)
	else:
		$MapSelection/RightSide/Scene4Label.hide()
	if chaptersToShow > 3:
		$MapSelection/RightSide/Scene5Label.show()
		$MapSelection/RightSide/Scene5Label.set_text(Res.Maps[(page * 5) + 4].name)
	else:
		$MapSelection/RightSide/Scene5Label.hide()
	
	$MapSelection/LeftSide/Frame.rotation_degrees = (randi() % 5) - 2

	$MapSelection/LeftSide/ChapterLabel.set_text(Res.Chapters[page].title)
	$MapSelection/LeftSide/Frame/Story.texture = Res.Chapters[page].leftImage
	if (page < flipLimit):
		# here
		$MapSelection/NextHint.show()
	else:
		# here
		$MapSelection/NextHint.hide()

	if (page > 0):
		$MapSelection/PrevHint.show()
	else:
		$MapSelection/PrevHint.hide()
	
	updateScene()

func updateScene():
	for i in range(5):
		var node = get_node("MapSelection/RightSide/Scene" + str(i + 1) + "Label")
		if i == selectedScene:
			node.set_color(Color("ffffff"))
			node.set_outline(true)
		else:
			node.set_color(Color("202020"))
			node.set_outline(false)
		if (page * 5) + i == Global.actualMap:
			node.set_color(Color("ffffff"))

func updateAudio():
	Global.updateAudio()
	match int(Global.audio):
		0:
			$MainContainer/MusicMuteSprite.hide()
			$MainContainer/SoundMuteSprite.hide()
		1:
			$MainContainer/MusicMuteSprite.hide()
			$MainContainer/SoundMuteSprite.show()
		2:
			$MainContainer/MusicMuteSprite.show()
			$MainContainer/SoundMuteSprite.hide()
		3:
			$MainContainer/MusicMuteSprite.show()
			$MainContainer/SoundMuteSprite.show()
