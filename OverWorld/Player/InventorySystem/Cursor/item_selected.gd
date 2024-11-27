extends Control

signal pressed

func cursor_select() -> void:
	emit_signal("pressed")
