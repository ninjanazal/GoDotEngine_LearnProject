extends Node
export (NodePath) var ui_root = null
export (PackedScene) var autoplay_popup = null

onready var _ui_view := get_node(ui_root) as Control
onready var _player_controller := get_node("../player_controller") as Node

var _exposed_popup = null

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Loading UI Controller")
	_ui_view.credits().set_text(str(_player_controller.get_current_credits()))
	_ui_view.set_min_value(_player_controller.get_min_credit())
	
	if not autoplay_popup : GlobalFunctions.CloseApp("No Auto play popup defined")
	
	_set_signals_responses()
	print("UI Loaded")

#signals configuration
func _set_signals_responses():
	#UI to player
	_ui_view.add_credits_btn().connect("pressed",_player_controller,"change_credits",[5])
	_ui_view.remove_credits_btn().connect("pressed",_player_controller,"change_credits",[-5])
	_ui_view.auto_play_btn().connect("pressed",self,"on_autoplay_pressed")
	
	#player to Ui
	_player_controller.connect("creadits_changed",self,"on_credits_value_changed")

#signals callbacks
# on credits value changed
func on_credits_value_changed():
	_ui_view.credits().set_text(str(_player_controller.get_current_credits()))

#on auto play pressed
func on_autoplay_pressed():
	if _exposed_popup : return
	
	# PopUp
	print("Loading popup resource")
	_exposed_popup = autoplay_popup.instance()
	_ui_view.add_child(_exposed_popup)
	
	_exposed_popup.set_exclusive(true)
	_exposed_popup.set_visible(true)
	print("popup in scene")
		
	_ui_view.change_interactables_state(false)
