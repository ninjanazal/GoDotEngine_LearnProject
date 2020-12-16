extends Node

enum CAMSTATE {CENTER_0, GAMEVIEW_1}

var _main_camera = null setget main_camera_set, main_camera_get

func main_camera_set(cam: Node2D) -> bool:
	if !cam : return false	
	_main_camera = cam
	print("Main camera Registed")
	return true

func main_camera_get() -> Node2D:
	return _main_camera
