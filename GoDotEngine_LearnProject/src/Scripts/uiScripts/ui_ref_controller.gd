extends Node

export (NodePath) var _credits_amount = null setget ,credits
export (NodePath) var _bet_amount = null
export (NodePath) var _play_btn = null
export (NodePath) var _auto_play_btn = null

# Return ref to the creadits label
func credits()-> Label:
	return get_node(_credits_amount) as Label

# Return ref to the bet amount spinBox
func bet_amount()-> SpinBox:
	return get_node(_bet_amount) as SpinBox

# Return ref to the play texture Button 
func play_btn()-> TextureButton:
	return get_node(_play_btn) as TextureButton

# Return ref to the auto play texture Button
func auto_play_btn() -> TextureButton:
	return get_node(_auto_play_btn) as TextureButton
