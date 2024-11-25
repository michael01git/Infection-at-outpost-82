extends Panel

var my_item_manager: Control

func set_up_box_info(item_manager: Control, type: String, name: String):
	my_item_manager = item_manager
	
	print("set_up_info")
	$ItemBoxText.text = name

func cursor_select() -> void:
	emit_signal("pressed")
