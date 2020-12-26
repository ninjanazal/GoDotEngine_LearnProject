extends Node
class_name slot_system

signal slot_spinning
signal slot_stoped

export (Array,Resource) var item_list
export (PackedScene) var _column_actor
export (float) var _column_width = 320.0
export (float) var _column_margin = 5.0

var _columns : Array = []
var _current_sprinnings : int = 0
var _is_slot_spinning = false setget ,isSpinning


func _ready():
	_generate_columns()

func _generate_columns():
	randomize()
	for i in range(-1, 2):
		var current_column = _column_actor.instance() as Node2D
		_columns.push_back(current_column)
		$columns.add_child(current_column)
		current_column.init(Vector2(i * (_column_width + _column_margin),0),_column_width,item_list)

func isSpinning() -> bool:
	return _is_slot_spinning

# called for start spinning
func start_spinning_columns():
	for column in _columns:
		column.start_spinning()
		yield(get_tree().create_timer(randf()*1.0 + 0.5) ,"timeout")
	_is_slot_spinning = true
	emit_signal("slot_spinning")
	print("Slot Spining!")


func force_stop_spinning():
	_is_slot_spinning = false
	for column in _columns:
		column.stop_spinning()
	print("Slot forced stoping")

func waiting_for_columns_stop():
	for column in _columns:
		yield(column, "column_stoped")
	emit_signal("slot_stoped")
