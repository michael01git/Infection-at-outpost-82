extends CharacterBody2D

@export var encounter_enemies: Array[BattlerStats]

var ID: int

func _ready():
	if GameManager.check_defeated_enemies(get_parent().name, ID):
		queue_free()
	
	GameManager.get_ID(self)

func _on_player_monitor_body_entered(body):
	GameManager.insert_dead_enemy(get_parent().name, ID)
	body.start_encounter(encounter_enemies)
