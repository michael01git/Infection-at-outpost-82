extends Area2D

@export var win_event: String
@export var win_scene_path: String
@export var fight_win_path: String

func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if GameManager.events.has(win_event):
		GameManager.switch_Scene(win_scene_path, fight_win_path)
