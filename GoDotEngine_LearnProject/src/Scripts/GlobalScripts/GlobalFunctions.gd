extends Node

func CloseApp(text: String):
	if not text.empty(): print("Exit with : {value}".format({"value":text}))
	get_tree().quit()

