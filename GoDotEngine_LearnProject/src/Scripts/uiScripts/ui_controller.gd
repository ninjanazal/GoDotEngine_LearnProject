extends Node
export (NodePath) var ui_root = null
export (PackedScene) var autoplay_popup = null

onready var _ui_view := get_node(ui_root) as Control
onready var _player_controller := get_node("../player_controller") as Node
onready var _popup_controller := get_node("popup_controller") as Node


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Loading UI Controller")
	if not autoplay_popup : GlobalFunctions.CloseApp("No Auto play popup defined")
	_popup_controller.start(_ui_view.get_path())
	
	_ui_view.credits().set_text(str(_player_controller.get_current_credits()))
	_ui_view.set_min_value(_player_controller.get_min_credit())
	
	_set_signals_responses()
	print("UI Loaded")


#signals callbacks
# on credits value changed
func on_credits_value_changed():
	_ui_view.credits().set_text(str(_player_controller.get_current_credits()))


#signals configuration
func _set_signals_responses():
	#UI to player
	_ui_view.add_credits_btn().connect("pressed",_player_controller,"change_credits",[5])
	_ui_view.remove_credits_btn().connect("pressed",_player_controller,"change_credits",[-5])
	_ui_view.auto_play_btn().connect("pressed",_popup_controller,"on_autoplay_pressed",
		[autoplay_popup, funcref(_player_controller,"can_play_rounds")])
	
	#player to Ui
	_player_controller.connect("creadits_changed",self,"on_credits_value_changed")

# called when the popup is closed
func _on_popup_closed():
	_ui_view.change_interactables_state(true)

# called when the popup exit with confirm
func _on_popup_confirmed(value : int):
	print("exit with value {value}".format({"value": value}))
	_ui_view.change_interactables_state(true)
