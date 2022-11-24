extends Node2D

var page : int
var started : bool = false

func _ready():
	get_node('/root/Music').play(Res.AudioMusicStoryPre)
	if !Global.showWholeStory:
		if !Global.gameFinished:
			page = Res.Maps[Global.currentMap].chapter - 1
		else:
			page = len(Res.Chapters) - 1
	else:
		page = -len(Res.PreSlides)
	updateImages()

func startStory():
	started = true
	get_node('/root/Music').play(Res.AudioMusicStory)
	progressTimer()
	
func progressTimer():
	if !Global.gameFinished:
		if (page < Res.Maps[Global.currentMap].chapter):
			$FlipTimer.start()
		else:
			# todo think about whether text is needed here
			#if page > 0:
			#	$StartLabel.set_text("...and so our adventure continues...")
			#else:
			#	$StartLabel.set_text("...and so our adventure begins...")
			$StartAnim.play("startgame")
	else:
		if (page < len(Res.Chapters) + len(Res.EndSlides)):
			$FlipTimer.start()
		else:
			$StoryAnim.play("close")
			$StartAnim.play("startgame")

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_cancel"):
			startGame()
		elif started:
			$HintAnim.play("appear")

func flipPage(forward: bool):
	page = page + (1 if forward else -1)
	if (!$StoryAnim.is_playing()):
		$StoryAnim.play("flipnext" if forward else "flipback")
		$PageflipAudio.stream = Res.AudioPageflip[randi() % len(Res.AudioPageflip)]
		$PageflipAudio.play()

func updateImages():
	$Book/Opened/BookLeftSprite/ChapterLabel.set_text("")
	$Book/Opened/BookRightSprite/Finished.hide()
	$Book/Opened/BookLeftSprite/Frame.rotation_degrees = (randi() % 5) - 2
	$Book/Opened/BookRightSprite/Frame.rotation_degrees = (randi() % 5) - 2
	if page < 0:
		$Book/Opened/BookLeftSprite/Frame/StoryLeft.texture = Res.PreSlides[page + len(Res.PreSlides)].leftImage
		$Book/Opened/BookRightSprite/Frame/StoryRight.texture = Res.PreSlides[page + len(Res.PreSlides)].rightImage
	elif page < len(Res.Chapters):
		$Book/Opened/BookLeftSprite/ChapterLabel.set_text(Res.Chapters[page].title)
		$Book/Opened/BookLeftSprite/Frame/StoryLeft.texture = Res.Chapters[page].leftImage
		if (Global.gameFinished || page < Res.Maps[Global.currentMap].chapter):
			$Book/Opened/BookRightSprite/Finished.show()
			$Book/Opened/BookRightSprite/Frame.show()
			$Book/Opened/BookRightSprite/Frame/StoryRight.texture = Res.Chapters[page].rightImage
		else:
			$Book/Opened/BookRightSprite/Frame.hide()
	else:
		$Book/Opened/BookLeftSprite/Frame/StoryLeft.texture = Res.EndSlides[page - len(Res.Chapters)].leftImage
		$Book/Opened/BookRightSprite/Frame/StoryRight.texture = Res.EndSlides[page - len(Res.Chapters)].rightImage

func startGame():
	Global.showWholeStory = false
	if !Global.gameFinished:
		Global.gotoCurrentMap()
	else:
		Global.gotoMap(0)

func _on_FlipTimer_timeout():
	flipPage(true)
	progressTimer()
