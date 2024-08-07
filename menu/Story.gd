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
	$Book/OpenedEnd/BookRightSprite/TotalTimeLabel.set_text(Global.formatTime(Global.getTotalTime(), true))
	$Book/OpenedEnd/BookRightSprite/TotalDeathLabel.set_text(str(Global.getTotalDeaths()))

func startStory():
	started = true
	get_node('/root/Music').play(Res.AudioMusicStory)
	progressTimer()
	
func progressTimer():
	if !Global.gameFinished:
		if (page < Res.Maps[Global.currentMap].chapter):
			$FlipTimer.start()
		else:
			$StartAnim.play("startgame")
	else:
		if (page < len(Res.Chapters) + len(Res.EndSlides)):
			$FlipTimer.start()
		else:
			$StoryAnim.play("close")

func _input(event):
	if event is InputEventKey or event is InputEventJoypadButton or event is InputEventAction:
		if event.is_action_pressed("skip"):
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
	$Book/Opened/BookLeftSprite/Frame/StoryLeftLabel.set_text("")
	$Book/Opened/BookRightSprite/Frame/StoryRightLabel.set_text("")
	$Book/Opened/BookRightSprite/Finished.hide()
	if page < 0:
		var slide = Res.PreSlides[page + len(Res.PreSlides)]
		$Book/Opened/BookLeftSprite/Frame/StoryLeft.texture = slide.leftImage
		$Book/Opened/BookLeftSprite/Frame/StoryLeftLabel.set_text(slide.leftText)
		$Book/Opened/BookRightSprite/Frame/StoryRight.texture = slide.rightImage
		$Book/Opened/BookRightSprite/Frame/StoryRightLabel.set_text(slide.rightText)
	elif page < len(Res.Chapters):
		var chapter = Res.Chapters[page]
		$Book/Opened/BookLeftSprite/Frame/StoryLeft.texture = chapter.leftImage
		$Book/Opened/BookLeftSprite/Frame/StoryLeftLabel.set_text(chapter.leftText)
		if (Global.gameFinished || page < Res.Maps[Global.currentMap].chapter):
			$Book/Opened/BookRightSprite/Finished.show()
			$Book/Opened/BookRightSprite/Frame.show()
			$Book/Opened/BookRightSprite/Frame/StoryRight.texture = chapter.rightImage
			$Book/Opened/BookRightSprite/Frame/StoryRightLabel.set_text(chapter.rightText)
		else:
			$Book/Opened/BookRightSprite/Frame.hide()
	else:
		var slide = Res.EndSlides[page - len(Res.Chapters)]
		$Book/Opened/BookLeftSprite/Frame/StoryLeft.texture = slide.leftImage
		$Book/Opened/BookLeftSprite/Frame/StoryLeftLabel.set_text(slide.leftText)
		$Book/Opened/BookRightSprite/Frame/StoryRight.texture = slide.rightImage
		$Book/Opened/BookRightSprite/Frame/StoryRightLabel.set_text(slide.rightText)

func startGame():
	Global.showWholeStory = false
	if !Global.gameFinished:
		Global.gotoCurrentMap()
	else:
		Global.gotoMap(0)

func _on_FlipTimer_timeout():
	flipPage(true)
	progressTimer()
