extends Control

@onready var menu: Control = get_tree().get_first_node_in_group("OWMenu")

func cursor_select() -> void:
	menu.close_full_inventory()
