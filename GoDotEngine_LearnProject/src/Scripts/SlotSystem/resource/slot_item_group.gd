extends Resource
class_name slot_group

export(Array,Resource) var _item_array

func get_group_array() -> Array:
	return _item_array

func get_first_by_type(type : int) -> slot_item:
	if _item_array.size() == 0: return null
	for i in _item_array.size():
		if _item_array[i].get_icon_type() == type:
			return _item_array[i]
	return null
