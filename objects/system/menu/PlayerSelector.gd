extends Node2D

export var playerId : int = 0
var dummy : Node

func _ready():
	dummy = Res.PlayerDummy.instance()
	dummy.playerId = playerId
	add_child(dummy)
	$ToggleSprite.frame = playerId

func _process(delta):
	if (Global.playersJoined[playerId]):
		dummy.wakeup()
		$ControlSprite.show()
		$ControlSprite.frame = Global.playersControlScheme[playerId]
	else:
		dummy.sleep()
		$ControlSprite.hide()
