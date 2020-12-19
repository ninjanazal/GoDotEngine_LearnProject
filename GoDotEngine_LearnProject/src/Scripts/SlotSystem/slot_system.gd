extends Node
class_name slot_system

signal slot_spinning

export (Array,Resource) var item_list
export (PackedScene) var _column_actor
export (float) var _column_width = 320.0
export (float) var _column_margin = 5.0

var _columns : Array = []

func _ready():
	_generate_columns()

func _generate_columns():
	randomize()
	for i in range(-1, 2):
		var current_column = _column_actor.instance() as Node2D
		_columns.push_back(current_column)
		$columns.add_child(current_column)
		current_column.init(Vector2(i * (_column_width + _column_margin),0),_column_width,item_list)

func start_spinning_columns():
	for column in _columns:
		column.start_spinning()
		yield(get_tree().create_timer(randf()*1.0 + 0.5) ,"timeout")
	emit_signal("slot_spinning")
	print("Slot Spining!")
