extends Control

@onready var menu: Control = get_tree().get_first_node_in_group("InventoryMenu")

func cursor_select() -> void:
	menu.close_inventory()
