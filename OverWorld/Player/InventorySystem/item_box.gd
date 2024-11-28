extends Control

@onready var inventory: Control = get_tree().get_first_node_in_group("InventoryMenu")

var is_usable: bool = false
var item_held: ItemStats
var battler_name: String
var battler_num_safe: int

func set_up_box_info(item_stat: ItemStats, usable: bool, battler: String, battler_num: int):
	print("set_up_info")
	battler_name = battler
	item_held = item_stat
	battler_num_safe = battler_num
	$VBoxContainer/ItemBoxText.text = item_held.item_name
	
	var stats = $VBoxContainer/Stats
	
	if item_stat != null:
		stats.text = "D:"+str(item_stat.damage)+", A:"+str(item_stat.armor)+", S:"+str(item_stat.turn_speed)
	
	
	if item_stat.type == 0:
		$VBoxContainer/User.visible = false
		$VBoxContainer/ItemBoxText.vertical_alignment = 1
		if item_stat != null:
			if item_stat.use_type == 0:
				stats.text = "Heals by +"+str(item_stat.health)
			elif item_stat.use_type == 1:
				stats.text = "Test a Character"
	elif item_stat.equipped_by == "NULL":
		$VBoxContainer/User.text = "Unequipped"
	else:
		$VBoxContainer/User.text = item_stat.equipped_by
	
	is_usable = usable

func cursor_select() -> void:
	if is_usable:
		inventory.item_box_pressed(item_held, battler_num_safe)
