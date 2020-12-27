extends Node
class_name slot_system

signal slot_spining
signal slot_stoped

export (Resource) var item_list
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
		current_column.init(Vector2(i * (_column_width + _column_margin),0),_column_width,item_list.get_group_array())

func isSpinning() -> bool:
	return _is_slot_spinning

# called for start spinning
func start_spinning_columns(value : int):
	_current_sprinnings = value
	_slot_internal_spin_controller()

func _slot_internal_spin_controller():
	for column in _columns:
		column.start_spinning()
		yield(get_tree().create_timer(randf()*0.75 + 0.25) ,"timeout")

	_is_slot_spinning = true
	emit_signal("slot_spining")
	print("Slot Spining!")

# Stop spinning with values
func stop_slot_on(value : Array):
	for i in _columns.size():
		_columns[i].stop_spinning_at(value[i])
