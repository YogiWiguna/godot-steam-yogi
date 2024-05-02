extends Node2D

@onready var iconrect_path = $Icon
@onready var grid_container = preload("res://src/puzzle_board.gd")

var item_ID : int
var item_grids := []
var selected = false
var grid_anchor = null

func _process(delta: float) -> void:
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)

func load_item(item_id : int) -> void:
	item_ID = DataHandler.item_data[str(item_id)]["ItemID"]
	var icon_path = "res://assets/items/" + DataHandler.item_data[str(item_id)]["Name"] + ".png"
	iconrect_path.texture = load(icon_path)
	for grid in DataHandler.item_grid_data[str(item_id)]:
		var converter_array := []
		for i in grid:
			converter_array.push_back(int(i))
		item_grids.push_back(converter_array)

#func rotate_item():
	#for grid in item_grids:
		#var temp_y = grid[0]
		#grid[0] =- grid[1]
		#grid[1] = 	temp_y
	#rotation_degrees += 90
	#if rotation_degrees >= 360:
		#rotation_degrees = 0

func _snap_to(destination: Vector2):
	var tween = get_tree().create_tween()
	#if int(rotation_degrees) % 180 == 0:
	#	destination += iconrect_path.size/2
	#else:
	# var temp_xy_switch = Vector2(iconrect_path.size.y, iconrect_path.size.x)
	destination += iconrect_path.size/2
	tween.tween_property(self, "global_position", destination, 0.15).set_trans(Tween.TRANS_SINE)
	selected = false
