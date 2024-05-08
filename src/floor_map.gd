extends MeshInstance3D
class_name FloorAndTile


# Load Dependencies Scene
const Tiles = preload("res://scenes/tile.tscn")
const RED_MATERIAL = preload("res://assets/materials/red_mat.tres")
const TILES_PRIMARY = preload("res://assets/materials/tiles_primary_mat.tres")

# Map
@onready var map = get_node("/root/main/Map")
# ------------------------------------------
@onready var player_number = map.player_number
@onready var static_body_3d = $StaticBody3D
@onready var gen_neigh_array = map.gen_neigh_array
@onready var _floor_array = map.floor_array
@onready var _is_block_active = map.is_block_active
@onready var _is_boost_active = map.is_boost_active

# GUI
@onready var gui = get_node("/root/main/Map/GUI")

var slot_id
var player_controlled

# For the hovering Tiles
var is_exited = true



@onready var occupied_by


func _ready():
	# Signal to the static_body 
	static_body_3d.mouse_entered.connect(_on_static_body_3d_mouse_entered)
	static_body_3d.mouse_exited.connect(_on_static_body_3d_mouse_exited)
	static_body_3d.input_event.connect(_on_input_event)
	
	set_tiles()
	#print("FILTER ARRAY FLOOR MAP : ", map.player_number)
func set_tiles():
	var tiles_instantiated = Tiles.instantiate()
	tiles_instantiated.position.y = 0.56
	tiles_instantiated.rotation.y = -PI/2
	add_child(tiles_instantiated)

func _on_input_event(camera, event, position, normal, shape_idx):
	if event.is_action_pressed("left_click"):
		
		print("Current slot_id : ", slot_id)
		map.is_mouse_clicked = true
		
		if map.floor_array[slot_id].occupied_by: 
			map.check_tiles(slot_id)
			map.hover_tiles(slot_id)
			if map.floor_array[slot_id].occupied_by.currently_controlled:
				print("OCCUPIED")
				print(_floor_array[slot_id].occupied_by)
				map.occupied_before = _floor_array[slot_id].occupied_by
				map.slot_id_occupied_before = slot_id
				
				
				map.hilight_material_gen_neigh_array(gui.create_material("BlackMaterial",gui.BLACK_MATERIAL))
			
		else :
			#if map.floor_array[slot_id].occupied_by
			print("NOT OCCUPIED or TARGET")
			print("Floor MAP  : ", map.gen_neigh_array)
			if map.gen_neigh_array.is_empty():
				return
			print("OCUUPIED FLOOR CHANGE")
			# Set the occupied to the next target floor
			_floor_array[slot_id].occupied_by = map.occupied_before
			# Set the from (player floor before move position) floor to null 
			_floor_array[map.slot_id_occupied_before].occupied_by = null
			
			#print(_floor_array[slot_id_occupied_before].occupied_by)
			map.hover_tiles(slot_id)
		Utils.slot_id = slot_id
		#
		#print("Floor MAP  : ", map.gen_neigh_array)
		
	if event.is_action_released("left_click"):
		map.is_mouse_clicked = false
		
## When the mouse enter the floor_map show the hover tiles
func _on_static_body_3d_mouse_entered():
	#print(gen_neigh_array)
	var tiles = _floor_array[slot_id].get_child(1)
	tiles.set_surface_override_material(0,gui.create_material("BlackMaterial",gui.BLACK_MATERIAL))
	is_exited = false

## When the mouse exited the floor_map clear the hover tiles
func _on_static_body_3d_mouse_exited():
	is_exited = true
	reset_tile_material()
		
func reset_tile_material():
	# Generated Nighborhood Array
	if !map.gen_neigh_array.has(slot_id) :
		map.floor_array[slot_id].get_child(1).set_surface_override_material(0,gui.create_material("TilesPrimaryMaterial",gui.TILES_PRIMARY_MATERIAL))
		map.set_start_and_finish_tile_material(player_number)
