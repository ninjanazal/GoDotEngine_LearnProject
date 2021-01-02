extends Node

var _spinning : bool = false setget spinning_state, is_spinning
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

# Slot Icons
func slot_item_to_string(items : Array) -> Array:
	var result_string_array : Array
	for item in items:
		result_string_array.append(ConsTypes.kIconType.keys()[item])
	return result_string_array

func spinning_state(value : bool):
	_spinning = value

func is_spinning() -> bool:
	return _spinning
