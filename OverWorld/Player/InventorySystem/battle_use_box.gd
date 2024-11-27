extends Control

@onready var inventory: Control = get_tree().get_first_node_in_group("InventoryMenu")
var item_held: ItemStats

func set_up_box_info(item_stat: ItemStats):
	print("set_up_info")
	item_held = item_stat
	$VBoxContainer/ItemBoxText.text = item_held.item_name
	$VBoxContainer/CheckBox.button_pressed = item_held.equipped

func cursor_select() -> void:
	inventory.item_box_pressed(item_held)
