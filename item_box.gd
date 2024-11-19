extends Control



@onready var inventory: Control = get_tree().get_first_node_in_group("InventoryMenu")
var is_usable: bool = false
var item_held: ItemStats
var battler_number: int

func set_up_box_info(item_stat: ItemStats, usable: bool, battler: int):
	print("set_up_info")
	battler_number = battler
	item_held = item_stat
	$ItemBoxText.text = item_held.item_name
	$CheckBox.button_pressed = item_held.equipped
	is_usable = usable

func cursor_select() -> void:
	if is_usable:
		inventory.item_box_pressed(item_held, battler_number)
