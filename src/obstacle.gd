extends Node3D

@onready var camera = get_node("/root/main/Map/Camera3D")
@onready var gui = get_node("/root/main/Map/GUI")

const BLOCK = preload("res://scenes/spawn/block.tscn")
const BOOST = preload("res://scenes/spawn/boost.tscn")
const STACK = preload("res://scenes/spawn/stack.tscn")
const TILES_SPAWN = preload("res://scenes/spawn/tiles_spawn.tscn")


# BOOST
var is_boost_ui = true
var is_boost = false
var is_boost_up_pressed = false
var is_boost_down_pressed = false
var is_boost_left_pressed = false
var is_boost_right_pressed = false
var boost_up_array = []
var boost_down_array = []
var boost_left_array = []
var boost_right_array = []
var boost_up_count = 1
var boost_down_count = 1
var boost_left_count = 1
var boost_right_count = 1

# BLOCK
var is_block_ui = true
var is_block = false
var is_obstacle_block_horizontal = false
var is_obstacle_block_vertical = false
var is_spawn_block_horizontal = true
var is_spawn_block_vertical = true
var is_grid_id_array_horizontal_0 = false
var is_grid_id_array_vertical_0 = false
var grid_id_array_horizontal = []
var grid_id_array_vertical = []
var block_horizontal_count = 2
var block_vertical_count = 2

# TILES SPAWN
var is_tiles_spawn_ui = true
var is_tiles_spawn = false
var is_tiles_spawn_coin = false
var is_tiles_spawn_heart = false
var is_tiles_spawn_diamond = false
var is_tiles_spawn_star = false
var tiles_spawn_coin_array = []
var tiles_spawn_heart_array = []
var tiles_spawn_diamond_array = []
var tiles_spawn_star_array = []
var tiles_spawn_coin_count = 1
var tiles_spawn_diamond_count = 1
var tiles_spawn_star_count = 1
var tiles_spawn_heart_count = 1

# STACK
var is_stack_ui = true
var is_stack = false
var stack_id_array = []
var stack_count = 4


func _input(event):
	
	if is_obstacle_block_horizontal:
		if event.is_action_pressed("left_click"):
			spawn_obstacle_blocks_horizontal()
			is_obstacle_block_horizontal = false
	
	if is_obstacle_block_vertical:
		if event.is_action_pressed("left_click"):
			spawn_obstacle_blocks_vertical()
			is_obstacle_block_vertical = false
	
	if is_boost_up_pressed:
		if event.is_action_pressed("left_click"):
			spawn_boost_up()
			is_boost_up_pressed = false
	
	if is_boost_down_pressed:
		if event.is_action_pressed("left_click"):
			spawn_boost_down()
			is_boost_down_pressed = false
	
	if is_boost_left_pressed:
		if event.is_action_pressed("left_click"):
			spawn_boost_left()
			is_boost_left_pressed = false
	
	if is_boost_right_pressed:
		if event.is_action_pressed("left_click"):
			spawn_boost_right()
			is_boost_right_pressed = false
	
	if is_tiles_spawn_coin:
		if event.is_action_pressed("left_click"):
			tiles_spawn_coin()
			is_tiles_spawn_coin = false
	
	if is_tiles_spawn_heart:
		if event.is_action_pressed("left_click"):
			tiles_spawn_heart()
			is_tiles_spawn_heart = false
	
	if is_tiles_spawn_diamond:
		if event.is_action_pressed("left_click"):
			tiles_spawn_diamond()
			is_tiles_spawn_diamond = false
	
	if is_tiles_spawn_star:
		if event.is_action_pressed("left_click"):
			tiles_spawn_star()
			is_tiles_spawn_star = false
	
	if is_stack:
		if event.is_action_pressed("left_click"):
			stack_spawn()
			is_stack = false


func array_for_checking_tiles(array):
	for i in range(12,36):
		array.append(i)

func block_vertical_first_index(spawn_block_array):
	match grid_id_array_vertical[0]:
		12,16,20,24,28,32:
			var id = grid_id_array_vertical[0] + 4
			var find_index_id = spawn_block_array.find(id)
			spawn_block_array.remove_at(find_index_id)
		13,14,15,17,18,19,21,22,23,25,26,27,29,30,31,33,34,35:
			var id = grid_id_array_vertical[0] + 3
			var find_index_id = spawn_block_array.find(id)
			spawn_block_array.remove_at(find_index_id)
			
			var id_2 = grid_id_array_vertical[0] + 4
			var find_index_id_2 = spawn_block_array.find(id_2)
			spawn_block_array.remove_at(find_index_id_2)
			
			var id_3 = grid_id_array_vertical[0] - 1
			var find_index_id_3 = spawn_block_array.find(id_3)
			spawn_block_array.remove_at(find_index_id_3)

func  block_vertical_second_index(spawn_block_array):
	match grid_id_array_vertical[1]:
		12,16,20,24,28,32:
			var id = grid_id_array_vertical[1] + 4
			var find_index_id = spawn_block_array.find(id)
			spawn_block_array.remove_at(find_index_id)
		13,14,15,17,18,19,21,22,23,25,26,27,29,30,31,33,34,35:
			var id = grid_id_array_vertical[1] + 3
			var find_index_id = spawn_block_array.find(id)
			spawn_block_array.remove_at(find_index_id)
			
			var id_2 = grid_id_array_vertical[1] + 4
			var find_index_id_2 = spawn_block_array.find(id_2)
			spawn_block_array.remove_at(find_index_id_2)
			
			var id_3 = grid_id_array_vertical[1] - 1
			var find_index_id_3 = spawn_block_array.find(id_3)
			spawn_block_array.remove_at(find_index_id_3)

func block_horizontal_first_index(spawn_block_array):
	match grid_id_array_horizontal[0]:
		15,19,23,27,31,35 :
			var id = grid_id_array_horizontal[0] - 4
			var find_index_id = spawn_block_array.find(id)
			spawn_block_array.remove_at(find_index_id)
		12,13,14,16,17,18,20,21,22,24,25,26,28,29,30,32,33,34:
			var id = grid_id_array_horizontal[0] - 4
			var find_index_id = spawn_block_array.find(id)
			spawn_block_array.remove_at(find_index_id)
			
			var id_2 = grid_id_array_horizontal[0] - 3
			var find_index_id_2 = spawn_block_array.find(id_2)
			spawn_block_array.remove_at(find_index_id_2)
			
			var id_3 = grid_id_array_horizontal[0] + 1
			var find_index_id_3 = spawn_block_array.find(id_3)
			spawn_block_array.remove_at(find_index_id_3)


# Rules for Horizontal Block Second Index
func block_horizontal_second_index(spawn_block_array):
	match grid_id_array_horizontal[1]:
		15,19,23,27,31,35 :
			var id = grid_id_array_horizontal[1] - 4
			var find_index_id = spawn_block_array.find(id)
			spawn_block_array.remove_at(find_index_id)
		12,13,14,16,17,18,20,21,22,24,25,26,28,29,30,32,33,34:
			var id = grid_id_array_horizontal[1] - 4
			var find_index_id = spawn_block_array.find(id)
			spawn_block_array.remove_at(find_index_id)
			
			var id_2 = grid_id_array_horizontal[1] - 3
			var find_index_id_2 = spawn_block_array.find(id_2)
			spawn_block_array.remove_at(find_index_id_2)
			
			var id_3 = grid_id_array_horizontal[1] + 1
			var find_index_id_3 = spawn_block_array.find(id_3)
			spawn_block_array.remove_at(find_index_id_3)

func spawn_obstacle_blocks_horizontal():
	print("SPAWN BLOCK HORIZONTAL")
	camera.set_token_to_mouse()
	print("camera result : ", camera.result)
	#print("GRID ID : ",camera.result["collider"].get_parent().slot_id)
	if camera.result.is_empty():
		return
	var grid = camera.result["collider"].get_parent()
	var grid_id = grid.slot_id
	#print("VERTICAL FIRST INDEX :",grid_id_array_vertical[0] )
	var spawn_block_array = []
	var block = grid.get_children()
	for block_horizontal in block:
		if block_horizontal.name == "BlockHorizontal" or block_horizontal.name == "BlockVertical":
			return
	# Placement for first block_vertical
	if is_spawn_block_horizontal:
		array_for_checking_tiles(spawn_block_array)
	
	# Placement for second block_vertical
	if !is_spawn_block_horizontal:
		match grid_id_array_horizontal[0] :
			12,13,14,15:
				for i in range(24,36):
					spawn_block_array.append(i)
			16,17,18,19:
				for i in range(28,36):
					spawn_block_array.append(i)
			20,21,22,23:
				for i in range(32,36):
					spawn_block_array.append(i)
			24,25,26,27:
				for i in range(12,16):
					spawn_block_array.append(i)
			28,29,30,31:
				for i in range(12,20):
					spawn_block_array.append(i)
			32,33,34,35:
				for i in range(12,24):
					spawn_block_array.append(i)
	# Check probabilty of the priority placement
	# Note, H: horizontal, V : Vertical
	# Example : HHVV,HVHV,HVVH,VVHH.VHVH,VHHV
	if grid_id_array_vertical.size() == 1:
		block_vertical_first_index(spawn_block_array)
	if grid_id_array_vertical.size() == 2 :
		block_vertical_second_index(spawn_block_array)
	if grid_id_array_vertical.size() == 1 && grid_id_array_horizontal.size() == 1 :
		block_vertical_first_index(spawn_block_array)
	if grid_id_array_vertical.size() == 2 && grid_id_array_horizontal.size() == 1 :
		block_vertical_first_index(spawn_block_array)
		block_vertical_second_index(spawn_block_array)
	#print()
	print("GRID HORIZONTAL : ")
	print(spawn_block_array)
	if !camera.result.is_empty():
		if grid_id in spawn_block_array:
			is_spawn_block_horizontal = false
			grid_id_array_horizontal.append(grid_id)
			print("GRID HORIZONTAL : ")
			#print("GRID Vertical : ", grid_id_array_vertical)
			var block_instantiated = BLOCK.instantiate()
			block_instantiated.position = Vector3(-0.5, 0.2,0)
			block_instantiated.rotation.y = PI/2
			grid.add_child(block_instantiated)
			block_instantiated.name = "BlockHorizontal"
			block_horizontal_count -= 1
			gui._block_horizontal_label.text = str(block_horizontal_count)
			if block_horizontal_count == 0:
				gui._block_horizontal_button.hide()
				gui._block_horizontal_label.hide()

func spawn_obstacle_blocks_vertical():
	camera.set_token_to_mouse()
	if camera.result.is_empty():
		return
	#print("GRID ID : ",camera.result["collider"].get_parent().slot_id)
	var grid = camera.result["collider"].get_parent()
	var grid_id = grid.slot_id
	var spawn_block_array = []
	var block = grid.get_children()
	# Checking if the current tiles have BlockVertical or BlockHorizontal node
	for block_horizontal in block:
		if block_horizontal.name == "BlockHorizontal" or block_horizontal.name == "BlockVertical":
			return
	# Placement for first block_vertical
	if is_spawn_block_vertical:
		array_for_checking_tiles(spawn_block_array)
	
	# Placement for second block_vertical 
	if !is_spawn_block_vertical:
		match grid_id_array_vertical[0] :
			12,13,14,15:
				for i in range(24,36):
					spawn_block_array.append(i)
			16,17,18,19:
				for i in range(28,36):
					spawn_block_array.append(i)
			20,21,22,23:
				for i in range(32,36):
					spawn_block_array.append(i)
			24,25,26,27:
				for i in range(12,16):
					spawn_block_array.append(i)
			28,29,30,31:
				for i in range(12,20):
					spawn_block_array.append(i)
			32,33,34,35:
				for i in range(12,24):
					spawn_block_array.append(i)
	
	# Check probabilty of the priority placement
	# Note, H: horizontal, V : Vertical
	# Example : HHVV,HVHV,HVVH,VVHH.VHVH,VHHV
	if grid_id_array_horizontal.size() == 1 :
		block_horizontal_first_index(spawn_block_array)
	if grid_id_array_horizontal.size() == 2 :
		block_horizontal_second_index(spawn_block_array)
	if grid_id_array_horizontal.size() == 1 && grid_id_array_vertical.size() == 1 :
		block_horizontal_first_index(spawn_block_array)
	if grid_id_array_horizontal.size() == 2 && grid_id_array_vertical.size() == 1 :
		block_horizontal_second_index(spawn_block_array)
	
	print("SPAWN BLOCK ARRAY : ",spawn_block_array)
	if !camera.result.is_empty():
		if grid_id in spawn_block_array:
			is_spawn_block_vertical = false
			grid_id_array_vertical.append(grid_id)
			var block_instantiated = BLOCK.instantiate()
			block_instantiated.position = Vector3(0, 0.2, -0.5)
			#print("VERTICAL FIRST INDEX :",grid_id_array_vertical[0] )
			#print("BLOCK INSTANTIATED : ", block_instantiated.position)
			grid.add_child(block_instantiated)
			block_instantiated.name = "BlockVertical"
			block_vertical_count -= 1
			gui._block_vertical_label.text = str(block_vertical_count)
			if block_vertical_count == 0:
				gui._block_vertical_button.hide()
				gui._block_vertical_label.hide()

func checking_plus_neighbors(boost_array,boost_arr):
	var id = boost_arr[0] - 4
	var find_index_id = boost_array.find(id)
	boost_array.remove_at(find_index_id)
	
	var id_2 = boost_arr[0] - 1
	var find_index_id_2 = boost_array.find(id_2)
	boost_array.remove_at(find_index_id_2)
	
	var id_3 = boost_arr[0] + 1
	var find_index_id_3 = boost_array.find(id_3)
	boost_array.remove_at(find_index_id_3)
	
	var id_4 = boost_arr[0] + 4
	var find_index_id_4 = boost_array.find(id_4)
	boost_array.remove_at(find_index_id_4) 

func checking_boost_down_array(boost_array):
	match boost_down_array[0]:
		12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35:
			checking_plus_neighbors(boost_array,boost_down_array)

func checking_boost_right_array(boost_array):
	match boost_right_array[0]:
		12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35:
			checking_plus_neighbors(boost_array,boost_right_array)

func checking_boost_left_array(boost_array):
	match boost_left_array[0]:
		12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35:
			checking_plus_neighbors(boost_array,boost_left_array)

func checking_boost_up_array(boost_array):
	match boost_up_array[0]:
		12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35:
			checking_plus_neighbors(boost_array,boost_up_array)

func sprite_position(tiles):
	var sprite = tiles.get_child(0)
	#print("SPRITE : ", sprite)
	sprite.position = Vector3(0.4, 4, 0.55)

func spawn_boost_up():
	camera.set_token_to_mouse()
	if camera.result.is_empty():
		return
	#print("GRID ID : ",camera.result["collider"].get_parent().slot_id)
	var grid = camera.result["collider"].get_parent()
	var grid_id = grid.slot_id
	var tiles = grid.get_child(1)
	var background = tiles.get_child(1)
	#print(tiles)
	var boost_array = []
	var boost_check_array = tiles.get_children()
	
	#print(sprite)
	#var sprite_path = sprite.resource_path
	#print("RESOURCE PATH : ",sprite_path)
	#var sprite_right = sprite_path.right(11)
	#var sprite_text = sprite_right.trim_suffix(".png")
	#print(sprite_text)
	for boost in boost_check_array:
		if boost.name == "BoostDown" or boost.name == "BoostLeft" or boost.name == "BoostRight":
			return 
	var block = grid.get_children()
	# Checking if the current tiles have BlockVertical or BlockHorizontal node
	for block_horizontal in block:
		if block_horizontal.name == "BlockHorizontal" or block_horizontal.name == "BlockVertical":
			return
	#sprite_position(tiles_sprite)
	array_for_checking_tiles(boost_array)
	if boost_down_array.size() == 1:
		checking_boost_down_array(boost_array)
	if boost_left_array.size() == 1:
		checking_boost_left_array(boost_array)
	if boost_right_array.size() == 1:
		checking_boost_right_array(boost_array)
	#print(boost_array)
	#print(grid.position)
	if !camera.result.is_empty():
		if grid_id in boost_array:
			boost_up_array.append(grid_id)
			var block_instantiated = BOOST.instantiate()
			block_instantiated.position.y = 0.51
			tiles.add_child(block_instantiated)
			block_instantiated.rotation.y = PI
			block_instantiated.name = "BoostUp"
			boost_up_count -= 1
			gui._boost_up_label.text = str(boost_up_count)
			if boost_up_count == 0:
				gui._boost_up_button.hide()
				gui._boost_up_label.hide()

func spawn_boost_down():
	camera.set_token_to_mouse()
	if camera.result.is_empty():
		return
	#print("GRID ID : ",camera.result["collider"].get_parent().slot_id)
	var grid = camera.result["collider"].get_parent()
	var grid_id = grid.slot_id
	var boost_array = []
	var tiles = grid.get_child(1)
	
	var boost_check_array = tiles.get_children()
	for boost in boost_check_array:
		if boost.name == "BoostUp" or boost.name == "BoostLeft" or boost.name == "BoostRight":
			return 
	var block = grid.get_children()
	# Checking if the current tiles have BlockVertical or BlockHorizontal node
	for block_horizontal in block:
		if block_horizontal.name == "BlockVertical":
			return
	array_for_checking_tiles(boost_array)
	if boost_up_array.size() == 1:
		checking_boost_up_array(boost_array)
	if boost_left_array.size() == 1:
		checking_boost_left_array(boost_array)
	if boost_right_array.size() == 1:
		checking_boost_right_array(boost_array)
	
	#print(boost_array)
	#print(grid.position)
	if !camera.result.is_empty():
		if grid_id in boost_array:
			boost_down_array.append(grid_id)
			var block_instantiated = BOOST.instantiate()
			block_instantiated.position.y = 0.51
			tiles.add_child(block_instantiated)
			block_instantiated.name = "BoostDown"
			boost_down_count -= 1
			gui._boost_down_label.text = str(boost_down_count)
			if boost_down_count == 0:
				gui._boost_down_button.hide()
				gui._boost_down_label.hide()

func spawn_boost_left():
	camera.set_token_to_mouse()
	if camera.result.is_empty():
		return
	#print("GRID ID : ",camera.result["collider"].get_parent().slot_id)
	var grid = camera.result["collider"].get_parent()
	var grid_id = grid.slot_id
	var boost_array = []
	var tiles = grid.get_child(1)
	var boost_check_array = tiles.get_children()
	for boost in boost_check_array:
		if boost.name == "BoostDown" or boost.name == "BoostUp" or boost.name == "BoostRight":
			return 
	var block = grid.get_children()
	# Checking if the current tiles have BlockVertical or BlockHorizontal node
	for block_horizontal in block:
		if block_horizontal.name == "BlockHorizontal":
			return
	array_for_checking_tiles(boost_array)
	if boost_down_array.size() == 1:
		checking_boost_down_array(boost_array)
	if boost_up_array.size() == 1:
		checking_boost_up_array(boost_array)
	if boost_right_array.size() == 1:
		checking_boost_right_array(boost_array)

	#print(boost_array)
	#print(grid.position)
	if !camera.result.is_empty():
		if grid_id in boost_array:
			boost_left_array.append(grid_id)
			var block_instantiated = BOOST.instantiate()
			block_instantiated.position.y = 0.51
			block_instantiated.rotation.y = -PI/2
			tiles.add_child(block_instantiated)
			block_instantiated.name = "BoostLeft"
			boost_left_count -= 1
			gui._boost_left_label.text = str(boost_left_count)
			if boost_left_count == 0:
				gui._boost_left_button.hide()
				gui._boost_left_label.hide()

func spawn_boost_right():
	camera.set_token_to_mouse()
	if camera.result.is_empty():
		return
	#print("GRID ID : ",camera.result["collider"].get_parent().slot_id)
	var grid = camera.result["collider"].get_parent()
	var grid_id = grid.slot_id
	var boost_array = []
	var tiles = grid.get_child(1)
	var boost_check_array = tiles.get_children()
	for boost in boost_check_array:
		if boost.name == "BoostDown" or boost.name == "BoostLeft" or boost.name == "BoostUp":
			return 
	var block = grid.get_children()
	# Checking if the current tiles have BlockVertical or BlockHorizontal node
	for block_horizontal in block:
		if block_horizontal.name == "BlockHorizontal" or block_horizontal.name == "BlockVertical":
			return
	array_for_checking_tiles(boost_array)
	if boost_down_array.size() == 1:
		checking_boost_down_array(boost_array)
	if boost_left_array.size() == 1:
		checking_boost_left_array(boost_array)
	if boost_up_array.size() == 1:
		checking_boost_up_array(boost_array)
	

	#print(boost_array)
	#print(grid.position)
	if !camera.result.is_empty():
		if grid_id in boost_array:
			boost_right_array.append(grid_id)
			var block_instantiated = BOOST.instantiate()
			block_instantiated.position.y = 0.51
			block_instantiated.rotation.y = PI/2
			tiles.add_child(block_instantiated)
			block_instantiated.name = "BoostRight"
			boost_right_count -= 1
			gui._boost_right_label.text = str(boost_right_count)
			if boost_right_count == 0:
				gui._boost_right_button.hide()
				gui._boost_right_label.hide()

func tiles_spawn_coin():
	camera.set_token_to_mouse()
	if camera.result.is_empty():
		return
	var grid = camera.result["collider"].get_parent()
	var grid_id = grid.slot_id
	var tiles_spawn_array = []
	var tiles = grid.get_child(1)
	var tiles_spawn_check_array = tiles.get_children()
	for tiles_spawn in tiles_spawn_check_array:
		if tiles_spawn.name == "Diamond" or tiles_spawn.name == "Star" or tiles_spawn.name == "Heart":
			return
	var boost_check_array = tiles.get_children()
	for boost in boost_check_array:
		if boost.name == "BoostDown" or boost.name == "BoostLeft" or boost.name == "BoostUp" or boost.name == "BoostRight":
			return 
	var stack_check_array = tiles.get_children()
	for stack in stack_check_array:
		if stack.name == "Stack":
			return
	array_for_checking_tiles(tiles_spawn_array)

	#print(tiles_spawn_array)
	#print(grid.position)
	if !camera.result.is_empty():
		if grid_id in tiles_spawn_array:
			tiles_spawn_coin_array.append(grid_id)
			var tiles_spawn_instantiated = TILES_SPAWN.instantiate()
			tiles_spawn_instantiated.position.y = 0.51
			#tiles_spawn_instantiated.rotation.y = -PI/2
			#var tiles_spawn_sprite = tiles_spawn_instantiated.get_child(1)
			tiles_spawn_instantiated.texture = load("res://assets/tiles/constructors/tiles_coin.png")
			tiles.add_child(tiles_spawn_instantiated)
			tiles_spawn_instantiated.name = "Coin"
			tiles_spawn_coin_count -= 1
			gui._tiles_spawn_coin_label.text = str(tiles_spawn_coin_count)
			if tiles_spawn_coin_count == 0:
				gui._tiles_spawn_coin_button.hide()
				gui._tiles_spawn_coin_label.hide()

func tiles_spawn_heart():
	camera.set_token_to_mouse()
	if camera.result.is_empty():
		return
	var grid = camera.result["collider"].get_parent()
	var grid_id = grid.slot_id
	var tiles_spawn_array = []
	var tiles = grid.get_child(1)
	var tiles_spawn_check_array = tiles.get_children()
	for tiles_spawn in tiles_spawn_check_array:
		if tiles_spawn.name == "Diamond" or tiles_spawn.name == "Star" or tiles_spawn.name == "Coin":
			return
	var boost_check_array = tiles.get_children()
	for boost in boost_check_array:
		if boost.name == "BoostDown" or boost.name == "BoostLeft" or boost.name == "BoostUp" or boost.name == "BoostRight":
			return 
	var stack_check_array = tiles.get_children()
	for stack in stack_check_array:
		if stack.name == "Stack":
			return
	#sprite_position(tiles)
	array_for_checking_tiles(tiles_spawn_array)

	#print(tiles_spawn_array)
	#print(grid.position)
	if !camera.result.is_empty():
		if grid_id in tiles_spawn_array:
			tiles_spawn_heart_array.append(grid_id)
			var tiles_spawn_instantiated = TILES_SPAWN.instantiate()
			tiles_spawn_instantiated.position.y = 0.51
			#tiles_spawn_instantiated.rotation.y = -PI/2
			#var tiles_spawn_sprite = tiles_spawn_instantiated.get_child(1)
			tiles_spawn_instantiated.texture = load("res://assets/tiles/constructors/tiles_heart.png")
			tiles.add_child(tiles_spawn_instantiated)
			tiles_spawn_instantiated.name = "Heart"
			tiles_spawn_heart_count -= 1
			gui._tiles_spawn_heart_label.text = str(tiles_spawn_heart_count)
			if tiles_spawn_heart_count == 0:
				gui._tiles_spawn_heart_button.hide()
				gui._tiles_spawn_heart_label.hide()

func tiles_spawn_diamond():
	camera.set_token_to_mouse()
	if camera.result.is_empty():
		return
	var grid = camera.result["collider"].get_parent()
	var grid_id = grid.slot_id
	var tiles_spawn_array = []
	var tiles = grid.get_child(1)
	var tiles_spawn_check_array = tiles.get_children()
	for tiles_spawn in tiles_spawn_check_array:
		if tiles_spawn.name == "Coin" or tiles_spawn.name == "Star" or tiles_spawn.name == "Heart":
			return
	var boost_check_array = tiles.get_children()
	for boost in boost_check_array:
		if boost.name == "BoostDown" or boost.name == "BoostLeft" or boost.name == "BoostUp" or boost.name == "BoostRight":
			return 
	var stack_check_array = tiles.get_children()
	for stack in stack_check_array:
		if stack.name == "Stack":
			return
	#sprite_position(tiles)
	array_for_checking_tiles(tiles_spawn_array)

	#print(tiles_spawn_array)
	#print(grid.position)
	if !camera.result.is_empty():
		if grid_id in tiles_spawn_array:
			tiles_spawn_diamond_array.append(grid_id)
			var tiles_spawn_instantiated = TILES_SPAWN.instantiate()
			tiles_spawn_instantiated.position.y = 0.51
			#tiles_spawn_instantiated.rotation.y = -PI/2
			#var tiles_spawn_sprite = tiles_spawn_instantiated.get_child(1)
			tiles_spawn_instantiated.texture = load("res://assets/tiles/constructors/tiles_diamond.png")
			tiles.add_child(tiles_spawn_instantiated)
			tiles_spawn_instantiated.name = "Diamond"
			tiles_spawn_diamond_count -= 1
			gui._tiles_spawn_diamond_label.text = str(tiles_spawn_diamond_count)
			if tiles_spawn_diamond_count == 0:
				gui._tiles_spawn_diamond_button.hide()
				gui._tiles_spawn_diamond_label.hide()

func tiles_spawn_star():
	camera.set_token_to_mouse()
	if camera.result.is_empty():
		return
	var grid = camera.result["collider"].get_parent()
	var grid_id = grid.slot_id
	var tiles_spawn_array = []
	var tiles = grid.get_child(1)
	var tiles_spawn_check_array = tiles.get_children()
	for tiles_spawn in tiles_spawn_check_array:
		if tiles_spawn.name == "Diamond" or tiles_spawn.name == "Coin" or tiles_spawn.name == "Heart":
			return
	var boost_check_array = tiles.get_children()
	for boost in boost_check_array:
		if boost.name == "BoostDown" or boost.name == "BoostLeft" or boost.name == "BoostUp" or boost.name == "BoostRight":
			return 
	var stack_check_array = tiles.get_children()
	for stack in stack_check_array:
		if stack.name == "Stack":
			return
	#sprite_position(tiles)
	array_for_checking_tiles(tiles_spawn_array)

	#print(tiles_spawn_array)
	#print(grid.position)
	if !camera.result.is_empty():
		if grid_id in tiles_spawn_array:
			tiles_spawn_star_array.append(grid_id)
			var tiles_spawn_instantiated = TILES_SPAWN.instantiate()
			tiles_spawn_instantiated.position.y = 0.51
			#tiles_spawn_instantiated.rotation.y = -PI/2
			#var tiles_spawn_sprite = tiles_spawn_instantiated.get_child(1)
			tiles_spawn_instantiated.texture = load("res://assets/tiles/constructors/tiles_star.png")
			tiles.add_child(tiles_spawn_instantiated)
			tiles_spawn_instantiated.name = "Star"
			tiles_spawn_star_count -= 1
			gui._tiles_spawn_star_label.text = str(tiles_spawn_star_count)
			if tiles_spawn_star_count == 0:
				gui._tiles_spawn_star_button.hide()
				gui._tiles_spawn_star_label.hide()

func stack_spawn():
	camera.set_token_to_mouse()
	if camera.result.is_empty():
		return
	var grid = camera.result["collider"].get_parent()
	var grid_id = grid.slot_id
	var stack_array = []
	var tiles = grid.get_child(1)
	#sprite_position(tiles)
	var tiles_spawn_check_array = tiles.get_children()
	for tiles_spawn in tiles_spawn_check_array:
		if tiles_spawn.name == "Diamond" or tiles_spawn.name == "Coin" or tiles_spawn.name == "Heart" or tiles_spawn.name == "Star":
			return
	var boost_check_array = tiles.get_children()
	for boost in boost_check_array:
		if boost.name == "BoostDown" or boost.name == "BoostLeft" or boost.name == "BoostUp" or boost.name == "BoostRight":
			return 
	var stack_check_array = tiles.get_children()
	for stack in stack_check_array:
		if stack.name == "Stack":
			return
	array_for_checking_tiles(stack_array)

	if !camera.result.is_empty():
		if grid_id in stack_array:
			stack_id_array.append(grid_id)
			var stack_instantiated = STACK.instantiate()
			stack_instantiated.position.y = 0.51
			tiles.add_child(stack_instantiated)
			stack_instantiated.name = "Stack"
			stack_count -= 1
			gui._stack_label.text = str(stack_count)
			if stack_count == 0:
				gui._stack_button.hide()
				gui._stack_label.hide()

