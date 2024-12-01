extends Node2D

@export var required_event_or_else_delete_parent: String

# Called when the node enters the scene tree for the first time.
func _ready():
	if !GameManager.events.has(required_event_or_else_delete_parent):
		get_parent().queue_free()
