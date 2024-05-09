extends CanvasLayer
class_name GUI

@onready var map = get_node("/root/main/Map")
@onready var obstacle = get_node("/root/main/Map/Obstacle")
@onready var character = Character.new()

## MATERIAL
const BLACK_MATERIAL = "000000"
const RED_MATERIAL = "ef0000"
const TILES_PRIMARY_MATERIAL = "fbe786"
const TILES_TERITARY_MATERIAL = "fec490"


@onready var astar_map = $"../AstarMap"
@onready var timer = $"../Timer"
@onready var phase_timer = $"../PhaseTimer"
@onready var floor_map_region: Node3D = $"../FloorMapRegion"

## DEBUG UI
@onready var _debug: Control = $Debug
@onready var _texture_rect_debug: TextureRect = $Debug/TextureRectDebug
@onready var _phase_label: Label = $Debug/PhaseLabel
@onready var _debug_container: VBoxContainer = $Debug/DebugContainer
@onready var _move_label: Label = $Debug/DebugContainer/MoveLabel
@onready var _action_player_label: Label = $Debug/DebugContainer/ActionPlayerLabel
@onready var _timer_label: Label = $Debug/DebugContainer/TimerLabel
@onready var _random_tiles: Button = $Debug/DebugContainer/RandomTilesButton
@onready var _phase_two_button: Button = $Debug/DebugContainer/PhaseTwoButton

## OBSTACLE SPAWNNER UI
@onready var _obstacle_spawnner: HBoxContainer = $ObstacleSpawnner
@onready var _block_spawn_button: Button  = $ObstacleSpawnner/BlockSpawnButton
@onready var _boost_spawn_button: Button = $ObstacleSpawnner/BoostSpawnButton
@onready var _tiles_spawn_button: Button= $ObstacleSpawnner/TilesSpawnButton
@onready var _stack_spawn_button: Button = $ObstacleSpawnner/StackSpawnButton

## Menu Player UI
@onready var _menu_player: VBoxContainer = $MenuPlayer
@onready var _grab_tiles_button: Button = $MenuPlayer/GrabTilesButton
@onready var _put_tiles_button: Button = $MenuPlayer/PutTilesButton
@onready var _spawn_tiles_button = $MenuPlayer/SpawnTilesButton
@onready var _end_phase_button: Button = $MenuPlayer/EndPhaseButton
@onready var _end_turn_button: Button = $MenuPlayer/EndTurnButton

## Block UI
@onready var _block: HBoxContainer = $Block
@onready var _block_horizontal_button: Button = $Block/BlockHorizontalButton
@onready var _block_horizontal_label: Label = $Block/BlockHorizontalButton/BlockHorizontalLabel
@onready var _block_vertical_button: Button = $Block/BlockVerticalButton
@onready var _block_vertical_label: Label = $Block/BlockVerticalButton/BlockVerticalLabel

## Boost UI
@onready var _boost: HBoxContainer = $Boost
@onready var _boost_up_button: Button = $Boost/BoostUpButton
@onready var _boost_up_label: Label = $Boost/BoostUpButton/BoostUpLabel
@onready var _boost_down_button: Button = $Boost/BoostDownButton
@onready var _boost_down_label: Label = $Boost/BoostDownButton/BoostDownLabel
@onready var _boost_left_button: Button = $Boost/BoostLeftButton
@onready var _boost_left_label: Label = $Boost/BoostLeftButton/BoostLeftLabel
@onready var _boost_right_button: Button = $Boost/BoostRightButton
@onready var _boost_right_label: Label = $Boost/BoostRightButton/BoostRightLabel

## Tiles UI
@onready var _tiles_spawn: HBoxContainer = $TilesSpawn
@onready var _tiles_spawn_coin_button: Button = $TilesSpawn/TilesSpawnCoinButton
@onready var _tiles_spawn_coin_label: Label = $TilesSpawn/TilesSpawnCoinButton/TilesSpawnCoinLabel
@onready var _tiles_spawn_heart_button: Button = $TilesSpawn/TilesSpawnHeartButton
@onready var _tiles_spawn_heart_label: Label = $TilesSpawn/TilesSpawnHeartButton/TilesSpawnHeartLabel
@onready var _tiles_spawn_diamond_button: Button = $TilesSpawn/TilesSpawnDiamondButton
@onready var _tiles_spawn_diamond_label: Label = $TilesSpawn/TilesSpawnDiamondButton/TilesSpawnDiamondLabel
@onready var _tiles_spawn_star_button: Button = $TilesSpawn/TilesSpawnStarButton
@onready var _tiles_spawn_star_label: Label = $TilesSpawn/TilesSpawnStarButton/TilesSpawnStarLabel

## Stack UI
@onready var _stack: HBoxContainer = $Stack
@onready var _stack_button: Button = $Stack/StackButton
@onready var _stack_label: Label = $Stack/StackButton/StackLabel

## Turn Container
@onready var _turn_container: HBoxContainer = $TurnContainer
@onready var _turn_1: Panel = $TurnContainer/Turn1
@onready var _turn_2: Panel = $TurnContainer/Turn2
@onready var _turn_3: Panel = $TurnContainer/Turn3
@onready var _turn_4: Panel = $TurnContainer/Turn4
@onready var _turn_5: Panel = $TurnContainer/Turn5
@onready var _turn_6: Panel = $TurnContainer/Turn6

var sprite_texture
var timer_count = false
var is_phase_two = false
var is_phase_two_second = false

static func create_material(name: String, color, texture=null, shaded_mode=0):
	var material = StandardMaterial3D.new()
	material.name = name
	material.flags_transparent = true
	material.albedo_color = Color(color)
	material.albedo_texture = texture
	#material.shading_mode = shaded_mode
	return material

func _ready():
	sprite_texture = null

func _process(delta):
	if timer_count:
		_timer_label.text = "Timer : %s" % str(roundf(timer.time_left))

func _input(event):
	if map.is_menu_player_show:
		_menu_player.show()
	else :
		_menu_player.hide()

func menu_player_disabled(status : bool):
	_grab_tiles_button.disabled = status
	_put_tiles_button.disabled = status
	_spawn_tiles_button.disabled = status
	_end_phase_button.disabled = status
	_end_turn_button.disabled = status

func reset_tile_material(slot_id):
	# Generated Nighborhood Array
	if !map.gen_neigh_array.has(slot_id) :
		map.floor_array[slot_id].get_child(1).set_surface_override_material(0,create_material("TilesPrimaryMaterial",TILES_PRIMARY_MATERIAL))
		map.set_start_and_finish_tile_material(map.player_number)

## OBSTACLE SPAWNNER
func _on_block_spawn_button_pressed():
	if obstacle.is_block_ui:
		_block.visible = true
		#print("true")
		obstacle.is_block_ui = false
	else:
		_block.visible = false
		#print("false")
		obstacle.is_block_ui = true

func _on_boost_spawn_button_pressed():
	if obstacle.is_boost_ui:
		_boost.visible = true
		obstacle.is_boost_ui = false
	else:
		_boost.visible = false
		obstacle.is_boost_ui = true

func _on_tiles_spawn_button_pressed():
	if obstacle.is_tiles_spawn_ui:
		_tiles_spawn.visible = true
		obstacle.is_tiles_spawn_ui = false
	else: 
		_tiles_spawn.visible = false
		obstacle.is_tiles_spawn_ui = true

func _on_stack_spawn_button_pressed():
	if obstacle.is_stack_ui:
		_stack.visible = true
		obstacle.is_stack_ui = false
	else: 
		_stack.visible = false
		obstacle.is_stack_ui = true


## Menu Player 
func _on_grab_tiles_button_pressed():
	_texture_rect_debug.texture = load(map.character_floor_sprite_path)
	# Set the tiles texture into null (because we grab it and display it into the texture_rect)
	sprite_texture = map.floor_array[map.character_current_slot_id].get_child(1).get_child(0)
	sprite_texture.texture = null
	
	character.currently_controlled = false

func _on_put_tiles_button_pressed():
	# Check if the sprite_texture is null, set the texture_spawn to sprite_texture
	if sprite_texture.texture == null:
		sprite_texture.texture = _texture_rect_debug.texture
	
	character.currently_controlled = false

func _on_spawn_tiles_button_pressed():
	pass # Replace with function body.

func _on_end_phase_button_pressed():
	## START THE TIMER AFTER PRESS THE END TURN 
	phase_timer.start()
	_phase_label.text = "Main Phase 2"
	_phase_label.visible = true
	# Disabled the children of the menu player
	menu_player_disabled(true)
	_end_phase_button.visible = false

func _on_end_turn_button_pressed():
	## START THE TIMER AFTER PRESS THE END TURN 
	timer.wait_time = 5
	timer.start()
	timer_count = true
	menu_player_disabled(false)
	
	if is_phase_two_second:
		is_phase_two = true


## Obstacle Block
func _on_block_horizontal_button_pressed():
	print("BLOCK HORIZONTAL")
	obstacle.is_obstacle_block_horizontal = true
	obstacle.is_block = true
	
	var spawn_block_array = []
	obstacle.array_for_checking_tiles(spawn_block_array)


func _on_block_vertical_button_pressed():
	print("BLOCK VERTICAL")
	obstacle.is_obstacle_block_vertical = true
	obstacle.is_block = true
	
	var spawn_block_array = []
	obstacle.array_for_checking_tiles(spawn_block_array)


## Obstacle Boost
func _on_boost_up_button_pressed():
	print("BOOST UP")
	obstacle.is_boost_up_pressed = true
	obstacle.is_boost = true
	
	var boost_array = []
	obstacle.array_for_checking_tiles(boost_array)
	#boost_array = boost_array


func _on_boost_down_button_pressed():
	print("BOOST DOWN")
	obstacle.is_boost_down_pressed = true
	obstacle.is_boost = true
	
	var boost_array = []
	obstacle.array_for_checking_tiles(boost_array)
	#boost_array = boost_array


func _on_boost_left_button_pressed():
	print("BOOST LEFT")
	obstacle.is_boost_left_pressed = true
	obstacle.is_boost = true
	
	var boost_array = []
	obstacle.array_for_checking_tiles(boost_array)
	#boost_array = boost_array


func _on_boost_right_button_pressed():
	print("BOOST RIGHT")
	obstacle.is_boost_right_pressed = true
	obstacle.is_boost = true
	
	var boost_array = []
	obstacle.array_for_checking_tiles(boost_array)
	#boost_array = boost_array



## Obstacle Tiles Spawn
func _on_tiles_spawn_coin_button_pressed():
	print("TILES SPAWN COIN")
	obstacle.is_tiles_spawn_coin = true
	obstacle.is_tiles_spawn = true
	
	var tiles_spawn_array = []
	obstacle.array_for_checking_tiles(tiles_spawn_array)
	#tiles_spawn_array = tiles_spawn_array


func _on_tiles_spawn_heart_button_pressed():
	print("TILES SPAWN HEART")
	obstacle.is_tiles_spawn_heart = true
	obstacle.is_tiles_spawn = true
	
	var tiles_spawn_array = []
	obstacle.array_for_checking_tiles(tiles_spawn_array)
	#tiles_spawn_array = tiles_spawn_array


func _on_tiles_spawn_diamond_button_pressed():
	print("TILES SPAWN DIAMOND")
	obstacle.is_tiles_spawn_diamond = true
	obstacle.is_tiles_spawn = true
	
	var tiles_spawn_array = []
	obstacle.array_for_checking_tiles(tiles_spawn_array)
	#tiles_spawn_array = tiles_spawn_array


func _on_tiles_spawn_star_button_pressed():
	print("TILES SPAWN STAR")
	obstacle.is_tiles_spawn_star = true
	obstacle.is_tiles_spawn = true
	
	var tiles_spawn_array = []
	obstacle.array_for_checking_tiles(tiles_spawn_array)
	#tiles_spawn_array = tiles_spawn_array


## Obstacle Stack 
func _on_stack_button_pressed():
	print("STACK")
	obstacle.is_stack = true
	
	var stack_array = []
	obstacle.array_for_checking_tiles(stack_array)
	#stack_array = stack_array


## DEBUG
func _on_random_tiles_button_pressed():
	map.set_random_id_for_tile()
	map.set_sprite_to_tiles(map.player_number)

func _on_phase_two_button_pressed():
	is_phase_two = true


## TIMER
func _on_timer_timeout():
	_phase_label.visible = false
	if is_phase_two_second:
		is_phase_two = true
	timer_count = false
	_menu_player.visible = false
	map._player_action = 2
	_action_player_label.text = "Action Player : %s" % map._player_action

func _on_phase_timer_timeout():
	_phase_label.visible = false
	is_phase_two = false
	_menu_player.visible = false
	
	map._player_action = 2
	_action_player_label.text = "Action Player : %s" % map._player_action


