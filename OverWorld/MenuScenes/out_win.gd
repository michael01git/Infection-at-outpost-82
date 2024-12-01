extends Control

@export var next_scene: String


# Called when the node enters the scene tree for the first time.
func _ready():
	
	AudioManager.play_music(0)
	AudioManager.play_special_sfx(1)

func _on_win_t_imer_timeout():
	
	
	
	
	var inf = false
	
	for i in GameManager.player_characters:
		if i.infected:
			inf = true
	
	if inf:
		GameManager.clear_out_infected()
		
		AudioManager.play_sfx(3)
		
		## Start an encounter with infected individuals.
		GameManager.start_encounter(GameManager.infected)
		
		
	else:
		AudioManager.play_sfx(1)
		$Label.text = "You escaped!" 



func _on_timer_timeout():
	GameManager.switch_Scene(next_scene, next_scene)
