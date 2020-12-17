extends Node
export (NodePath) var ui_root = null

onready var _ui_view := get_node(ui_root) as Control
onready var _player_controller := get_node("../player_controller") as Node

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Loading UI Controller")
	_ui_view.credits().set_text(str(_player_controller.get_current_credits()))
	_set_signals_responses()

#signals configuration
func _set_signals_responses():
	#UI to player
	_ui_view.add_credits_btn().connect("pressed",_player_controller,"change_credits",[5])
	_ui_view.remove_credits_btn().connect("pressed",_player_controller,"change_credits",[-5])
	
	#player to Ui
	_player_controller.connect("creadits_changed",self,"on_credits_value_changed")

#signals callbacks
# on credits value changed
func on_credits_value_changed():
	_ui_view.credits().set_text(str(_player_controller.get_current_credits()))
