extends Node
class_name UiRef

export (NodePath) var _credits_amount = null setget ,credits
export (NodePath) var _bet_amount = null setget ,bet_amount
export (NodePath) var _play_btn = null setget ,play_btn
export (NodePath) var _auto_play_btn = null setget ,auto_play_btn
export (NodePath) var _add_credits_btn = null setget ,add_credits_btn
export (NodePath) var _remove_credits_btn = null setget ,remove_credits_btn

# Return ref to the creadits label
func credits() -> Label:
	return get_node(_credits_amount) as Label

# Return ref to the bet amount spinBox
func bet_amount() -> SpinBox:
	return get_node(_bet_amount) as SpinBox

# Return ref to the play texture Button 
func play_btn() -> Button:
	return get_node(_play_btn) as Button

# Return ref to the auto play texture Button
func auto_play_btn() -> Button:
	return get_node(_auto_play_btn) as Button

func add_credits_btn() -> Button:
	return get_node(_add_credits_btn) as Button

func remove_credits_btn() -> Button:
	return get_node(_remove_credits_btn) as Button

func get_bet_amount() -> int:
	return floor(bet_amount().get_value()) as int

func change_interactables_state(state : bool):
	play_btn().set_disabled(!state)
	auto_play_btn().set_disabled(!state)
	add_credits_btn().set_disabled(!state)
	remove_credits_btn().set_disabled(!state)
	bet_amount().set_editable(state)

func set_min_value(value : int):
	bet_amount().set_min(value)
	bet_amount().set_step(value)
	bet_amount().set_value(value)

func set_max_value(value : int):
	bet_amount().set_max(value)
