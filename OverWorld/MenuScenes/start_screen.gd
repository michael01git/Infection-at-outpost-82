extends Control

@export var next_scene: String

func _unhandled_input(event):
	if event.is_action_pressed("use"):
		GameManager.switch_Scene(next_scene, next_scene)
