extends Node2D
class_name column_item

signal replace_icon(Node2D)

onready var _icon_sprite := get_node("icon_sprite") as Sprite
var _icon_type : int setget ,get_type
var _parent : Node2D

func init(texture : Texture, type : int, start_position : Vector2, parent : Node2D):
	_parent = parent
	_icon_type = type
	_icon_sprite.set_texture(texture)
	self.set_position(start_position)

func icon_move(amount : float):
	self.set_position(self.get_position() + Vector2.DOWN * amount * self.get_process_delta_time())
	_validate_translaction()

# confirm if the icon should be reseted
func _validate_translaction():
	if abs(self.get_global_position().y - (_icon_sprite.get_rect().size.y / 2)) > get_viewport_rect().size.y:
		emit_signal("replace_icon", self)


# getters
func get_texture() -> Texture:
	return _icon_sprite.get_texture()

func get_type() -> int:
	return _icon_type
