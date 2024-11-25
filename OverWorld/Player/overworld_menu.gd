extends Control

@onready var prompt = get_tree().get_first_node_in_group("text_prompter")

@onready var menu = $Menu
@onready var menu_cursor = $Menu/MenuCursor



@onready var inventory_view = $Menu/MarginContainerInvFull/InventoryView
@onready var full_menu_cursor = $Menu/MarginContainerInvFull/InventoryView/FullMenuCursor

@onready var main_character_1_button = $Menu/MarginContainer/Sections/Options/MainCharacter1Button
@onready var main_character_button_2 = $Menu/MarginContainer/Sections/Options/MainCharacterButton2
@onready var main_character_button_3 = $Menu/MarginContainer/Sections/Options/MainCharacterButton3

var menu_open: bool = false
var is_menu_paused: bool = false

func _ready():
	close_menu()

func _process(delta):
	if !prompt.prompts_empty:
		return
	
	if is_menu_paused:
		return
	
	if Input.is_action_just_pressed("menu"):
		
		
		if menu.visible:
			close_menu()
		else:
			open_menu()
		

func close_menu():
	hide()
	GameManager.pause_mobs = false
	
	menu_open = false
	menu.hide()
	menu.process_mode = Node.PROCESS_MODE_DISABLED

func open_menu():
	show()
	GameManager.pause_mobs = true
	
	setup_data()
	
	menu_cursor.cursor_index = 0
	
	menu_open = true
	menu.show()
	menu.process_mode = Node.PROCESS_MODE_INHERIT

func setup_data():
	main_character_1_button.text = GameManager.player_characters[0].character

func pause_menu():
	if is_menu_paused:
		is_menu_paused = false
		menu_cursor.process_mode = Node.PROCESS_MODE_INHERIT
	elif !is_menu_paused:
		is_menu_paused = true
		menu_cursor.process_mode= Node.PROCESS_MODE_DISABLED
