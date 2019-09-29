extends Node2D

var hexes
var hex_scene

const SCREEN_OFFSET = 100
const HEX_WIDTH = 128
const HEX_HEIGHT = 128

# define where hexes spawn from json
var hex_json = """
{
	"hex_rows": [
		["x", "n", "o", "x"],
		["o", "o", "o", "n"]
	]
}
"""

func _ready():
	print("parsing json")
	var json_result = JSON.parse(hex_json)
	print(json_result.error)
	print(json_result.result)
	
	hex_scene = load("res://Hex.tscn")
	
	_generate_hexes(json_result.result)

# generate hexes and store them
func _generate_hexes(hex_data):
	# hex grid knowledge learned from
	# https://www.redblobgames.com/grids/hexagons/
	hexes = []

	var row_count = -1
	for row in hex_data.hex_rows:
		row_count += 1

		hexes.push_back([])
		print("row " + str(row_count))

		var cell_count = -1
		for hex_char in row:
			cell_count += 1
			print("cell " + str(cell_count))
			if hex_char == "x" or hex_char == "o":
				var node = hex_scene.instance()

				# Move the new hex into its spot on the grid
				var hex_x = cell_count * HEX_WIDTH + SCREEN_OFFSET
				var hex_y = row_count * HEX_HEIGHT / 4 * 3 + SCREEN_OFFSET
				# offset for shoving odd rows +1/2 a column
				if row_count % 2 == 1:
					hex_x += HEX_WIDTH / 2
				node.position = Vector2(hex_x, hex_y)
				add_child(node)
				print(str(row_count) + " " + str(node))
				hexes[row_count].push_back(node)
				
				if hex_char == "x":
					hexes[row_count][cell_count].change_color(Color.red)
					hexes[row_count][cell_count].set_x()
					
			else:
				hexes[row_count].push_back(null)
	print(str(hexes))