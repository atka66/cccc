extends Node2D

var page : int = -2

func _ready():
	get_node('/root/Music').play(Res.AudioMusicStoryPre)
	if !Global.showWholeStory:
		page = Res.Maps[Global.currentMap].chapter - 1
	updateImages()

func startStory():
	get_node('/root/Music').play(Res.AudioMusicStory)
	progressTimer()
	

func progressTimer():
	if (page < Res.Maps[Global.currentMap].chapter):
		$FlipTimer.start()
	else:
		if page > 0:
			$StartLabel.set_text("...and so our adventure continues...")
		else:
			$StartLabel.set_text("...and so our adventure begins...")
		$StartAnim.play("startgame")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		startGame()

func flipPage(forward: bool):
	page = page + (1 if forward else -1)
	if (!$StoryAnim.is_playing()):
		$StoryAnim.play("flipnext" if forward else "flipback")
		$PageflipAudio.stream = Res.AudioPageflip[randi() % len(Res.AudioPageflip)]
		$PageflipAudio.play()

func updateImages():
	if page < 0:
		$Book/Opened/BookLeftSprite/StoryLeft.texture = Res.PreSlides[page + len(Res.PreSlides)].leftImage
		$Book/Opened/BookRightSprite/StoryRight.texture = Res.PreSlides[page + len(Res.PreSlides)].rightImage
	else:
		$Book/Opened/BookLeftSprite/ChapterLabel.set_text(Res.Chapters[page].title)
		$Book/Opened/BookLeftSprite/StoryLeft.texture = Res.Chapters[page].leftImage
		if (page < Res.Maps[Global.currentMap].chapter):
			$Book/Opened/BookRightSprite/StoryRight.texture = Res.Chapters[page].rightImage
		else:
			$Book/Opened/BookRightSprite/StoryRight.texture = null

func startGame():
	Global.showWholeStory = false
	Global.gotoCurrentMap()

func _on_FlipTimer_timeout():
	flipPage(true)
	progressTimer()
