class transition:
	var _event_name = '';
	var _from : Array;
	var _to : int;
	var _on_transition : FuncRef;
	
	func _init(name : String , from : Array , to : int , transition_call : FuncRef = null):
		self._event_name = name;
		self._from = from;
		self._to = to;
		self._on_transition = transition_call; 
	
	
	func named() -> String:
		return _event_name;
	
	
	func validate_from(current : int) -> bool:
		for i in range(_from.size()):
			if _from[i] == current: return true;
		return false;
	
	
	func to_state() -> int:
		return _to;
	
	
	func run_transition() -> GDScriptFunctionState:
		if _on_transition:
			return _on_transition.call_func();
		return null;
		
