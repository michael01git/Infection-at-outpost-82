extends Control

@onready var menu = $Menu
@onready var menu_cursor = $Menu/MenuCursor



@onready var inventory_view = $Menu/MarginContainerInvFull/InventoryView
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
