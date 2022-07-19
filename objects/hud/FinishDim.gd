extends Node2D

func _ready():
	$Anim.play('fade_in')


func _on_Anim_animation_finished(anim_name):
	if (anim_name == "fade_in"):
		$Anim.play("fade_out")
	if (anim_name == "fade_out"):
		Global.gotoNextMap()
