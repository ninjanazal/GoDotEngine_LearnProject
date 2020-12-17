extends Node

onready var autoplay_value := get_node("VBoxContainer/VBoxContainer/spins_spinbox")
onready var confirm_btn := get_node("VBoxContainer/HBoxContainer/autoplay_confirm_btn")
onready var cancel_btn := get_node("VBoxContainer/HBoxContainer/autoplay_cancel_btn")

func _ready():
	# regist cancel callback
	cancel_btn.connect("pressed",self,"on_cancel_btn")
	pass
	
func on_cancel_btn():
	print("PopUp closed {popName}".format({"popName":self.name}))
	self.queue_free()
