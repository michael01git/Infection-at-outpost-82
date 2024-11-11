extends Node2D

@onready var enemy_children: Array = get_children()
@onready var encounter_enemies = GameManager.encounter_enemies

func organize():
	var loops: int = 0
	
	while loops < encounter_enemies.size():
		enemy_children[loops].stats_resource = encounter_enemies[loops].duplicate()
		
		loops += 1
	
	# Checking deletion.
	for i in enemy_children:
		i.check_deletion()
	
	await get_tree().process_frame
	
	enemy_children = get_children()
	
	for i in enemy_children:
		i.ready()
