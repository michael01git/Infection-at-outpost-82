extends Control

@export var reset_scene: String

func _unhandled_input(event):
	if event.is_action_pressed("use"):
		GameManager.switch_Scene(reset_scene, reset_scene)
