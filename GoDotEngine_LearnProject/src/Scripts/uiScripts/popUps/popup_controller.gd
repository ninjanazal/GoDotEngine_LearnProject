extends Node
class_name PopUpController

var _exposed_popup = null
var _ui_view : Control = null

func start(ui_view : NodePath):
	_ui_view = get_node(ui_view)

# popUp
#on auto play pressed
func on_autoplay_pressed(autoplay_popup : PackedScene, get_player_credits : FuncRef):
	if _exposed_popup : return
	
	# PopUp
	print("Loading popup resource")
	_exposed_popup = autoplay_popup.instance()
	_ui_view.add_child(_exposed_popup)
	_exposed_popup.set_current_credits(get_player_credits.call_func(_ui_view.get_bet_amount()))
	
	_pop_up_connect()
	print("popup in scene")
		
	_ui_view.change_interactables_state(false)

func _pop_up_connect():
	_exposed_popup.connect("popup_closed",get_parent(), "_on_popup_closed")
	_exposed_popup.connect("popup_confirmed", get_parent(),"_on_popup_confirmed")
