extends Position2D

export var vertical_offset := 0.0
export var Horizontal_offset := 0.0


var _target_node : Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func set_camera_target(path : String) -> void:
	if path:
		_target_node = get_node(path) as Node2D
