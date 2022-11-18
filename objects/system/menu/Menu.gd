extends Node2D

var page = 0
var selectedScene = 0

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
		if event.is_action_pressed("ui_up"):
			selectedScene = (selectedScene + 4) % 5
			updateScene()
		if event.is_action_pressed("ui_down"):
			selectedScene = (selectedScene + 1) % 5
			updateScene()
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
	if (page < Res.Maps[Global.currentMap].chapter):
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
		var col = Color("202020")
		if i == selectedScene:
			col = Color("aaaaaa")
		get_node("MapSelection/RightSide/Scene" + str(selectedScene + 1) + "Label").set_color(col)
