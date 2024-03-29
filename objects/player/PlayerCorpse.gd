extends Node2D

export var playerId : int = 0

func _ready():
	#spawnBloodParticles(8)
	spawnBloodTrails(15)
	$BloodPar.restart()
	$PopAudio.stream = Res.AudioDeathPop[randi() % len(Res.AudioDeathPop)]
	$PopAudio.play()

# todo maybe delete later
func spawnBloodParticles(n : int):
	for i in range(1, n):
		var bloodPar = Res.BloodPar.instance()
		bloodPar.position = position
		Global.mapParent.add_child(bloodPar)

func spawnBloodTrails(n : int):
	for i in range(1, n):
		var bloodTrail = Res.BloodTrail.instance()
		bloodTrail.position = position
		if (i % 2 == 0):
			bloodTrail.mute = false
		else:
			bloodTrail.mute = true
		Global.mapParent.add_child(bloodTrail)

func _on_RespawnTimer_timeout():
	Global.spawnPlayer(playerId, false)
