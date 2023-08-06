extends Node2D

export var playerId : int = 0
var dummy : Node
var childDummy : Node

func _ready():
	if Global.phoneMode:
		$SchemeHolder.hide()
	
	dummy = Res.PlayerDummy.instance()
	dummy.playerId = playerId
	add_child(dummy)
	$SchemeHolder/ToggleSprite.frame = playerId
	
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
	
	if playerId == 0 && Global.gameFinished:
		childDummy = Res.PlayerDummy.instance()
		childDummy.playerId = 4
		childDummy.position = Vector2(8, 1)
		add_child(childDummy)
	else:
		$ChildName.hide()

	$DeathCount/DeathCountLabel.set_text(str(Global.deathCnt[playerId]))
	doDummies()

func _input(event):
	if event.is_action_pressed("toggle_player_" + str(playerId + 1)):
		$Anim.play("toggle")
		$ToggleAudio.play()
		Global.togglePlayer(playerId)

func _process(delta):
	doDummies()

func doDummies():
	if (Global.playersJoined[playerId]):
		wakeUpDummies()
		$SchemeHolder/ControlSprite.show()
		$SchemeHolder/ControlSprite.frame = Global.playersControlScheme[playerId]
	else:
		sleepDummies()
		$SchemeHolder/ControlSprite.hide()
	
	if Global.playersControlScheme[playerId] > 1:
		$SchemeHolder/DisconnectSprite.visible = !Global.joyConnected[Global.playersControlScheme[playerId] - 2]
	else:
		$SchemeHolder/DisconnectSprite.hide()

func wakeUpDummies():
	dummy.wakeup()
	if childDummy:
		childDummy.wakeup()
	$DeathCount.show()
	
func sleepDummies():
	dummy.sleep()
	if childDummy:
		childDummy.sleep()
	$DeathCount.hide()
