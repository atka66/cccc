extends Node2D

var noise = OpenSimplexNoise.new()
var i : int = 0

func _ready():
	noise.seed = randi()
	
	$Rigid1/Sprite.scale = global_scale
	$Rigid2/Sprite.scale = global_scale
	$Rigid3/Sprite.scale = global_scale
	$Tip/Sprite.scale = global_scale

func _process(delta):
	i += 1
	$Rigid2.applied_force = Vector2(noise.get_noise_1d(1 - i), noise.get_noise_1d((1 - i) + 1000)) * 3000
	$Tip.applied_force = Vector2(noise.get_noise_1d(i), noise.get_noise_1d(i + 1000)) * 1000
