extends Control

@export var next_scene: String

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioManager.play_special_sfx(3)
	

func _on_win_timer_timeout():
	
	var inf = false
	
	for i in GameManager.player_characters:
		if i.infected:
			inf = true
	
	if inf:
		AudioManager.play_sfx(3)
		$Label.text = "You escaped?"
	



func _on_timer_timeout():
	GameManager.switch_Scene(next_scene, next_scene)
