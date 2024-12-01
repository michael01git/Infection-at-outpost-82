extends Control

@export var next_scene: String
@onready var animation_player = $AnimationPlayer

@export var restart_mobs: Array[BattlerStats]
@export var restart_items: Array[ItemStats]

func _unhandled_input(event):
	if event.is_action_pressed("use"):
		if !animation_player.is_playing():
			AudioManager.play_sfx(2)
			animation_player.play("start")

func _ready():
	AudioManager.play_sfx(4)

func _on_animation_player_animation_finished(anim_name):
	
	GameManager.reset()
	
	GameManager.switch_Scene(next_scene, next_scene)

func restart_stats() -> void:
	for i in restart_mobs:
		i.reset()
	
	for i in restart_items:
		i.reset()
