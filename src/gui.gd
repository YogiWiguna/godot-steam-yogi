extends CanvasLayer
class_name GUI

## MATERIAL
const BLACK_MATERIAL = "000000"
const RED_MATERIAL = "ef0000"
const TILES_PRIMARY_MATERIAL = "fbe786"
const TILES_TERITARY_MATERIAL = "fec490"


@onready var astar_map = $"../AstarMap"


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
@export var is_menu_player_show = false
@onready var _move_button: Button = $MenuPlayer/MoveButton
@onready var _grab_tiles_button: Button = $MenuPlayer/GrabTilesButton
@onready var _put_tiles_button: Button = $MenuPlayer/PutTilesButton
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

static func create_material(name: String, color, texture=null, shaded_mode=0):
	var material = StandardMaterial3D.new()
	material.name = name
	material.flags_transparent = true
	material.albedo_color = Color(color)
	material.albedo_texture = texture
	#material.shading_mode = shaded_mode
	return material
