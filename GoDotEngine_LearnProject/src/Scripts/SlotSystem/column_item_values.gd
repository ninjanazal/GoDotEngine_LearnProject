extends Node2D
class_name column_item
signal move_icon_to(top)

onready var _icon_sprite := get_node("icon_sprite") as Sprite
var _icon_type : int setget ,get_type
var _parent : Node2D

func init(texture : Texture, type : int, start_position : Vector2, parent : Node2D):
	_parent = parent
	_icon_sprite.set_texture(texture)
	_icon_type = type
	self.set_position(start_position)

func icon_move(amount : float, delta : float):
	self.set_position(self.get_position() + Vector2.DOWN * amount * delta)
	_validate_translaction( true if amount>0 else false )


# confirm if the icon should be reseted
func _validate_translaction(down_move : bool):
	match down_move:
		true:
			if self.get_global_position().y + (_icon_sprite.get_rect().size.y / 2) > get_viewport_rect().size.y:
				emit_signal("move_icon_to",true)
		false:
			if self.get_global_position().y - (_icon_sprite.get_rect().size.y / 2) < 0:
				emit_signal("move_icon_to",false)


# getters
func get_texture() -> Texture:
	return _icon_sprite.get_texture()

func get_type() -> int:
	return _icon_type
