extends Node
class_name CameraController

export (NodePath) var cam_path = null
var _cam_target : Position2D = null

onready var _center_position = Vector2(
	ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height")) \
	* 0.5


func _ready():
	_validate_path()
	_center_cam()


# Evaluate the path and verifies values
func _validate_path():
		
	if  cam_path.is_empty() :
		GlobalFunctions.CloseApp("cam_path not valid")
		return
		
	_cam_target = get_node(NodePath(cam_path)).get_child(0)
	
	var _camera_node = _cam_target.get_child(0)
	_camera_node._set_current(true)
	# Regist this node as main Camera on global variable
	GlobalFunctions.main_camera_set(self.get_path())
	print(get_node(GlobalFunctions.main_camera()).name)


func _center_cam():	
	_cam_target.set_position(_center_position)


# Set Camera State
func _set_camera_state(camState):
	match camState:
		GlobalFunctions.CAMSTATE.CENTER_0:
			_center_cam()
		GlobalFunctions.CAMSTATE.GAMEVIEW_1:
			return

# Get camera State
func get_position() -> Vector2:
	return _cam_target.get_global_position()
