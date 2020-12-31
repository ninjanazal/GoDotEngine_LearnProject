extends Node
class_name game_controller

export (Resource) var _slot_group
export (NodePath) var _slot_ui_path

onready var _slot_ui := get_node(_slot_ui_path)
onready var _player_ctrl := get_node("player_controller")
onready var _ui_ctrl := get_node("ui_controller")

var _slot_entrances : Array = []
var _current_result : Array setget ,get_current_result

func _ready():
	_validate_resource()
	_generate_slot_entrances(_slot_group)
	
	_slot_ui.connect("slot_spining",self,"_on_slot_spinning")

func _validate_resource():
	_slot_group = _slot_group as slot_group
	if _slot_group == null : 
		GlobalFunctions.CloseApp("Controller with bad resource")
	

func _generate_slot_entrances(group : slot_group):
	for slot_item in group.get_group_array():
		for i in slot_item.get_icon_entrances():
			_slot_entrances.append(slot_item.get_icon_type())
	print("Registed {value} entrances".format({"value":_slot_entrances.size()}))

# when the slot stated spinning
func _on_slot_spinning():
	_player_ctrl.change_credits(-_slot_ui.get_current_bet())
	
	yield(get_tree().create_timer(randf()*1.0 + 0.5),"timeout")
	_slot_ui.stop_slot_on(_get_spin_result())
	
	_slot_ui.connect("slot_stoped",self,"_on_slot_stoped",[], CONNECT_ONESHOT)

# get spin result combination
func _get_spin_result() -> Array:
	_current_result.clear()
	for i in 3:
		_current_result.append(_slot_entrances[randi() % _slot_entrances.size()])
	print(GlobalFunctions.slot_item_to_string(_current_result))
	return _current_result

func _on_slot_stoped():
	print("Slot stoped, calculating wins, current bet : {betVal}".format(
		{"betVal":_slot_ui.get_current_bet()}))

#get the current result
func get_current_result() -> Array:
	return _current_result
