extends Node
class_name slot_system

signal slot_spining
signal slot_stoped

export (Resource) var item_list
export (PackedScene) var _column_actor
export (float) var _column_width = 320.0
export (float) var _column_margin = 5.0

var _columns : Array = []
var _current_sprinnings : int = 0 setget ,get_spin_count
var _current_bet : int = 0 setget ,get_current_bet

func _ready():
	_generate_columns()

func _generate_columns():
	randomize()
	for i in range(-1, 2):
		var current_column = _column_actor.instance() as Node2D
		_columns.push_back(current_column)
		$columns.add_child(current_column)
		current_column.init(Vector2(i * (_column_width + _column_margin),0),_column_width,item_list.get_group_array())

# called for start spinning

func _slot_internal_spin_controller():
	for column in _columns:
		column.start_spinning()
		yield(get_tree().create_timer(randf()*0.75 + 0.25) ,"timeout")
	
	emit_signal("slot_spining")
	print("Slot Spining!")


# wait for all columns to emit stop confirmation
func _wait_all_columns_stop(callerInder : int):
	for column in _columns:
		if !column.is_stoped(): return
	
	_current_sprinnings -= 1
	print("All columns are stoped, emiting signal!")
	emit_signal("slot_stoped")

func get_spin_count() -> int: return _current_sprinnings

func get_current_bet() -> int: return _current_bet

func reset_bet_amout(): _current_bet = 0

func start_spinning_columns(value : int, betAmount : int):
	_current_sprinnings = value
	_current_bet = betAmount
	_slot_internal_spin_controller()

# Stop spinning with values
func stop_slot_on(value : Array):
	for i in _columns.size():
		_columns[i].stop_spinning_at(value[i])
		_columns[i].connect("column_stoped" , self, "_wait_all_columns_stop", [i], CONNECT_ONESHOT)

# continue if auto 
func slot_can_continue() -> bool:
	if _current_sprinnings > 0:
		_slot_internal_spin_controller()
		return true
	return false
