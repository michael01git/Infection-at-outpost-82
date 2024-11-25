extends Control

@export var next_scene: String

func _on_restart_screen_timer_timeout():
	
	
	GameManager.switch_Scene(next_scene, next_scene)
