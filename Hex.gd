extends Node2D

# color drawn to this hex
var color

var global

func _ready():
	global = $"/root/Global"

# make hex clickable
func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and \
	event.button_index == BUTTON_LEFT and \
	event.is_pressed():
		self._on_click()

func _on_click():
	print("Hex color: " + str(color))
	color = global.cursor_color
	$Sprite.set_texture(global.hex_dot_image)
	$Sprite.modulate = color