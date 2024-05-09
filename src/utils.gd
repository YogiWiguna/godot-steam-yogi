extends Node


@onready var map = preload("res://scenes/map.tscn")
# Utils | Global Autoload

enum player { ONE, TWO, THREE, FOUR }
enum player_class { Bob, Gatot, Granny, Karen, Masbro, Oldpops }

# Utils | Player Board | Start
# ----------------------------
signal _on_select_pressed
signal _on_spawn_item_to_choosen_slot
#signal _on_deselect_pressed

# UI Ref
@onready var ui_select_btn = $/root/Control/RightContainer/Select
@onready var ui_deselect_btn = $/root/Control/RightContainer/Deselect
@onready var ui_move_btn = $/root/Control/RightContainer/Move
@onready var ui_end_turn_btn = $/root/Control/RightContainer/EndTurn
@onready var puzzleboard = $/root/Control
@onready var item_scene = preload("res://scenes/item.tscn")
# ----------------------------

# Player Color
static func get_player_color(_player):
	match player:
		0: return Color.BLACK
		1: return Color.PURPLE
		2: return Color.DARK_RED
		3: return Color.DARK_BLUE


func check_player_availability_on_floor():
	var occupied_by
	for x in range(map.floor_instantiated.size()):
		var tiles = map.floor_instantiated[x]
		occupied_by = tiles.occupied_by
	return occupied_by

func generate_table(row_num : int , column_num : int) -> Array:
	var rows = []
	
	for r in range(row_num):
		var row = []
		for c in range(column_num):
			var num = r * column_num + c
			row.append(num)
			num += 1 # should be start from 0
		rows.append(row)
	return rows
	#for row in rows:
		#for key in range(row.size()):
			#var elements = row[key]
