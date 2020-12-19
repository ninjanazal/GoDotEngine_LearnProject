extends Node2D
class_name column_controller

export(Array, Resource) var _items_list
export (PackedScene) var slot_icon_actor

var column_width : float
var _current_wheel : Array

func _init(position : Vector2, width : float):
	self.set_position(position)
	column_width = width
	
# create the wheel
func _do_wheel():
	for i in range(_items_list.count()):
		var current_node = slot_icon_actor.instance()
		

func start_spinning():
	pass
