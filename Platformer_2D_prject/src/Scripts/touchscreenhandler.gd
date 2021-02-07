extends TouchScreenButton

func _ready():
	FiniteSM.connect("state_changed",self,'on_state_change');
	connect_to_press();

func on_pressed_event():
	print('[TOUCH]::: touchScreenButton pressed');
	get_tree().set_input_as_handled();
	FiniteSM.on_event('onEnteringState');


func on_state_change(new_state):
	print('[TOUCH]::: recieved event alteration to state: {newState}'.format({'newState':new_state}));
	match new_state:
		FiniteSM.finiteState.ENTERING:
			print('[TOUCH]::: Recieve entering state.... Request pulsing');
			FiniteSM.on_event('onStartPulsing');
		FiniteSM.finiteState.PULSING:
			print('[TOUCH]::: Start pulsing');
			$'../AnimationPlayer'.play("enter_state");
		FiniteSM.finiteState.EXITING:
			print('[TOUCH]::: Setting Exiting');
			$'../AnimationPlayer'.stop();
			$'../AnimationPlayer'.seek(0,true);
			FiniteSM.on_event('onIdleState');

func set_color():
	get_parent().self_modulate = Color(1,0,0,1);
	yield(get_tree().create_timer(2),"timeout");

func connect_to_press():
	self.connect("pressed",self,'on_pressed_event',[],CONNECT_ONESHOT);
