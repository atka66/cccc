extends Node2D

func _ready():
	$BloodParticles.restart()

func _on_RespawnTimer_timeout():
	Global.spawnPlayer(get_parent())
