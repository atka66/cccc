extends Node2D

export var playerId : int = 0
var dummy : Node

func _ready():
	dummy = Res.PlayerDummy.instance()
	dummy.playerId = playerId
	add_child(dummy)
	$ToggleSprite.frame = playerId
	
	var name = 'unnamed'
	match playerId:
		0:
			name = 'pocky'
		1:
			name = 'raz'
		2:
			name = 'sing'
		3:
			name = 'harmony'
	$Name.set_text(name)

func _input(event):
	if event.is_action_pressed("toggle_player_" + str(playerId + 1)):
		$Anim.play("toggle")
		$ToggleAudio.play()
		Global.togglePlayer(playerId)

func _process(delta):
	if (Global.playersJoined[playerId]):
		dummy.wakeup()
		$ControlSprite.show()
		$ControlSprite.frame = Global.playersControlScheme[playerId]
	else:
		dummy.sleep()
		$ControlSprite.hide()
