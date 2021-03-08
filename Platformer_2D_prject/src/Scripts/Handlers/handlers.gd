extends Node

func _ready():
	FiniteSM.connect('state_changed',self,'on_state_change');


func on_state_change(new_state : int):
	match new_state:
		FiniteSM.finiteState.IDLE:
			$InputHandler.enable_input = true;
			enable_touch_area();
			print('[HANDLER]::: Adapt to idle state');
		FiniteSM.finiteState.ENTERING:
			$InputHandler.enable_input = false;
			print('[HANDLER]::: Adapt to entering state');
		FiniteSM.finiteState.PULSING:
			$InputHandler.enable_input = true;
			print('[HANDLER]::: Enabling input detection');
			

func enable_touch_area():
	$'/root/root/View/Sprite/TouchScreenButton'.connect_to_press();
