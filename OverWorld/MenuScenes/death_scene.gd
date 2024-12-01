extends Control

@export var reset_scene: String
@onready var animation_player = $AnimationPlayer

func _ready():
	AudioManager.play_sfx(3)
	AudioManager.play_music(0)

func _unhandled_input(event):
	if event.is_action_pressed("use"):
		animation_player.play("dark")

func _on_animation_player_animation_finished(anim_name):
	GameManager.switch_Scene(reset_scene, reset_scene)
