extends Node
var finiteState = preload("res://src/Scripts/finitestateautomaton/finitestates.gd");
var finiteTransition = preload("res://src/Scripts/finitestateautomaton/finitetransitions.gd");

signal state_changed(new_state);

onready var current_state = finiteState.IDLE;

onready var transitions = [
	finiteTransition.transition.new('onEnteringState',[finiteState.IDLE],finiteState.ENTERING),
	finiteTransition.transition.new('onStartPulsing',[finiteState.ENTERING],finiteState.PULSING,
			funcref($'/root/root/View/Sprite/TouchScreenButton','set_color')),
	finiteTransition.transition.new('onExitingPulsing',[finiteState.PULSING],finiteState.EXITING),
	finiteTransition.transition.new('onIdleState',[finiteState.EXITING], finiteState.IDLE)
];

var functionState : GDScriptFunctionState = null;


func on_event(event_name : String):
	print('[AUTOMATA]::: New onEvent call');
	for i in range(transitions.size()):
		if transitions[i].validate_from(current_state) &&\
				transitions[i].named() == event_name:
			print('[AUTOMATA]::: Valid on event call -> {eventName}'.format({'eventName': event_name}));
			self.functionState = transitions[i].run_transition();
			print('[AUTOMATA]::: Running transition func');
			if self.functionState:
				print('[AUTOMATA]::: Waiting valid transition func to end');
				yield(self.functionState, 'completed');
			print('[AUTOMATA]::: Changing state');
			current_state = transitions[i].to_state();
			print('[AUTOMATA]::: Emited signal');
			emit_signal("state_changed",current_state);

