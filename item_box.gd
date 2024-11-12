extends Control

func set_up_box_info(name: String):
	print("set_up_info")
	$ItemBoxText.text = name

func cursor_select() -> void:
	emit_signal("pressed")
