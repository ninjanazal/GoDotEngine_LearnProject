extends Node
class_name CameraController

export(NodePath) var cam_path = null
var _cam_target : Position2D = null

onready var _center_position = Vector2(
	get_viewport().size.x * 0.5, get_viewport().size.y * 0.5)

func _ready():
	GlobalCamera.main_camera_set(self.get_node("."))
	
	_validate_path()
	_center_cam()

func _validate_path():
		
	if  cam_path.is_empty() :
		print("Camera path not valid")
		get_tree().quit()
		return
		
	_cam_target = get_node(NodePath(cam_path)).get_child(0)
	print("Valid camera path! {name}".format({"name":_cam_target.get_class()}))

func _center_cam():	
	_cam_target.set_position(_center_position)


func _set_camera_state(camState):
	match camState:
		GlobalCamera.CAMSTATE.CENTER_0:
			_center_cam()
		GlobalCamera.CAMSTATE.GAMEVIEW_1:
			return

func get_position() -> Vector2:
	return _cam_target.get_global_position()
