extends Node2D

export var text = ''
export var fontSize = 1
export(int, "Left", "Center", "Right") var alignment = 0
export(bool) var outline = false
export(Color) var color = Color.white
export(Array, SpriteFrames) var frames
export(float) var aliveTime = 0
export(AudioStreamOGGVorbis) var audio = null
export(bool) var animate = true

func set_text(_text):
	$Label.text = _text
	if alignment == 1:
		position.x -= round($Label.get("custom_fonts/font").get_string_size(_text).x / 2) * fontSize
	elif alignment == 2:
		position.x -= round($Label.get("custom_fonts/font").get_string_size(_text).x) * fontSize

func set_color(_color):
	$Label.add_color_override("font_color", _color)

func time_disappear():
	yield(get_tree().create_timer(aliveTime), "timeout")
	if animate:
		$LabelAnim.play("float_out")
		yield($LabelAnim, "animation_finished")
	yield($Audio, "finished")
	queue_free()

func _ready():
	if audio:
		$Audio.stream = audio
		$Audio.play()
	set_text(text)
	set_color(color)
	$Label.rect_scale = Vector2(fontSize, fontSize)
	if !outline:
		$Label.set_theme(preload("res://fonts/NonOutlinedTheme.tres"))
	if frames.size() > 0:
		$AnimatedSprite1.set_sprite_frames(frames[0])
		$AnimatedSprite1.play()
	if frames.size() > 1:
		$AnimatedSprite2.set_sprite_frames(frames[1])
		$AnimatedSprite2.play()
	
	if animate:
		$LabelAnim.play("float_in")
	else:
		$Label.rect_position = Vector2.ZERO
		$Label.modulate = Color.white
	if aliveTime > 0:
		time_disappear()
