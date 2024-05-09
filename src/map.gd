extends Node3D
class_name Map


# ONREADY 
@onready var floor = preload("res://scenes/floor_map.tscn")
@onready var tile = preload("res://scenes/tile.tscn")

# Dependencies
@onready var main = get_node("/root/main")
@onready var gui = get_node("/root/main/Map/GUI")

## Player Mesh
@onready var character_instance = preload("res://scenes/character.tscn")
# --- Mat for Loaded Mat
@onready var bob_mat = preload("res://assets/materials/bob_mat.tres")
@onready var masbro_mat = preload("res://assets/materials/masbro_mat.tres")
@onready var gatot_mat = preload("res://assets/materials/gatot_mat.tres")
@onready var oldpops_mat = preload("res://assets/materials/oldpop_mat.tres")

# VAR 
@onready var player_number : int
@onready var default_row : int
var target_tile_vector_z = []
var target_tile_vector_x = []

# Floor
var floor_array := []
var floor_array_slot_id := []
var slot_array := []
var floor_instantiated
var gen_neigh_array := []
var random_tiles_on_floors := []

# Variable for map(self)
var is_menu_player_active = false

# Variable for floor_map.gd
var occupied_before
var slot_id_occupied_before

# variable for player or character
var character_floor_sprite
var character_floor_sprite_path
var character_current_slot_id
var is_player_move = false

# Variable for gui
var is_mouse_clicked = false
var is_menu_player_show = false
var _player_action = 2

# Signal for a_star_map.gd (waiting the player_number exist)
signal player_number_active



func _ready():
	#DebugMenu.style = DebugMenu.Style.VISIBLE_DETAILED
	player_number = 4
	
	default_row = 10
	player_number_active.emit()
	#print("player number ", player_number)
	# Create 40x floor
	for floor in range(player_number * 10):
		set_floor()
	
	generate_tile_coord(default_row, player_number)
	
	set_x_z_floor_array()
	
	set_random_id_for_tile()
	
	set_sprite_to_tiles(player_number)
	
	#set_slot_id()
	
	for x in range(player_number):
		spawn_character_based_on_tile_slot(x)
	
	set_start_and_finish_tile_material(player_number)
	
	# Setup Player Materials
	match_character_mats()

# ---
func set_start_and_finish_tile_material(player_number : int):
	var tiles
	match player_number:
		3: for x in floor_array_slot_id:
			match x:
				0,1,2,27,28,29:
					tiles = floor_array[x].get_child(1)
					tiles.set_surface_override_material(0,null)
		4: for x in floor_array_slot_id:
			match x:
				0,1,2,3,36,37,38,39:
					tiles = floor_array[x].get_child(1)
					tiles.set_surface_override_material(0,null)
		5: for x in floor_array_slot_id:
			match x:
				0,1,2,3,4,45,46,47,48,49:
					tiles = floor_array[x].get_child(1)
					tiles.set_surface_override_material(0,null)
		6: for x in floor_array_slot_id:
			match x:
				0,1,2,3,4,5,54,55,56,57,58,59:
					tiles = floor_array[x].get_child(1)
					tiles.set_surface_override_material(0,null)
#
func set_floor():
	gui.floor_map_region.position = Vector3(0.5, 0, 0.5)
	# Instantiated floor_map
	floor_instantiated = floor.instantiate()
	# Slot_id 
	floor_instantiated.slot_id = floor_array.size()
	floor_array_slot_id.append(floor_instantiated.slot_id)
	floor_array.push_back(floor_instantiated)
	gui.floor_map_region.add_child(floor_instantiated, true)
#
func generate_tile_coord(row, column):
	for x in range(row):
		for z in range(column):
			target_tile_vector_z.append(z)
			target_tile_vector_x.append(x)
#
func set_x_z_floor_array():
	for i in range(default_row * player_number):
		var fa = floor_array[i]
		var ttvx = target_tile_vector_x[i]
		var ttvz = target_tile_vector_z[i]
		# ----
		fa.position.x = ttvx
		fa.position.z = ttvz

# SET RANDOM ID FOR THE TILES SPRITE
func set_random_id_for_tile():
	# Initialize an empty array named "tiles_random_array"
	random_tiles_on_floors = []
	# Loop through each integer value (1 to 4)
	for key in range(1, player_number + 1):
		# Loop 8 times to add the integer exactly 8 times
		for i in range(10): 
			# Append the integer to the array
			random_tiles_on_floors.append(key)      
			# Shuffle the array to randomize the order
			random_tiles_on_floors.shuffle()
			# Print the generated array
	#print(random_tiles_on_floors.count(1))
	#print(random_tiles_on_floors.count(2))
	#print(random_tiles_on_floors.count(3))
	#print(random_tiles_on_floors.count(4))

# SET THE SPRITE FOR EVERY TILE (8 max)
func set_sprite_to_tiles(player_number):
	var size = floor_array.size()
	var size_min = size - player_number
	
	for key in floor_array:
		var tile = floor_array[key.slot_id].get_children()
		var sprite = tile[1].get_child(0)
		sprite.texture = load("res://assets/tiles/tiles_"+ str(random_tiles_on_floors[key.slot_id]) +"_diffuse_tex"+".png")
		if key.slot_id in range(player_number):
			sprite.texture = null
		if key.slot_id in range(size_min, size):
			sprite.texture = null
# 
#func set_slot_id():
	#var id = 0
	#
	#for slot in range(floor_array.size()):
		#var slot_id = floor_array[slot].slot_id
		#slot_array.append(slot_id)
#
func hilight_material_gen_neigh_array(material):
	for i in range(gen_neigh_array.size()):
		#Set the Tiles surface material on each Tiles based on the "j" variable into Black material
		var hover_show = floor_array[gen_neigh_array[i]].get_child(1)
		#print(hover_show)
		hover_show.set_surface_override_material(0,material)
#
func check_tiles(slot_id):
	# Set the slot_id into the mouse_selected
	var mouse_selected = slot_id
	#print("Mouse selected :",mouse_selected)
	var check_arr := []
	var occupied_arr := []
	var new_array := []
	#print("Selected id:",mouse_selected)
	match player_number:
		3: pass
		4: 
			match mouse_selected:
				# First Row
				0: 
					var id = [0,0,0,0,1,0,4,5]
					check_arr = id
				1,2:
					const id = [0,0,0,-1,1,3,4,5]
					check_arr = id
				3: 
					const id = [0,0,0,-1,0,3,4,0]
					check_arr = id
				# Body Row
				4,8,12,16,20,24,28,32:
					const id = [0,-4,-3,0,1,0,4,5]
					check_arr = id
				5,6,9,10,13,14,17,18,21,22,25,26,29,30,33,34:
					const id = [-5,-4,-3,-1,1,3,4,5]
					check_arr = id 
				7,11,15,19,23,27,31,35:
					const id = [-5,-4,0,-1,0,3,4,0]
					check_arr = id
				# Last Row
				36:
					const id = [0,-4,-3,0,1,0,0,0]
					check_arr = id
				37,38:
					const id = [-5,-4,-3,-1,1,0,0,0]
					check_arr = id
				39:
					const id = [-5,-4,0,-1,0,0,0,0]
					check_arr = id
		5: 
			match mouse_selected:
				# First Row
				0: 
					var id = [0,0,0,0,0,0,5,6]
					check_arr = id
				1,2,3:
					const id = [0,0,0,0,0,4,5,6]
					check_arr = id
				4: 
					const id = [0,0,0,0,0,4,5,0]
					check_arr = id
				# Body Row
				# Right Section
				#4,8,12,16,20,24,28,32:
				5,10,15,20,25,30,35,40:
					const id = [0,-4,-3,0,1,0,4,5]
					check_arr = id
				# Mid Section
				#5,6,9,10,13,14,17,18,21,22,25,26,29,30,33,34:
				6,7,8,11,12,13,16,17,18,21,22,23,26,27,28,31,32,33,36,41,42,43:
					const id = [-5,-4,-3,-1,1,3,4,5]
					check_arr = id
				# Left Section 
				9,14,19,24,29,34,39,44:
					const id = [-6,-5,0,-1,0,4,5,0]
					check_arr = id
				# Last Row
				45:
					const id = [0,-5,-4,0,1,0,0,0]
					check_arr = id
				46,47,48:
					const id = [-6,-5,-4,-1,1,0,0,0]
					check_arr = id
				49:
					const id = [-6,-5,0,-1,0,0,0,0]
					check_arr = id
		6: pass
	
	# Append the neighbor array
	if gen_neigh_array.size() == 0:
		for i in check_arr:
			if i != 0:
				gen_neigh_array.append(i + mouse_selected)
	
	# Checking the occupied by player floor 
	for i in range(floor_array.size()):
		if floor_array[i].occupied_by != null:
			occupied_arr.append(i)
	
	# Compare the neighbors array with occupied by player 
	# The result is not matching 
	for i in gen_neigh_array:
		if i not in occupied_arr:
			new_array.append(i)
	# The result mush gen_neigh_array
	gen_neigh_array = []
	gen_neigh_array = new_array 

# Spawn Character on top of Tiles, based on transform.position
func spawn_character_based_on_tile_slot(slot_id):
	var instantiate_character = character_instance.instantiate()
	var character_offset = Vector3(0.5, 0.6, 0.5)
	add_child(instantiate_character, true)
	instantiate_character.position.x = character_offset.x + target_tile_vector_x[slot_id]
	instantiate_character.position.y = character_offset.y
	instantiate_character.position.z = character_offset.z + target_tile_vector_z[slot_id]
	instantiate_character.rotation.y = PI/2
	# Assign floor_array occupied_by to instantiate_character object
	floor_array[slot_id].occupied_by = instantiate_character
	# Assign opposite
	instantiate_character.player_location = floor_array[slot_id]
#
func get_floor_postion(slot_id):
	for x in range(floor_array.size()):
		var floor = floor_array[x]
		slot_id = floor_array[x].slot_id
		return floor.position
#
func get_floor_occupied_status(slot_id):
	for x in range(floor_array.size()):
		var floor_occupied_by = floor_array[x].occupied_by
		return floor_occupied_by
#
# Change mats based on choice character selected
func match_character_mats():
	var get_player = get_tree().get_nodes_in_group("character")
	for x in range(get_player.size()):
		var key = get_player[x]
		var key_char = key.current_char
		var key_mat = key.get_node("Armature/Skeleton3D/Bob")
		match key_char:
			"bob":
				key_mat.set_surface_override_material(0, bob_mat)
			"masbro":
				key_mat.set_surface_override_material(0, bob_mat)
			"gatot":
				key_mat.set_surface_override_material(0, bob_mat)
			"oldpops":
				key_mat.set_surface_override_material(0, oldpops_mat)
#


func hover_tiles(clicked_id):
	# For player moving
	if is_menu_player_active:
		# Check if the gen_neigh_array is not empty
		# Check if the gen_neigh_array has slot_id
		print("is menu player active NEIGHBOR:", gen_neigh_array)
		# If slot_id is neighbors , Example [0,1,4,5] 
		if !gen_neigh_array.is_empty() && gen_neigh_array.has(clicked_id) :
			print("PLAYER MOVING")
			#print(Utils.move_label.text)
			is_player_move = true
			_player_action -= 1
			
			#for floor in gen_neigh_array:
				#floor_array[floor].get_child(1).set_surface_override_material(0,gui.create_material("TilesPrimaryMaterial",gui.TILES_PRIMARY_MATERIAL))
			# Unhover the tiles if slot_id is the first value in Utils.gen_neigh_array[0]
			unhover_tiles(gen_neigh_array)
			
			# Set the menu_player_active to false 
			is_menu_player_active = false
			return
	
	# Checking if gen_neigh_array is empty
	if gen_neigh_array.is_empty():
		pass
	# Checking if gen_neigh_array is not empty
	else :
		print("ELSE")
		for x in range(floor_array.size()):
			if clicked_id == floor_array[x].slot_id && floor_array[x].occupied_by != null && is_menu_player_show == false && is_mouse_clicked == true:
				print("IN")
				#gui._menu_player.show()
				is_menu_player_show = true
				is_menu_player_active = true
				floor_array[clicked_id].occupied_by.currently_controlled = true
				
			elif clicked_id == floor_array[x].slot_id && is_menu_player_show == true && is_mouse_clicked == true:
				# If generated array isn't null & menu player showing, reset it			
				# ---
				print("OUT")
				#gui._menu_player.hide()
				is_menu_player_show = false
				is_menu_player_active = false
				floor_array[clicked_id].occupied_by.currently_controlled = false
				# Unhover the tiles , that has been hover before
				unhover_tiles(gen_neigh_array)
				gen_neigh_array = []

func unhover_tiles(_gen_neigh_array):
	print("Filter Array : ", _gen_neigh_array)
	for floor in _gen_neigh_array:
		floor_array[floor].get_child(1).set_surface_override_material(0,gui.create_material("TilesPrimaryMaterial",gui.TILES_PRIMARY_MATERIAL))
		#set_start_and_finish_tile_material(player_number)
	# Set the Utils.filtter_arrray into null
	gen_neigh_array = []


