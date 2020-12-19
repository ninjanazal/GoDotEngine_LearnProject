extends Node

#App
func CloseApp(text: String):
	if not text.empty(): print("Exit with : {value}".format({"value":text}))
	get_tree().quit()

# Camera
onready var _main_camera  setget main_camera_set, main_camera

func main_camera_set(cam: NodePath) -> bool:
	if !cam : return false
	_main_camera = cam
	print("Main camera Registed")
	return true

func main_camera() -> NodePath:
	return _main_camera

