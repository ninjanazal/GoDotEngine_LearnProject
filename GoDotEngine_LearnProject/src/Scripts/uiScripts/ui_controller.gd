extends Node
export (NodePath) var ui_root = null

onready var _ui_view := get_node(ui_root) as Object
onready var _player_controller := get_node("../player_controller") as Node

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Loading UI Controller")
	_ui_view.credits().set_text(str(_player_controller.get_current_credits()))
