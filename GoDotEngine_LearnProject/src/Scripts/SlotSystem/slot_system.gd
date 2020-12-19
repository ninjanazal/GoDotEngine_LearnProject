extends Node
class_name slot_system

export (PackedScene) var _column_actor
export (float) var _column_width = 320.0
export (float) var _column_margin = 5.0

var _columns : Array = []

func _ready():
	_generate_columns()

func _generate_columns():
	for i in range(-1, 2):
		var current_column = _column_actor.instance() as Node2D
		_columns.push_back(current_column)
		$columns.add_child(current_column)
		current_column.init(Vector2(i * (_column_width + _column_margin),0),_column_width)
