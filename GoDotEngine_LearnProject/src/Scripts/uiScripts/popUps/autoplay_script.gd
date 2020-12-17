extends Popup
signal popup_closed
signal popup_confirmed(value)

onready var autoplay_value := get_node("VBoxContainer/VBoxContainer/spins_spinbox")
onready var confirm_btn := get_node("VBoxContainer/HBoxContainer/autoplay_confirm_btn")
onready var cancel_btn := get_node("VBoxContainer/HBoxContainer/autoplay_cancel_btn")

var _current_player_credits : int = 0 setget set_current_credits

func set_current_credits(value : int):
	_current_player_credits = value
	autoplay_value.set_max(_current_player_credits)

func _ready():
	self.set_exclusive(true)
	self.set_visible(true)
	
	# regist cancel callback
	cancel_btn.connect("pressed",self,"_on_cancel_press")
	confirm_btn.connect("pressed",self,"_on_confirm_press")
	
func _on_confirm_press():
	print("Confirm button pressed on popup")
	emit_signal("popup_confirmed",int(autoplay_value.get_value()))
	self.queue_free()
	
func _on_cancel_press():
	print("PopUp closed {popName}".format({"popName":self.name}))
	emit_signal("popup_closed")
	self.queue_free()
