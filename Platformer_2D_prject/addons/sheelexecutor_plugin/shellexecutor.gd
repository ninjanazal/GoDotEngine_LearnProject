tool
extends EditorPlugin

var element;

func _enter_tree():
	element = preload("res://addons/sheelexecutor_plugin/shellController.tscn").instance();
	
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_BL, element);
	element.get_node("VBoxContainer/Button").connect('pressed', self, '_on_btn_pressed');


func _on_btn_pressed():
	var output = [];
	if element.get_node("VBoxContainer/LineEdit").get_text() == '':
		element.get_node("VBoxContainer/ColorRect/RichTextLabel").set_text('Insert a valid command');
		return;

	OS.execute("CMD.exe", ["/C", element.get_node("VBoxContainer/LineEdit").get_text()],true, output);
	element.get_node("VBoxContainer/ColorRect/RichTextLabel").set_text(str(output));


func _exit_tree():
	remove_control_from_docks(element);


