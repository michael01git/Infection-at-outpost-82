extends TextureRect

@export var menu_parent_path: NodePath
@export var cursor_offset: Vector2

@onready var menu_parent := get_node(menu_parent_path)

var cursor_index: int = 0

func _process(_delta):
	var input = Vector2.ZERO
	
	if Input.is_action_just_pressed("up"):
		input.y -= 1
		
	if Input.is_action_just_pressed("down"):
		input.y += 1
		
	if Input.is_action_just_pressed("left"):
		input.x -= 1
		
	if Input.is_action_just_pressed("right"):
		input.x += 1
		
	
	
	if menu_parent is VBoxContainer:
		set_cursor_from_index(cursor_index + input.y)
	elif menu_parent is HBoxContainer:
		set_cursor_from_index(cursor_index + input.x)
	elif menu_parent is GridContainer:
		set_cursor_from_index(cursor_index + input.x + input.y * menu_parent.columns)
	
	if Input.is_action_just_pressed("use"):
		var current_menu_item := get_menu_item_at_index(cursor_index)
		if current_menu_item != null:
			if current_menu_item.has_method("cursor_select"):
				current_menu_item.cursor_select()
				
				AudioManager.play_sfx(4)

func get_menu_item_at_index(index: int) -> Control:
	if menu_parent == null:
		return null
	
	if index >= menu_parent.get_child_count() or index < 0:
		return null
	
	return menu_parent.get_child(index) as Control

func set_cursor_from_index(index: int) -> void:
	
	var menu_item := get_menu_item_at_index(index)
	
	if menu_item == null:
		return
	
	var position = menu_item.global_position
	var size = menu_item.get_rect().size
	
	global_position = Vector2(position.x, position.y + size.y / 2.0) - (get_rect().size/2.0) - cursor_offset
	
	cursor_index = index
	
