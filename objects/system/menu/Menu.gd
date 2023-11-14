extends CanvasLayer

var page = 0
var selectedScene = 0

var resetPrompt = false
var mapSelectionPrompt = false

func _ready():
	if !Global.gameFinished:
		$ResetPrompt/SadChild/AppearAudio.stream = null
		$ResetPrompt/SadChild.hide()
	$VersionLabel.set_text('v' + Global.VERSION)
	$MapSelection.hide()
	$ResetPrompt.hide()
	$AppearAudio.stream = Res.AudioPageflip[randi() % len(Res.AudioPageflip)]
	$AppearAudio.play()
	updateAudio()

func _process(delta):
	if mapSelectionPrompt:
		if Input.is_action_just_pressed("skip") or Input.is_action_just_pressed("menu"):
			$ActionAudio.play()
			mapSelectionPrompt = false
			$MapSelection.hide()
			$MainContainer.show()
		if Input.is_action_just_pressed("ui_left"):
			flipPage(false)
		if Input.is_action_just_pressed("ui_right"):
			flipPage(true)
		if Input.is_action_just_pressed("ui_up"):
			if selectedScene > 0:
				selectedScene = (selectedScene + 4) % 5
				$ActionAudio.play()
				updateScene()
		if Input.is_action_just_pressed("ui_down"):
			if int(Global.currentMap) - (page * 5) > selectedScene && selectedScene < 4:
				selectedScene = (selectedScene + 1) % 5
				$ActionAudio.play()
				updateScene()
		if Input.is_action_just_pressed("map"):
			Global.closeMenu()
			Global.gotoMap((page * 5) + selectedScene)
		if Input.is_action_just_pressed("touch_map_1"):
				Global.closeMenu()
				Global.gotoMap(page * 5)
		if Input.is_action_just_pressed("touch_map_2"):
			if int(Global.currentMap) - (page * 5) > 0:
				Global.closeMenu()
				Global.gotoMap((page * 5) + 1)
		if Input.is_action_just_pressed("touch_map_3"):
			if int(Global.currentMap) - (page * 5) > 1:
				Global.closeMenu()
				Global.gotoMap((page * 5) + 2)
		if Input.is_action_just_pressed("touch_map_4"):
			if int(Global.currentMap) - (page * 5) > 2:
				Global.closeMenu()
				Global.gotoMap((page * 5) + 3)
		if Input.is_action_just_pressed("touch_map_5"):
			if int(Global.currentMap) - (page * 5) > 3:
				Global.closeMenu()
				Global.gotoMap((page * 5) + 4)
	elif resetPrompt:
		if Input.is_action_just_pressed("reset"):
			Global.resetGame()
		if Input.is_action_just_pressed("skip") or Input.is_action_just_pressed("menu"):
			resetPrompt = false
			$ResetPrompt.hide()
			$ResetPrompt/Anim.stop()
			$ResetPrompt/Anim.seek(0, true)
			
	else:
		if Input.is_action_just_pressed("map"):
			page = Res.Maps[Global.actualMap].chapter
			updateImages()
			$ActionAudio.play()
			$MainContainer.hide()
			mapSelectionPrompt = true
			$MapSelection.show()
		if Input.is_action_just_pressed("reset"):
			resetPrompt = true
			$ResetPrompt.show()
			$ResetPrompt/Anim.play("appear")
		if Input.is_action_just_pressed("skip") or Input.is_action_just_pressed("menu"):
			close()
		if Input.is_action_just_pressed("mute"):
			Global.audio = int(Global.audio + 1) % 4
			Global.saveGame()
			updateAudio()
			$ActionAudio.play()

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
	$MapSelection/RightSide/Time1Label.set_text(Global.formatTime(Global.times[page * 5], false))
	if chaptersToShow > 0:
		$MapSelection/RightSide/Scene2Label.show()
		$MapSelection/RightSide/Scene2Label.set_text(Res.Maps[(page * 5) + 1].name)
		$MapSelection/RightSide/Time2Label.show()
		$MapSelection/RightSide/Time2Label.set_text(Global.formatTime(Global.times[(page * 5) + 1], false))
	else:
		$MapSelection/RightSide/Scene2Label.hide()
		$MapSelection/RightSide/Time2Label.hide()
	if chaptersToShow > 1:
		$MapSelection/RightSide/Scene3Label.show()
		$MapSelection/RightSide/Scene3Label.set_text(Res.Maps[(page * 5) + 2].name)
		$MapSelection/RightSide/Time3Label.show()
		$MapSelection/RightSide/Time3Label.set_text(Global.formatTime(Global.times[(page * 5) + 2], false))
	else:
		$MapSelection/RightSide/Scene3Label.hide()
		$MapSelection/RightSide/Time3Label.hide()
	if chaptersToShow > 2:
		$MapSelection/RightSide/Scene4Label.show()
		$MapSelection/RightSide/Scene4Label.set_text(Res.Maps[(page * 5) + 3].name)
		$MapSelection/RightSide/Time4Label.show()
		$MapSelection/RightSide/Time4Label.set_text(Global.formatTime(Global.times[(page * 5) + 3], false))
	else:
		$MapSelection/RightSide/Scene4Label.hide()
		$MapSelection/RightSide/Time4Label.hide()
	if chaptersToShow > 3:
		$MapSelection/RightSide/Scene5Label.show()
		$MapSelection/RightSide/Scene5Label.set_text(Res.Maps[(page * 5) + 4].name)
		$MapSelection/RightSide/Time5Label.show()
		$MapSelection/RightSide/Time5Label.set_text(Global.formatTime(Global.times[(page * 5) + 4], false))
		var chapterTime = Global.times[page * 5] + Global.times[(page * 5) + 1] + Global.times[(page * 5) + 2] + Global.times[(page * 5) + 3] + Global.times[(page * 5) + 4]
		$MapSelection/RightSide/ChapterTimeLabel.show()
		$MapSelection/RightSide/ChapterTimeLabel.set_text(Global.formatTime(chapterTime, false))
		$MapSelection/RightSide/ChapterLabel.show()
	else:
		$MapSelection/RightSide/Scene5Label.hide()
		$MapSelection/RightSide/Time5Label.hide()
		$MapSelection/RightSide/ChapterTimeLabel.hide()
		$MapSelection/RightSide/ChapterLabel.hide()
	
	if Global.gameFinished:
		$MapSelection/RightSide/TotalLabel.show()
		$MapSelection/RightSide/TotalTimeLabel.show()
		$MapSelection/RightSide/TotalTimeLabel.set_text(Global.formatTime(Global.getTotalTime(), false))
	else:
		$MapSelection/RightSide/TotalLabel.hide()
		$MapSelection/RightSide/TotalTimeLabel.hide()

	$MapSelection/LeftSide/Frame/ChapterLabel.set_text(Res.Chapters[page].title)
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
