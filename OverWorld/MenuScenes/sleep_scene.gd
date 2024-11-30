extends Node

@export var next_scene: String

func _on_timer_timeout():
	GameManager.events.append("SLEPT")
	GameManager.switch_Scene(next_scene, next_scene)
