extends Node
var enable_input = true;


func _input(event):
	if enable_input && event is InputEventScreenTouch:
		if (event.pressed):
			print('[INPUTHANDLER]::: toutch catch by input handler');
			get_tree().set_input_as_handled();
			match FiniteSM.current_state:
				FiniteSM.finiteState.PULSING:
					FiniteSM.on_event('onExitingPulsing');
