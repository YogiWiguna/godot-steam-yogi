extends Node3D
class_name Map


# ONREADY 
@onready var floor = preload("res://scenes/floor_map.tscn")
@onready var Character = preload("res://scenes/character.tscn")


# Dependencies
@onready var main = get_node("/root/main")
@onready var gui = get_node("/root/main/Map/GUI")

# Variable on Tree
@onready var floor_map_region: Node3D = $FloorMapRegion
@onready var timer: Timer = $Timer
@onready var phase_timer: Timer = $PhaseTimer

# VAR 
@onready var player_number : int
@onready var default_row : int
var target_tile_vector_z = []
var target_tile_vector_x = []
@onready var tile = preload("res://scenes/tile.tscn")
# Floor
var floor_array := []
var floor_array_slot_id := []
var slot_array := []
var floor_instantiated
var gen_neigh_array := []
var random_tiles_on_floors := []


var timer_count = false
var menu_player_active = false
var is_player_try_move = false

var is_phase_two = false
var is_phase_two_second = false
var is_block_ui = true
var is_boost_ui = true
var is_spawn_ui = true
var is_stack_ui = true
var is_player_move = false
var is_menu_player_active = false
var is_grab_button = false
var is_put_button = false
var is_block_active = false
var is_boost_active = false
var canera_first_rotation = false
var _player_action = 2
var is_mouse_clicked = false

var occupied_before
var sprite_texture

signal player_number_active

## Player Mesh
@onready var character_instance = preload("res://scenes/character.tscn")
# --- Mat for Loaded Mat
@onready var bob_mat = preload("res://assets/materials/bob_mat.tres")
@onready var masbro_mat = preload("res://assets/materials/masbro_mat.tres")
@onready var gatot_mat = preload("res://assets/materials/gatot_mat.tres")
@onready var oldpops_mat = preload("res://assets/materials/oldpop_mat.tres")

func _ready():
	#DebugMenu.style = DebugMenu.Style.VISIBLE_DETAILED
	player_number = 4
	
	default_row = 10
	player_number_active.emit()
	print("player number ", player_number)
	# Create 40x floor
	for floor in range(player_number * 10):
		set_floor()
	
	generate_tile_coord(default_row, player_number)
	
	set_x_z_floor_array()
	
	set_random_id_for_tile()
	
	set_sprite_to_tiles(player_number)
	
	set_slot_id()
	
	for x in range(player_number):
		spawn_character_based_on_tile_slot(x)
	
	set_start_and_finish_tile_material(player_number)
	
	# Change Mat correspond to player
	
	#print(get_tree().get_nodes_in_group("character"))
	
	gui._menu_player.hide()
	
	sprite_texture = null
	
	gui._action_player_label.text = "Action Player : %s" % _player_action
	
	# Setup Player Materials
	match_character_mats()

func _process(delta):
	
	#if canera_first_rotation:
		##print("CAMERA ROTATION")
		#camera_first.rotation = Vector3(-80,0,0)
	if timer_count:
		gui._timer_label.text = "Timer : %s" % str(roundf(timer.time_left))
	
	
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
	
	floor_map_region.position = Vector3(0.5, 0, 0.5)
	# Instantiated floor_map
	floor_instantiated = floor.instantiate()
	# Slot_id 
	floor_instantiated.slot_id = floor_array.size()
	floor_array_slot_id.append(floor_instantiated.slot_id)
	floor_array.push_back(floor_instantiated)
	floor_map_region.add_child(floor_instantiated, true)
	
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
	for key in range(1, 5):
		# Loop 8 times to add the integer exactly 8 times
		for i in range(15): 
			# Append the integer to the array
			random_tiles_on_floors.append(key)      
			# Shuffle the array to randomize the order
			random_tiles_on_floors.shuffle()
			# Print the generated array
	#print(random_tiles_on_floors)
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
func set_slot_id():
	var id = 0
	
	for slot in range(floor_array.size()):
		var slot_id = floor_array[slot].slot_id
		slot_array.append(slot_id)


func hilight_material_gen_neigh_array(material):
	for i in range(gen_neigh_array.size()):
		#Set the Tiles surface material on each Tiles based on the "j" variable into Black material
		var hover_show = floor_array[gen_neigh_array[i]].get_child(1)
		#print(hover_show)
		hover_show.set_surface_override_material(0,material)
#
func check_tiles(slot_id):
	#print("FLOOR SLOT ID: ", Utils.slot_id)
	# Set the slot_id into the mouse_selected
	var mouse_selected = slot_id
	#print("Mouse selected :",mouse_selected)
	var check_arr := []
	#print("Selected id:",mouse_selected)
	match player_number:
		3: pass
		4: 
			match mouse_selected:
				# First Row
				0: 
					var id = [0,0,0,0,0,0,4,5]
					check_arr = id
				1,2:
					const id = [0,0,0,0,0,3,4,5]
					check_arr = id
				3: 
					const id = [0,0,0,0,0,3,4,0]
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
	
	# Add the slot_id into the gen_neigh_array 
	#gen_neigh_array.append(mouse_selected)
	
	
	#floor.gen_neigh_array = gen_neigh_array
	#print("FILTER ARRAY BEFORE :", gen_neigh_array)
	
	if gen_neigh_array.size() == 0:
		for i in check_arr:
			if i != 0:
				gen_neigh_array.append(i + mouse_selected)
	for i in gen_neigh_array:
		if floor_array[i].occupied_by != null:
			var index_occupied = gen_neigh_array.find(i)
			gen_neigh_array.remove_at(index_occupied)
	#print("FILTER ARRAY AFTER :", gen_neigh_array)
	#Utils.map_gen_neigh_array = gen_neigh_array
	print("GEN NEIGH :", gen_neigh_array) 
	
	

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
func menu_player_disabled(status : bool):
	gui._move_button.disabled = status
	gui._grab_tiles_button.disabled = status
	gui._put_tiles_button.disabled = status
	gui._end_phase_button.disabled = status
	gui._end_turn_button.disabled = status

func hover_tiles(clicked_id):
	print(clicked_id)
	var _move_to = str("Move To: %s " % clicked_id)
	var tiles_token_sprite_sprite_3d = floor_array[clicked_id].get_child(1).get_child(0)
	
	
	print("is menu player active : ", is_menu_player_active)
	# If the ui_player_active (set true on the move_button), do with the Autoload
	if is_menu_player_active:
		# Check if the gen_neigh_array is not empty
		# Check if the gen_neigh_array has slot_id
		print("is menu player active NEIGHBOR:", gen_neigh_array)
		# If slot_id is neighbors , Example [0,1,4,5] 
		
		if !gen_neigh_array.is_empty() && gen_neigh_array.has(clicked_id) :
			# 0 is the first value in Utils.gen_neigh_array[0], others than that will go move 
			# Check if the Utils.mouse_selected (Slot_id from ray_cast player) is not the same with click_id 
			if gen_neigh_array[0] != clicked_id && Utils.mouse_selected != clicked_id:
				
				gui._move_label.text = _move_to
				#print(Utils.move_label.text)
				# Set the Utils.player_move to enable in physics process in player (to move player)
				is_player_move = true
				_player_action -= 1
				gui._action_player_label.text = "Action Player : %s" % _player_action
				gui._end_turn_button.disabled = false
				gui._end_phase_button.disabled = false
				# Disabled the move_button 
				gui._move_button.disabled = true
				#print(Utils.floor_array[clicked_id])
				#print("SPRITE 3D : ", sprite_3d.texture)
				## CHECK THE CURRENT SPRITE 
				if tiles_token_sprite_sprite_3d.texture != null:
					gui._grab_tiles_button.disabled = false
					#print("UTils.grab button : ", Utils.grab_button)
					if is_put_button or is_grab_button:
						gui._grab_tiles_button.disabled = true
				else : 
					is_grab_button.disabled = true
					is_put_button.disabled = false
					if is_put_button or is_grab_button:
						gui._put_tiles_button.disabled = true
				#print("PLAYER MOVE")
			
			if Utils.mouse_selected == clicked_id:
				gui._menu_player.hide()

			# Unhover the tiles if slot_id is the first value in Utils.gen_neigh_array[0]
			unhover_tiles(gen_neigh_array)
			# Set the menu_player_active to false 
			is_menu_player_active = false
			
			if clicked_id == 0 or clicked_id == 1 or clicked_id == 2 or clicked_id == 3 or clicked_id == 36 or clicked_id == 37 or clicked_id == 38 or clicked_id == 39:
				gui._put_tiles_button.disabled = true
			# Set return for stop the function
			return
			
	# Check if the gen_neigh_array in empty
	if gen_neigh_array.is_empty():
		pass
	else :
		print("ELSE")
		for x in range(floor_array.size()):
			if clicked_id == floor_array[x].slot_id && floor_array[x].occupied_by != null && gui.is_menu_player_show == false && is_mouse_clicked == true:
				gui._menu_player.show()
				gui.is_menu_player_show = true
				is_menu_player_active = true
				floor_array[clicked_id].occupied_by.currently_controlled = true
				print("GENERATE NEIGH ARRAY :", gen_neigh_array)
			elif clicked_id == floor_array[x].slot_id && gui.is_menu_player_show == true && is_mouse_clicked == true:	
				# If generated array isn't null & menu player showing, reset it			
				print("GENERATED NEIGH ARR : ",gen_neigh_array)
				# ---
				floor_array[clicked_id].occupied_by.currently_controlled = false
				is_menu_player_active = false
				gui._menu_player.hide()
				gui.is_menu_player_show = false
				# Unhover the tiles , that has been hover before
				for floor in gen_neigh_array:
					floor_array[floor].get_child(1).set_surface_override_material(0,gui.create_material("TilesPrimaryMaterial",gui.TILES_PRIMARY_MATERIAL))
					print(floor_array[floor].get_child(1).get_surface_override_material(0))
				gen_neigh_array = []

func unhover_tiles(_gen_neigh_array):
	print("Filter Array : ", gen_neigh_array)
	for x in range(floor_array.size()):
		var xtm = floor_array[x].get_child(1)
		# Check the TILES surface material is occupied based on the "x" variable
		
		#if hover_show.get_surface_override_material(0) != null:
		## Set the surface material into null or empty
			#hover_show.set_surface_override_material(0,GREEN_MATERIAL)
		set_start_and_finish_tile_material(player_number)
	# Set the Utils.filtter_arrray into null
	gen_neigh_array = []


# SIGNAL BUTTON 
func _on_move_button_pressed():
	#print("MoveButton")
	#is_menu_player_active = true
	#check_tiles()
	print("MOVE BUTTON : ", gen_neigh_array)
	#hilight_material_gen_neigh_array(gui.create_material("BlackMaterial",gui.BLACK_MATERIAL))
	is_player_try_move = true
	gui._end_turn_button.disabled = true
	gui._end_phase_button.disabled = true

func _on_grab_tiles_button_pressed():
	## TAKE THE SPRITE FROM THE PLAYER CURRENT TILES
	# Load the texture from the current position of the player 
	# Change the texture into the sprite path 
	#if texture_rect.texture == null:
		#return
	gui._texture_rect_debug.texture = load(Utils.sprite_path_grab_from_tiles)
	#print(floor_array[Utils.mouse_selected].get_child(1).get_child(0))
	# Set the tiles texture into null (because we grab it and display it into the texture_rect)
	var sprite_texture = floor_array[Utils.mouse_selected].get_child(1).get_child(0)
	gui.sprite_texture.texture = null
	Utils.sprite_texture = null
	#print("Setelah : ", sprite_texture)
	
	# Disabled button 
	gui._grab_tiles_button.disabled = true
	gui._put_tiles_button.disabled = true
	# Set the Utils.grab_button for the movement in (floor_map.gd)
	is_grab_button = true
	_player_action -= 1
	gui._action_player_label.text = "Action Player : %s" % _player_action

func _on_put_tiles_button_pressed():
	# GET THE CURRENT SPRITE OF THE PLAYER POSITION
	var sprite_3d = floor_array[Utils.mouse_selected].get_child(1).get_child(0)
	var sprite_texture = sprite_3d.texture
	# GET the texture of the texture rect 
	var texture_spawn = gui._texture_rect_debug.texture
	#print("PUT TILES")
	#print(sprite_texture)
	#print(texture_spawn)
	
	# Check if the sprite_texture is null, set the texture_spawn to sprite_texture
	if sprite_texture == null:
		sprite_3d.texture = texture_spawn
	
	# Disabled button
	gui._grab_tiles_button.disabled = true
	gui._put_tiles_button.disabled = true
	# Set the Utils.put_button for the movement in (floor_map.gd)
	is_put_button = true
	_player_action -= 1
	gui._action_player_label.text = "Action Player : %s" % _player_action

func _on_end_phase_button_pressed():
	#print("END PHASE")
	
	## START THE TIMER AFTER PRESS THE END TURN 
	phase_timer.start()
	#print("TIMER",timer)
	gui._phase_label.text = "Main Phase 2"
	gui._phase_label.visible = true
	# Disabled the children of the menu player
	menu_player_disabled(true)
	
	# SET THE Utils.grab_button and Utils.put_button into false 
	# So if the player click the tiles again the button is disabled 
	is_grab_button = false
	is_put_button = false
	gui._end_phase_button.visible = false

func _on_end_turn_button_pressed():
	#path_follow_3d.set_progress(0)
	#path_follow_3d.rotation_degrees = Vector3(0,0,0)
	#camera_first.rotation_degrees = Vector3(0,0,0)
	## START THE TIMER AFTER PRESS THE END TURN 
	timer.wait_time = 5
	timer.start()
	
	#print("TIMER",timer)
	#gui._timer_label.text = "Timer : %s" % str(roundf(timer.time_left))
	timer_count = true
	
	# Disabled the children of the menu player
	menu_player_disabled(true)
	
	# SET THE Utils.grab_button and Utils.put_button into false 
	# So if the player click the tiles again the button is disabled 
	is_grab_button = false
	is_put_button = false
	#print("END TURN  : ", Utils.sprite_texture)
	gui._phase_label.text = "END OF YOUR TURN"
	gui._phase_label.visible = true
	#print("END TURN PHASE TWO: ", Utils.is_phase_two)
	#print("END TURN PHASE TWO SECOND : ", Utils.is_phase_two_second)
	if is_phase_two_second:
		is_phase_two = true

func _on_timer_timeout():
	#print("TIMER STOP")
	gui._phase_label.visible = false
	if is_phase_two_second:
		is_phase_two = true
	timer_count = false
	gui._menu_player.visible = false
	# Enable the men_player after the time is done 
	#menu_player_disabled(false)
	gui._move_button.disabled = false
	Utils.sprite_null = true
	#print("TIMER Mouse selected : ", Utils.mouse_selected)
	#print("TIMER Sprite Texture : ", Utils.sprite_texture)
	#if Utils.sprite_texture == null :
		#grab_tiles_button.disabled = true
		
	_player_action = 2
	gui._action_player_label.text = "Action Player : %s" % _player_action

func _on_phase_two_button_pressed():
	#end_phase_button.visible = true
	is_phase_two = true

func _on_random_tiles_pressed():
	set_random_id_for_tile()
	set_sprite_to_tiles(player_number)

func _on_phase_timer_timeout():
	gui._phase_label.visible = false
	gui._move_button.disabled = false
	is_phase_two = false
	gui._menu_player.visible = false
	
	_player_action = 2
	gui._action_player_label.text = "Action Player : %s" % _player_action
	#menu_player_disabled(false)

func _on_block_spawn_button_pressed():
	if is_block_ui:
		gui._block.visible = true
		#print("true")
		is_block_ui = false
	else:
		gui._block.visible = false
		#print("false")
		is_block_ui = true

func _on_boost_spawn_button_pressed():
	if is_boost_ui:
		gui._boost.visible = true
		is_boost_ui = false
	else:
		gui._boost.visible = false
		is_boost_ui = true

func _on_tiles_spawn_button_pressed():
	if is_spawn_ui:
		gui._tiles_spawn.visible = true
		is_spawn_ui = false
	else: 
		gui._tiles_spawn.visible = false
		is_spawn_ui = true

func _on_stack_spawn_button_2_pressed():
	if is_stack_ui:
		gui._stack.visible = true
		is_stack_ui = false
	else: 
		gui._stack.visible = false
		is_stack_ui = true
