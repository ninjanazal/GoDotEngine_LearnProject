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
export (int) var _start_credits = 10
export (int) var _min_bet_value = 1 setget ,get_min_credit

func _ready():
	_current_player = Player.new(_start_credits)


func change_credits(amount : int):
	if _current_player.get_credits() + amount < 0: return
	
	_current_player.add_credits(amount)
	emit_signal("creadits_changed")


# getters
func get_current_credits()-> int:
	return _current_player.get_credits()


func get_min_credit() -> int:
	return _min_bet_value
