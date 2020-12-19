extends Node2D
class_name column_item

onready var _icon_sprite := get_node("icon_sprite") as Sprite
var _icon_type : int setget ,get_type
var _parent : column_controller

func init(texture : Texture, type : int, start_position : Vector2, parent : column_controller):
	_parent = parent
	_icon_sprite.set_texture(texture)
	_icon_type = type
	self.set_position(start_position)

func icon_move(amount : float, delta : float):
	self.set_position(self.get_position() + Vector2.DOWN * amount * delta)
	if !_validate_translaction( true if amount>0 else false ):
		_reset_icon_position(true if amount>0 else false)

# confirm if the icon should be reseted
func _validate_translaction(down_move : bool) -> bool:
	match down_move:
		true:
			if self.get_global_position().y
		false:
			

# reset the icon position
func _reset_icon_position(down_move : bool):
	pass

# getters
func get_texture() -> Texture:
	return _icon_sprite.get_texture()

func get_type() -> int:
	return _icon_type
