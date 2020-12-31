extends Resource
class_name slot_item

export (Texture) var _icon_texture
export (ConsTypes.kIconType) var _icon_type
export (float) var _icon_entrance_count = 10
export (float) var _item_multiplier

func get_icon_type() -> int:
	return _icon_type

func get_icon_texture() -> Texture:
	return _icon_texture

func get_icon_entrances() -> float:
	return _icon_entrance_count

func get_icon_multiplier() -> float:
	return _item_multiplier
