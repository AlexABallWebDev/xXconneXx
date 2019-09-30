extends Node2D

var hexes
var hex_scene

const SCREEN_OFFSET = 100
const HEX_WIDTH = 128
const HEX_HEIGHT = 128

# This hex grid uses the "pointy top" odd row offset per:
# https://www.redblobgames.com/grids/hexagons/
const ODD_ROW_DIRECTIONS = [
    [[+1,  0], [ 0, -1], [-1, -1], 
     [-1,  0], [-1, +1], [ 0, +1]],
    [[+1,  0], [+1, -1], [ 0, -1], 
     [-1,  0], [ 0, +1], [+1, +1]],
]

# define where hexes spawn from json
var hex_json = """
{
	"hex_rows": [
		["x", "n", "n", "x"],
		["o", "n", "o", "n"],
		["n", "o", "o", "n"]
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
	
	check_solutions()

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
				node.x = cell_count
				node.y = row_count
				add_child(node)
				print(str(row_count) + ", cell_count " + str(node))
				hexes[row_count].push_back(node)
				
				if hex_char == "x":
					hexes[row_count][cell_count].change_color(Color.red)
					hexes[row_count][cell_count].set_x()
					
			else:
				hexes[row_count].push_back(null)
	print(str(hexes))

func check_solutions():
	# check each hex on the grid. If it is an X, then
	# begin checking adjacent hexes to see if it connects
	# to another X of the same color.
	var row_count = -1
	for row in hexes:
		row_count += 1
		var hex_count = -1
		for hex in row:
			hex_count += 1
			if hex != null and hex.is_x == true:
				print(str(row) + " " + str(hex) + " hex is x")
				var is_game_over = hex_reachable(hex_count, row_count)
				print(str(is_game_over))
				if is_game_over:
					$CanvasLayer/Label.visible = true

# check adjacent hexes
func hex_neighbor(x, y, dir_num):
	# This function was adapted from:
	# https://www.redblobgames.com/grids/hexagons/
	
	# retrieve directions per odd or even row
	var parity = y & 1
	var dir = ODD_ROW_DIRECTIONS[parity][dir_num]
	
	# return the coordinates of the neighboring hex in
	# the given direction
	return [x + dir[0], y + dir[1]]

func is_valid_coord(x, y):
	return y >= 0 and x >= 0 and y < len(hexes) and x < len(hexes[y])

func test_is_valid_coord():
	for y in range(-1,4):
		for x in range(-1,5):
			print(str(x) + ", " + str(y) + " is_valid? " + str(is_valid_coord(x, y)))

func hex_reachable(x, y):
	# This function was adapted from:
	# https://www.redblobgames.com/grids/hexagons/
	var hexes_checked = []
	hexes_checked.push_back(hexes[y][x])
	var fringes = [] # array of arrays of hexes
	fringes.push_back([hexes[y][x]])

	var layer = 0
	# while there are still hexes left unchecked
	while len(fringes[layer]) > 0:
		fringes.append([])
		for hex in fringes[layer]:
			for dir in range(0, 6):
				var neighbor_coord = hex_neighbor(hex.x, hex.y, dir)
				if is_valid_coord(neighbor_coord[0], neighbor_coord[1]):
					var neighbor = hexes[neighbor_coord[1]][neighbor_coord[0]]
					if neighbor != null and not hexes_checked.has(neighbor) and neighbor.color == Color.red:
						# This would be another X of the same color.
						if neighbor.is_x:
							return true
						hexes_checked.push_back(neighbor)
						fringes[layer + 1].append(neighbor)
		layer += 1

	# path not found
	return false