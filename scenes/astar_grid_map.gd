extends GridMap

@onready var map = get_node("/root/main/Map")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_cell_item(Vector3(0.5, 0, 0.5),0)
	var x = 1
	var z = 1
	for i in range(3):
		self.set_cell_item(Vector3(x,0,z),0)
		x += 1
		z += 1
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
