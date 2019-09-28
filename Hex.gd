extends Node2D

# color drawn to this hex
var color

# make hex clickable
func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and \
	event.button_index == BUTTON_LEFT and \
	event.is_pressed():
		self._on_click()

func _on_click():
	print("Hex color: " + str(color))
	color = $"/root/Global".cursor_color