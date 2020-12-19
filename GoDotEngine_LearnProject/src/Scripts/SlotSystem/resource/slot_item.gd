extends Resource
class_name slot_item

export (Texture) var _icon_texture
export (ConsTypes.kIconType) var _icon_type
export (float) var _icon_percent = 10

func get_icon_type() -> int:
	return _icon_type

func get_icon_percent() -> float:
	return _icon_percent
