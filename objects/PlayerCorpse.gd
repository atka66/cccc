extends Node2D

func _ready():
	spawnBloodParticles(50)
	spawnBloodTrails(25)
	$BloodParticles.restart()

func spawnBloodParticles(n : int):
	for i in range(1, n):
		var bloodPar = Res.BloodPar.instance()
		bloodPar.position = position
		Global.mapParent.add_child(bloodPar)

func spawnBloodTrails(n : int):
	for i in range(1, n):
		var bloodTrail = Res.BloodTrail.instance()
		bloodTrail.position = position
		Global.mapParent.add_child(bloodTrail)

func _on_RespawnTimer_timeout():
	Global.spawnPlayer()
