extends Node2D
class_name column_controller

signal column_stoped

export (PackedScene) var slot_icon_actor
export (float, 0, 1) var icon_percent_spacing
export (int,10 , 40, 1) var column_size = 10
export (Vector2) var min_max_column_speed = Vector2(100 , 80)
export (float) var _drag_force = 5.0
export (float, 100, 600, 1) var approach_speed = 60

var _column_width : float
var _current_wheel : Array = []
var _entrance_count : Array = []
var _current_speed : float = 0
var _items_list : Array = []

onready var _collision_shape := get_node("Area2D/CollisionShape2D")

func init(position : Vector2, width : float, list : Array):
	self.set_position(position)
	_column_width = width
	_items_list = list
	_items_list.shuffle()
	_collision_shape.shape.set_extents(Vector2(_column_width * 0.5,10))	
	_do_wheel()
	

func start_spinning():
	_current_speed = randf() * min_max_column_speed.y * 10.0 + min_max_column_speed.x * 10.0

func stop_spinning_at(value : int):
	while _current_speed > approach_speed:
		_current_speed -= _drag_force
		yield(get_tree(), "idle_frame")
	_collision_shape.get_parent().connect("area_entered",self,"_item_at_center", [value])


func _physics_process(delta):
	if _current_speed > 0:
		_move_column(delta)


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

func _move_column(delta : float):
	for i in range(_current_wheel.size()-1 , -1 , -1):
		_current_wheel[i].icon_move(_current_speed)

func _force_move_column(value : float):
	for i in range(_current_wheel.size()-1 , -1 , -1):
		_current_wheel[i].icon_force_move(value)

func _on_icon_replace(item : Node2D):
	var called_by_index = _current_wheel.find(item)
	var next_index = called_by_index + 1 if (called_by_index + 1 < _current_wheel.size()) else 0
	
	_current_wheel[called_by_index].set_position(_current_wheel[next_index].get_position() 
	+ Vector2.UP * _column_width * icon_percent_spacing) 


# gets the string name of the item
func _item_at_center(item : Area2D, target_item : int):
	if item.get_parent().get_type() == target_item:
		_collision_shape.get_parent().disconnect("area_entered",self, "_item_at_center")
		_target_on_center(item.get_parent())

func _target_on_center(item : Node2D):
	while abs(item.get_position().y) > 10 : 
		yield(get_tree(),"physics_frame")
	
	_current_speed = 0
	_force_move_column(abs(item.get_position().y))
	
	emit_signal("column_stoped")
