extends MeshInstance3D
class_name FloorAndTile


# Load Dependencies Scene
const Tiles = preload("res://scenes/tile.tscn")
const RED_MATERIAL = preload("res://assets/materials/red_mat.tres")
const TILES_PRIMARY = preload("res://assets/materials/tiles_primary_mat.tres")

# Get Node from the tree
@onready var map = get_node("/root/main/Map")
@onready var gui = get_node("/root/main/Map/GUI")

# ------------------------------------------
@onready var static_body_3d = $StaticBody3D
@onready var _floor_array = map.floor_array

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
			#if slot_id not in gen_neigh_array:
				#return
			if map.floor_array[slot_id].occupied_by.currently_controlled:
				print("OCCUPIED")
				map.occupied_before = _floor_array[slot_id].occupied_by
				map.slot_id_occupied_before = slot_id
				map.hilight_material_gen_neigh_array(gui.create_material("BlackMaterial",gui.GREEN_MATERIAL))
			
		else :
			#if map.floor_array[slot_id].occupied_by
			print("NOT OCCUPIED or TARGET")
			print("Floor MAP  : ", map.gen_neigh_array)
			if map.gen_neigh_array.is_empty() or slot_id not in map.gen_neigh_array:
				return
			print("Not OCC")
			# Set the occupied to the next target floor
			_floor_array[slot_id].occupied_by = map.occupied_before
			# Set the from (player floor before move position) floor to null 
			_floor_array[map.slot_id_occupied_before].occupied_by = null
			map.hover_tiles(slot_id)
		
	if event.is_action_released("left_click"):
		map.is_mouse_clicked = false
		
## When the mouse enter the floor_map show the hover tiles
func _on_static_body_3d_mouse_entered():
	var tiles = _floor_array[slot_id].get_child(1).get_child(1)
	tiles.set_surface_override_material(0,gui.create_material("BlackMaterial",gui.GREEN_MATERIAL))
	is_exited = false

## When the mouse exited the floor_map clear the hover tiles
func _on_static_body_3d_mouse_exited():
	is_exited = true
	gui.reset_tile_material(slot_id)


