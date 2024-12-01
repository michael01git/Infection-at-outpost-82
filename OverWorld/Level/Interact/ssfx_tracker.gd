extends Node2D

@export var event_to_stop: String
@export var event_to_start: String
@export var ssfx_number: int

# Called when the node enters the scene tree for the first time.
func _ready():
	if event_to_stop.is_empty():
		if GameManager.events.has(event_to_start):
			AudioManager.play_special_sfx(ssfx_number)
	elif !GameManager.events.has(event_to_stop):
		AudioManager.play_special_sfx(ssfx_number)
	else:
		queue_free()
