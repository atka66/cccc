extends Node2D

var page : int = -2
var started : bool = false

func _ready():
	get_node('/root/Music').play(Res.AudioMusicStoryPre)
	if !Global.showWholeStory:
		page = Res.Maps[Global.currentMap].chapter - 1
	updateImages()

func startStory():
	started = true
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
	$Book/Opened/BookLeftSprite/Frame.rotation_degrees = (randi() % 5) - 2
	$Book/Opened/BookRightSprite/Frame.rotation_degrees = (randi() % 5) - 2
	if page < 0:
		$Book/Opened/BookLeftSprite/Frame/StoryLeft.texture = Res.PreSlides[page + len(Res.PreSlides)].leftImage
		$Book/Opened/BookRightSprite/Frame/StoryRight.texture = Res.PreSlides[page + len(Res.PreSlides)].rightImage
	else:
		$Book/Opened/BookLeftSprite/ChapterLabel.set_text(Res.Chapters[page].title)
		$Book/Opened/BookLeftSprite/Frame/StoryLeft.texture = Res.Chapters[page].leftImage
		if (page < Res.Maps[Global.currentMap].chapter):
			$Book/Opened/BookRightSprite/Frame.show()
			$Book/Opened/BookRightSprite/Frame/StoryRight.texture = Res.Chapters[page].rightImage
		else:
			$Book/Opened/BookRightSprite/Frame.hide()

func startGame():
	Global.showWholeStory = false
	Global.gotoCurrentMap()

func _on_FlipTimer_timeout():
	flipPage(true)
	progressTimer()
