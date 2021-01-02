extends Node
class_name game_controller

export (Resource) var _slot_group
export (NodePath) var _slot_ui_path
export (float,0.5, 5, 0.1) var _win_duration
export (float,0.5, 5, 0.1) var _lose_duration

onready var _slot_ui := get_node(_slot_ui_path)
onready var _player_ctrl := get_node("player_controller")
onready var _ui_ctrl := get_node("ui_controller")

var _slot_entrances : Array = []
var _current_result : Array setget ,get_current_result

func _ready():
	_validate_resource()
	_generate_slot_entrances(_slot_group)
	
	_slot_ui.connect("slot_spining",self,"_on_slot_spinning")
	_slot_ui.connect("slot_stoped",self,"_on_slot_stoped")

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

# get spin result combination
func _get_spin_result() -> Array:
	_current_result.clear()
	for i in 3:
		_current_result.append(_slot_entrances[randi() % _slot_entrances.size()])
	return _current_result


func _on_slot_stoped():
	print(GlobalFunctions.slot_item_to_string(_current_result))
	print("Slot stoped, calculating wins, current bet : {betVal}".format(
		{"betVal":_slot_ui.get_current_bet()}))
	
	var multiplier = 0
	for i in 3:
		multiplier += _slot_group.get_first_by_type(_current_result[i]).get_icon_multiplier() * _current_result.count(_current_result[i])
	
	multiplier = int(floor(multiplier / 2))
	print("win value : {multi}".format({"multi":multiplier * _slot_ui.get_current_bet()}))
	
	_player_ctrl.change_credits(_slot_ui.get_current_bet() * multiplier)
	_ui_ctrl.set_winned_value(_slot_ui.get_current_bet() * multiplier)
	
	if multiplier == 0: 
		yield(get_tree().create_timer(_lose_duration), "timeout")
	else:
		_slot_ui.display_multiplier(multiplier, _win_duration)
	
	_ui_ctrl.reset_winned_value()
	if !_slot_ui.slot_can_continue():
		_ui_ctrl.on_slot_stoped()

#get the current result
func get_current_result() -> Array:
	return _current_result
