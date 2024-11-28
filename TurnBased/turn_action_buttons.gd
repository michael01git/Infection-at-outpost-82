extends Control

@onready var mob_select = $"../MobSelectMenu"
@onready var mob_cursor = $"../MobSelectMenu/MobCursor"

@onready var turn_cursor = $TurnCursor


func _ready():
	turn_cursor.cursor_index = 0
	mob_cursor.cursor_index = 0
	
	mob_cursor.process_mode = Node.PROCESS_MODE_DISABLED

func show_TA():
	await get_tree().process_frame
	turn_cursor.process_mode = Node.PROCESS_MODE_INHERIT
	turn_cursor.cursor_index = 0
	turn_cursor.show()
	show()
	
	wait_for_reset(self)

func hide_TA():
	turn_cursor.process_mode = Node.PROCESS_MODE_DISABLED
	turn_cursor.hide()
	hide()

func show_enemy_buttons(enemy_battlers) -> void:
	await get_tree().process_frame
	mob_cursor.process_mode = Node.PROCESS_MODE_INHERIT
	mob_cursor.cursor_index = 0
	mob_cursor.show()
	mob_select.show()
	
	wait_for_reset(mob_select)
	


func wait_for_reset(node: Node):
	node.modulate = Color(0,0,0,0)
	await get_tree().create_timer(0.25).timeout
	node.modulate = Color(1,1,1,1)

func hide_enemy_buttons(enemy_battlers) -> void:
	mob_cursor.process_mode = Node.PROCESS_MODE_DISABLED
	
	mob_cursor.hide()
	mob_select.hide()
	
