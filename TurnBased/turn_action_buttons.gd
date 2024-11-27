extends Control

@onready var mob_select = $"../MobSelectMenu"
@onready var mob_cursor = $"../MobSelectMenu/MobCursor"

@onready var turn_cursor = $TurnCursor

@onready var menu_cursor = $"../UseActionButtons/MenuCursor"
@onready var use_action_buttons = $"../UseActionButtons"

func _ready():
	turn_cursor.cursor_index = 0
	mob_cursor.cursor_index = 0
	
	mob_cursor.process_mode = Node.PROCESS_MODE_DISABLED

func show_TA():
	await get_tree().create_timer(1).timeout
	turn_cursor.process_mode = Node.PROCESS_MODE_INHERIT
	
	turn_cursor.cursor_index = 0
	turn_cursor.show()
	show()

func hide_TA():
	turn_cursor.process_mode = Node.PROCESS_MODE_DISABLED
	turn_cursor.hide()
	hide()

func show_enemy_buttons(enemy_battlers) -> void:
	await get_tree().create_timer(0.25).timeout
	mob_cursor.process_mode = Node.PROCESS_MODE_INHERIT
	
	mob_cursor.cursor_index = 0
	mob_cursor.show()
	mob_select.show()
	

func hide_enemy_buttons(enemy_battlers) -> void:
	mob_cursor.process_mode = Node.PROCESS_MODE_DISABLED
	
	mob_cursor.hide()
	mob_select.hide()
	
