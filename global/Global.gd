extends Node

const SAVE_PATH = "user://cccc.sav"
const VERSION = '1.3.0'

var mapParent = null
var gameFinished: bool = false

var currentMap: int = 0
var actualMap: int = 0

func _ready():
	
	
	randomize()
	
	gameFinished = currentMap >= len(Res.Maps)

func getOffsetForActualMap():
	var determRandom = RandomNumberGenerator.new()
	determRandom.set_seed(actualMap)
	return -(determRandom.randi() % 400) - 20
