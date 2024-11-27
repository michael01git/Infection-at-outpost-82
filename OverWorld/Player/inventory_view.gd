extends Control

@export var item_box_scene: PackedScene
@export var quit_box_scene: PackedScene

@onready var full_menu_cursor = $FullMenuCursor
@onready var inventory_view = $"."
@onready var inventory_grid = $InventoryGrid
@onready var overworld_menu = $"../../.."

func button_pressed(type: String, number: int):
	
	## Pressed -> Type -> What items to display
	var all_items: Array[ItemStats]
	var usable: bool = true
	
	overworld_menu.pause_menu()
	match type:
		"inventory":
			all_items = GameManager.items
			usable = false
		"armor":
			for i in GameManager.items:
				if i.type == 1:
					all_items.append(i)
		"weapon":
				for i in GameManager.items:
					if i.type == 2:
						all_items.append(i)
		"use":
				for i in GameManager.items:
					if i.type == 0:
						all_items.append(i)
	
	var battler = GameManager.player_characters[(number-1)].character
	
	open_inventory(all_items, usable, battler, number)

func open_inventory(items: Array[ItemStats], usable: bool, battler: String, battler_num: int):
	
	# Enable cursors
	full_menu_cursor.cursor_index = 0
	inventory_view.process_mode = Node.PROCESS_MODE_INHERIT
	await get_tree().process_frame
	
	
	for i in items:
		spawn_box(i, inventory_grid, usable, battler, battler_num)
	
	var quit_box = quit_box_scene.instantiate()
	inventory_grid.add_child(quit_box)
	
	inventory_view.show()

func spawn_box(item_stat: ItemStats, parent: Control, usable: bool, battler: String, battler_num: int):
	var item_box_mob = item_box_scene.instantiate()
	item_box_mob.set_up_box_info(item_stat, usable, battler, battler_num)
	parent.add_child(item_box_mob)

func close_inventory():
	for i in inventory_grid.get_children():
		i.queue_free()
	
	inventory_view.process_mode = Node.PROCESS_MODE_DISABLED
	inventory_view.hide()
	overworld_menu.pause_menu()

func item_box_pressed(item_stat: ItemStats, Battler_num: int):
	var battler: BattlerStats = GameManager.player_characters[(Battler_num-1)]
	
	
	
	# If item is usable.
	if item_stat.type == 0:
		use_item(item_stat, battler)
		return
	
	
	
	## Check if is equipped
	if !item_stat.equipped_by == "NULL":
		## IE NOT EQUIPPED
		
		# If is player held item.
		if battler.Weapon == item_stat or battler.Armor == item_stat:
			unequip_item(item_stat, battler)
		
		
		
		return
	
	
	## Check if is free slot
	match item_stat.type:
		1:
			if battler.Armor != null:
				return
		2:
			if battler.Weapon != null:
				return
	
	
	# If item is not held, it can be equipped.
	equip_item(item_stat, battler)

func unequip_item(item_stat: ItemStats, battler: BattlerStats):
	match item_stat.type:
		1:
			battler.Armor = null
		2:
			battler.Weapon = null
	
	
	battler.damage -= item_stat.damage
	battler.armor -= item_stat.armor
	battler.turn_speed -= item_stat.turn_speed
	battler.max_hp -= item_stat.health
	battler.current_hp -= item_stat.health
	
	item_stat.equipped_by = "NULL"
	
	battler.cap_health()
	
	close_inventory()

func equip_item(item_stat: ItemStats, battler: BattlerStats):
	
	
	match item_stat.type:
		1:
			battler.Armor = item_stat
		2:
			battler.Weapon = item_stat
	
	
	battler.damage += item_stat.damage
	battler.armor += item_stat.armor
	battler.turn_speed += item_stat.turn_speed
	battler.max_hp += item_stat.health
	battler.current_hp += item_stat.health
	
	item_stat.equipped_by = battler.character
	
	battler.cap_health()
	
	close_inventory()

func use_item(item_stat: ItemStats, battler: BattlerStats):
	battler.current_hp += item_stat.health
	
	## NO MULTIPLE USES, JUST ONCE. 
	GameManager.items.erase(item_stat)
	
	battler.cap_health()
	
	close_inventory()
