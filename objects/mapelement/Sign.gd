extends Area2D

export var signHintSprite : Texture

var enteredCnt : int = 0

func _ready():
	$SignZoomSprite/SignHintSPrite.texture = signHintSprite
	$SignZoomSprite.hide()

func _on_Sign_body_entered(body):
	if body.is_in_group('player'):
		if enteredCnt < 1:
			$Anim.play("reveal")
		enteredCnt += 1


func _on_Sign_body_exited(body):
	if body.is_in_group('player'):
		enteredCnt -= 1
		if enteredCnt < 1:
			$Anim.play("hide")
