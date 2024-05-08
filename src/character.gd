extends CharacterBody3D
class_name Character
const BLACK_MATERIAL = preload("res://assets/materials/black_mat.tres")
@onready var map = get_node("/root/main/Map")

@onready var animation_player = $AnimationPlayer
@onready var ray_cast_3d = $RayCast3D
@onready var navigation_agent_3d = $NavigationAgent3D
@onready var astar_map = get_node("/root/main/Map/AstarMap")
@onready var camera_3d = get_node("/root/main/Map/Camera3D")
@onready var gui = get_node("/root/main/Map/GUI")

# Char Editor 
@export var current_player : int
@export var current_char = ""
#var selected_char = Character.current_char
#@export var list_char = ["bob","masbro","gatot","oldpops"]


var player_location
var path = []
var path_index = 0
const move_speed = 5
var raycast = true
var show_menu = true
var currently_controlled : bool 
var current_slot_id
var sprite_texture
var sprite_path

func _ready():
	animation_player.play("Idle_01")
	add_to_group("units")

func _physics_process(delta):
	if path_index < path.size():
		var move_vec = (path[path_index] - global_transform.origin)
		#print(Utils.player_move)
		if raycast:
			#Utils.mouse_selected = ray_cast_3d.get_collider().get_parent().slot_id
			get_raycast_tiles()

		#print(sprite)
		#print(map.is_player_move)
		if map.is_player_move && currently_controlled == true:
			## FOR SET THE MAXIMUM move_vec
			print("PLAYER MOVE")
			raycast = false
			#if Utils.sprite_texture != null:
				#Utils.grab_tiles_button.disabled = false
			if move_vec.length() < 0.1:
				# Use this for only 1 move
				path_index = 1
				# Use the if more than 1
				#path_ind += 1
			else :
				# Set the velocity for move_and_slide functions (Compare the move_and_slide function on Godot 3 and Godot 4)
				velocity = move_vec.normalized() * move_speed
				# Set the up_direction
				up_direction = Vector3(0,1,0)
				## This is if godot 3
				#move_and_slide(move_vec.normalized() * move_speed, Vector3(0,1,0))
				# Play the animations running 
				animation_player.play("Running")
				# Set the player position 
				position.y =  0.637
				move_and_slide()
				# If animation finished connect it to the _on_animation_player_animation_finished functions
				animation_player.animation_finished.connect(_on_animation_player_animation_finished)


func move_to(target_pos):
	path = astar_map.get_tiles_path(global_transform.origin, target_pos)
	path_index = 0
	

func get_raycast_tiles():
	#var grid = ray_cast_3d.get_collider().get_parent()
	#print("GRID : ", grid)
	# Get the slot_id from the ray_cast and Set it into the current_slot_id
	current_slot_id = ray_cast_3d.get_collider().get_parent().slot_id
	#print("MOUSE SELECTED : ",Utils.mouse_selected)
	# Get the tiles from the raycast and Set it into the variable tiles
	var tiles = ray_cast_3d.get_collider().get_parent().get_child(1)
	# Get the texture of the sprite in tiles and Set it into the variable sprite
	var sprite = tiles.get_child(0).texture
	#print("SPRITE : ",sprite)
	# Set the sprite into the Utils.sprite_texture 
	sprite_texture = sprite
	# Check if the sprite is null
	if sprite == null : 
		return
	else :
		gui._put_tiles_button.disabled = true
	# Get the resource path of the sprite if the sprite is not null
	sprite_path = sprite.resource_path
	#print(sprite_path)
	
	#print("RESOURCE PATH : ",sprite_path)


## SIGNAL
func _on_animation_player_animation_finished(anim_name):
	# Set the player_move to false (in physics process)
	map.is_player_move = false
	currently_controlled = false
	
	#print("Animation FINISHED")
	
	# Get the raycast_tiles (so we know where the player is) by slot_id
	get_raycast_tiles()
	# Change animation to idle right after the running animation is done
	_on_animation_player_animation_changed("Running","Idle_01")

func _on_animation_player_animation_changed(old_name, new_name):
	animation_player.play("Idle_01")


#func _on_input_event(camera, event, position, normal, shape_idx):
	## Get the slot_id from raycast (player position) and Set it into the Ut
	#var mouse_selected = ray_cast_3d.get_collider().get_parent().slot_id
	#if event.is_action_pressed("left_click"):
		#map.hover_tiles(mouse_selected)

