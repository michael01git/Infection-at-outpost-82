extends Control

@onready var menu = $Menu
@onready var menu_cursor = $Menu/MenuCursor

var menu_open: bool = false

func _ready():
	close_menu()

func _process(delta):
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
	menu_open = true
	menu.show()
	menu.process_mode = Node.PROCESS_MODE_INHERIT
