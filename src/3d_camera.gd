extends Camera3D

const ray_length = 1000

var result
var is_character_move_to

func _input(event):
	# Check if the input event is mouse left button 
	# Set to token decoupled
	if event.is_action_pressed("left_click"):
		set_token_to_mouse()
		if result:
			#print("RESULT :", result)
			get_tree().call_group("units", "move_to", result["position"])
			is_character_move_to = true


func set_token_to_mouse():
	# Get the viewport and get the mouse position on the camera
	# The example of the result : (507, 163). It's a Vector 2
	var mouse_pos = get_viewport().get_mouse_position()
	# Set the ray_length 
	var ray_length = 1000 #int
	# Function project_ray_origin is returns a 3D position in world space, from Vector2D base on the camera
	# That is the result of projecting a point on the Viewport rectangle by the inverse camera projection.
	# Return a Vector3
	var from = project_ray_origin(mouse_pos)
	#print("FROM:",from)
	# Return a Vector3
	var to = from + project_ray_normal(mouse_pos) * ray_length
	#print("To:",to)
	# Returns the current World3D resource this Node3D node is registered to.
	# Direct access into the 3D physics
	var space = get_world_3d().direct_space_state
	## LEARN MORE
	# Configure the value of from and to for the intersect_ray function 
	var ray_query = PhysicsRayQueryParameters3D.new() # need to read this
	# Set the ray_query from 
	ray_query.from = from
	# Set the ray_query to
	ray_query.to = to
	# Set the intersect_ray with from and to variable from ray_query
	# Return a dictionary 
	result = space.intersect_ray(ray_query)
	#print(result)
	#print("SET TOKEN TO MOUSE")
