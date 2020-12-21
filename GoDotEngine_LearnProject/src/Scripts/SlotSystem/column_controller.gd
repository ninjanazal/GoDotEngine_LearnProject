extends Node2D
class_name column_controller

export (PackedScene) var slot_icon_actor
export (float, 0, 1) var icon_percent_spacing
export (int,10 , 40, 1) var column_size = 10
export (Vector2) var min_max_column_speed = Vector2(100 , 80)

var _column_width : float
var _current_wheel : Array = []
var _entrance_count : Array = []
var _current_speed : float = 0
var _items_list : Array = []

func init(position : Vector2, width : float, list : Array):
	self.set_position(position)
	_column_width = width
	_items_list = list
	_items_list.shuffle()
	_do_wheel()
	

# create the wheel
func _do_wheel():
	for i in _items_list.size():
		var curent_column_item = _items_list[i] as slot_item
		var current_node = slot_icon_actor.instance() as Node2D
		self.add_child(current_node)
		
		current_node.init(curent_column_item.get_icon_texture(),curent_column_item.get_icon_type() ,
		Vector2(0,(i-1) * _column_width * icon_percent_spacing), self)
		
		current_node.connect("replace_icon",self,"_on_icon_replace")
		_current_wheel.push_back(current_node)


func start_spinning():
	_current_speed = randf() * min_max_column_speed.y * 10.0 + min_max_column_speed.x * 10.0

func stop_spinning():
	_current_speed = 0

func _on_icon_replace(item : Node2D):
	var called_by_index = _current_wheel.find(item)
	var next_index = called_by_index + 1 if (called_by_index + 1 < _current_wheel.size()) else 0
	
	_current_wheel[called_by_index].set_position(_current_wheel[next_index].get_position() 
	+ Vector2.UP * _column_width * icon_percent_spacing) 

func _process(delta):
	if _current_speed > 0:
		for i in range(_current_wheel.size()-1 , -1 , -1):
			_current_wheel[i].icon_move(_current_speed)
