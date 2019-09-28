extends Area2D

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and \
	event.button_index == BUTTON_LEFT and \
	event.is_pressed():
		self._on_click()

func _on_click():
	print("Clicked on Hex")
