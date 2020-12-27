extends Node
class_name game_controller

export (Resource) var slot_group

var _slot_entrances : Array = []

func _ready():
	_validate_resource()
	_generate_slot_entrances(slot_group)

func _validate_resource():
	slot_group = slot_group as slot_group
	if slot_group == null : 
		GlobalFunctions.CloseApp("Controller with bad resource")

func _generate_slot_entrances(group : slot_group):
	for slot_item in group.get_group_array():
		for i in slot_item.get_icon_entrances():
			_slot_entrances.append(slot_item.get_icon_type())
	print("Registed {value} entrances".format({"value":_slot_entrances.size()}))
