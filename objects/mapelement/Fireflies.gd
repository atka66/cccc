extends Position2D

export(int) var count = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(count):
		var firefly = Res.Firefly.instance()
		firefly.position = Vector2((randi() % 32) - 16, (randi() % 32) - 16)
		firefly.origin = global_position
		add_child(firefly)
