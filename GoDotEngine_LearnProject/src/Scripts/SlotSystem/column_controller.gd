extends Node2D
class_name column_controller

export(Array, Resource) var _items_list
export (PackedScene) var slot_icon_actor
export (float, 0, 1) var icon_percent_spacing

var _column_width : float
var _current_wheel : Array = []
var _entrance_count : Array = []

func init(position : Vector2, width : float):
	self.set_position(position)
	_column_width = width
	_do_wheel()
	
# wheel entrance count
func _generate_entrance_count():
	for i in _items_list.size():
		for entrance in range(_items_list[i].get_icon_entrances()):
			_entrance_count.push_back(i)

# create the wheel
func _do_wheel():
	_generate_entrance_count()

	for i in _items_list.size():
		var get_random_item = _items_list[_entrance_count[randi() % _entrance_count.size()]] as slot_item
		var current_node = slot_icon_actor.instance() as Node2D
		self.add_child(current_node)
		
		current_node.init(get_random_item.get_icon_texture(),get_random_item.get_icon_type() ,
		Vector2(0,(i-1) * _column_width * icon_percent_spacing), self)
		_current_wheel.push_back(current_node)


func start_spinning():
	pass
