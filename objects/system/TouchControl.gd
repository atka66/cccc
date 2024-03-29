extends CanvasLayer

var toggle = true

func _ready():
	$Container/TitleContainer.hide()
	$Container/MapContainer.hide()
	$Container/MenuContainer.hide()
	$Container/ResetPromptContainer.hide()
	$Container/MapPromptContainer.hide()

func _input(event):
	if event.is_action_pressed("visibility_toggle"):
		toggleMapControls()

func _process(delta):
	if !Global.mapParent:
		$Container/TitleContainer.show()
		$Container/MapContainer.hide()
		$Container/MenuContainer.hide()
		$Container/ResetPromptContainer.hide()
		$Container/MapPromptContainer.hide()
	else:
		$Container/TitleContainer.hide()
		if !Global.isMenu():
			$Container/MapContainer.show()
			$Container/MenuContainer.hide()
			$Container/ResetPromptContainer.hide()
			$Container/MapPromptContainer.hide()
		else:
			$Container/MapContainer.hide()
			if Global.getMenu().resetPrompt:
				$Container/MenuContainer.hide()
				$Container/ResetPromptContainer.show()
				$Container/MapPromptContainer.hide()
			elif Global.getMenu().mapSelectionPrompt:
				$Container/MenuContainer.hide()
				$Container/ResetPromptContainer.hide()
				$Container/MapPromptContainer.show()
			else:
				$Container/MenuContainer.show()
				$Container/ResetPromptContainer.hide()
				$Container/MapPromptContainer.hide()

func toggleMapControls():
	toggle = !toggle
	if toggle:
		$Container/MapContainer/LeftButton/Sprite.show()
		$Container/MapContainer/RightButton/Sprite.show()
		$Container/MapContainer/JumpButton/Sprite.show()
		$Container/MapContainer/DashButton/Sprite.show()
	else:
		$Container/MapContainer/LeftButton/Sprite.hide()
		$Container/MapContainer/RightButton/Sprite.hide()
		$Container/MapContainer/JumpButton/Sprite.hide()
		$Container/MapContainer/DashButton/Sprite.hide()
