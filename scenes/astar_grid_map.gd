extends GridMap

@onready var map = get_node("/root/main/Map")

signal astar_path_tiles

# Called when the node enters the scene tree for the first time.
func _ready():
	await map.player_number_active
	for astar_path_tiles in range(map.player_number * 10):
		set_astar_grid_map()
	astar_path_tiles.emit()

func set_astar_grid_map():
	#print("set_astar_grid_map: ", default_row * player_number)
	for x in range(map.default_row):
		for z in range(map.player_number):
			var pos_x = x
			var pos_z = z
			self.set_cell_item(Vector3(pos_x, 0, pos_z),0)
