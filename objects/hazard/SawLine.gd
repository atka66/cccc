extends Node2D

export(Vector2) var destination

# Called when the node enters the scene tree for the first time.
func _ready():
	$Line2D.points[1] = destination
	$SpriteEnd.position = destination
