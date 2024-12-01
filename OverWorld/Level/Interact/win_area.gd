extends Area2D

@export var win_event: String
@export var win_scene_path: String

func _on_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index):
	if GameManager.events.has(win_event):
		GameManager.switch_Scene(win_scene_path, win_scene_path)
