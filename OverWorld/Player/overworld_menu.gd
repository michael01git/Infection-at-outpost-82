extends Control

@onready var prompt = get_tree().get_first_node_in_group("text_prompter")


@onready var menu = $Menu
@onready var menu_cursor = $Menu/MenuCursor



@onready var inventory_view = $Menu/MarginContainerInvFull/InventoryView
@onready var full_menu_cursor = $Menu/MarginContainerInvFull/InventoryView/FullMenuCursor

@onready var mc_sprite_1 = $Menu/MarginContainer/Sections/CharacterIcons/MCIcon1/MCIcon1/MCSprite1
@onready var mc_name_1 = $Menu/MarginContainer/Sections/CharacterIcons/MCIcon1/MCIcon1/MCName1
@onready var mc_sprite_2 = $Menu/MarginContainer/Sections/CharacterIcons/MCIcon2/MCIcon2/MCSprite2
@onready var mc_name_2 = $Menu/MarginContainer/Sections/CharacterIcons/MCIcon2/MCIcon2/MCName2
@onready var mc_sprite_3 = $Menu/MarginContainer/Sections/CharacterIcons/MCIcon3/MCIcon3/MCSprite3
@onready var mc_name_3 = $Menu/MarginContainer/Sections/CharacterIcons/MCIcon3/MCIcon3/MCName3



@onready var armor_1_label = $Menu/MarginContainer/Sections/Options/Armor1/ArmorIcon/Armor1Label
@onready var armor_2_label = $Menu/MarginContainer/Sections/Options/Armor2/ArmorIcon/Armor2Label
@onready var armor_3_label = $Menu/MarginContainer/Sections/Options/Armor3/ArmorIcon/Armor3Label
@onready var weapon_1_label = $Menu/MarginContainer/Sections/Options/Weapon1/WeaponIcon/Weapon1Label
@onready var weapon_2_label = $Menu/MarginContainer/Sections/Options/Weapon2/WeaponIcon/Weapon2Label
@onready var weapon_3_label = $Menu/MarginContainer/Sections/Options/Weapon3/WeaponIcon/Weapon3Label

@onready var key_label = $Menu/MarginContainer/Sections/Options/Keys/VBoxContainer/KeyLabel

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

## Setup character view.
func setup_data():
	
	key_label.show_keys()
	
	mc_name_1.text = "NONE"
	mc_name_2.text = "NONE"
	mc_name_3.text = "NONE"
	
	mc_sprite_1.texture = null
	mc_sprite_2.texture = null
	mc_sprite_3.texture = null
	
	
	if GameManager.player_characters.size() >= 1:
		var player_1 = GameManager.player_characters[0]
		
		mc_sprite_1.texture = player_1.portrait_sprite
		mc_name_1.text = player_1.character
		
		if !player_1.Armor == null:
			armor_1_label.text = player_1.Armor.item_name
		else:
			armor_1_label.text = "EMPTY"
		
		if !player_1.Weapon == null:
			weapon_1_label.text = player_1.Weapon.item_name
		else:
			weapon_1_label.text = "EMPTY"
		
	if GameManager.player_characters.size() >= 2:
		var player_2 = GameManager.player_characters[1]
		
		mc_sprite_2.texture = player_2.portrait_sprite
		mc_name_2.text = player_2.character
		
		if !player_2.Armor == null:
			armor_2_label.text = player_2.Armor.item_name
		else:
			armor_2_label.text = "EMPTY"
		
		if !player_2.Weapon == null:
			weapon_2_label.text = player_2.Weapon.item_name
		else:
			weapon_2_label.text = "EMPTY"
			
	if GameManager.player_characters.size() == 3:
		var player_3 = GameManager.player_characters[2]
		
		mc_sprite_3.texture = player_3.portrait_sprite
		mc_name_3.text = player_3.character
		
		if !player_3.Armor == null:
			armor_3_label.text = player_3.Armor.item_name
		else:
			armor_3_label.text = "EMPTY"
		
		if !player_3.Weapon == null:
			weapon_3_label.text = player_3.Weapon.item_name
		else:
			weapon_3_label.text = "EMPTY"
			
	
	
	
	

func pause_menu():
	setup_data()
	
	if is_menu_paused:
		is_menu_paused = false
		menu_cursor.process_mode = Node.PROCESS_MODE_INHERIT
	elif !is_menu_paused:
		is_menu_paused = true
		menu_cursor.process_mode= Node.PROCESS_MODE_DISABLED
