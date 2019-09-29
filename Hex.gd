extends Node2D

# color drawn to this hex
var color

var hex_dot_image
var hex_x_image

var global

func _ready():
	global = $"/root/Global"
	hex_dot_image = load("res://hex_dot.png")
	hex_x_image = load("res://hex_x.png")

# make hex clickable
func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and \
	event.button_index == BUTTON_LEFT and \
	event.is_pressed():
		self._on_click()

func _on_click():
	print(str(self) + " hex color: " + str(color))
	color = global.cursor_color
	$Sprite.texture = hex_dot_image
	$Sprite.modulate = color
	
func change_color(new_color):
	$Sprite.modulate = new_color

func set_x():
	$Sprite.texture = hex_x_image