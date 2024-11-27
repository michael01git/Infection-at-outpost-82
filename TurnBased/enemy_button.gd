extends Label

@export var own_enemy: Node2D

func cursor_select() -> void:
	own_enemy.on_select_button_pressed()

func set_up(name: String) -> void:
	text = name
