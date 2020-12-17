extends Node
class Player:
	var _credits : int = 0 setget ,get_credits
	
	
	func _init(startCredits : int = 1000):
		_credits = startCredits
	
	func add_credits(addAmount : int):
		_credits += addAmount
	
	func get_credits() -> int:
		return _credits


class_name player_status
signal creadits_changed

var _current_player : Player = null

func _ready():
	_current_player = Player.new(500)

func change_credits(amount : int):
	_current_player.add_credits(amount)
	emit_signal("creadits_changed")

func get_current_credits()-> int:
	return _current_player.get_credits()

