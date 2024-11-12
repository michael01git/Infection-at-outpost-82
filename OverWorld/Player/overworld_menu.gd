extends Control

@onready var menu = $Menu
@onready var menu_cursor = $Menu/MenuCursor

@export var item_box_scene: PackedScene
@export var quit_box_scene: PackedScene

@onready var inventory_view = $Menu/MarginContainerInvFull/InventoryView
@onready var inventory_grid = $Menu/MarginContainerInvFull/InventoryView/ItemFullGrid
@onready var full_menu_cursor = $Menu/MarginContainerInvFull/InventoryView/FullMenuCursor


var menu_open: bool = false
var is_menu_paused: bool = false

func _ready():
	close_menu()

func _process(delta):
	if is_menu_paused:
		return
	
	if Input.is_action_just_pressed("menu"):
		if menu.visible:
			close_menu()
		else:
			open_menu()
		

func close_menu():
	menu_open = false
	menu.hide()
	menu.process_mode = Node.PROCESS_MODE_DISABLED

func open_menu():
	menu_cursor.cursor_index = 0
	
	menu_open = true
	menu.show()
	menu.process_mode = Node.PROCESS_MODE_INHERIT

func pause_menu():
	if is_menu_paused:
		is_menu_paused = false
		menu_cursor.process_mode = Node.PROCESS_MODE_INHERIT
	elif !is_menu_paused:
		is_menu_paused = true
		menu_cursor.process_mode= Node.PROCESS_MODE_DISABLED

func _on_inventory_pressed():
	pause_menu()
	open_full_inventory()

func open_full_inventory():
	full_menu_cursor.cursor_index = 0
	
	inventory_view.process_mode = Node.PROCESS_MODE_INHERIT
	await get_tree().process_frame
	
	var all_items: Array[ItemStats] = GameManager.weapon_items + GameManager.armor_items + GameManager.usable_items
	## Maybe sort these?
	
	for i in all_items:
		spawn_box(i, inventory_grid)
	
	var quit_box = quit_box_scene.instantiate()
	inventory_grid.add_child(quit_box)
	
	inventory_view.show()

func spawn_box(item_stat: ItemStats, parent: Control):
	var item_box_mob = item_box_scene.instantiate()
	item_box_mob.set_up_box_info(item_stat.item_name)
	parent.add_child(item_box_mob)

func close_full_inventory():
	for i in inventory_grid.get_children():
		i.queue_free()
	
	inventory_view.process_mode = Node.PROCESS_MODE_DISABLED
	inventory_view.hide()
	pause_menu()
