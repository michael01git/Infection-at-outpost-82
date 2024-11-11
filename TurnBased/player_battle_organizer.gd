extends Node2D

@onready var player_children: Array = get_children()
@onready var player_characters = GameManager.player_characters

func organize():
	var loops: int = 0
	
	while loops < player_characters.size():
		player_children[loops].stats_resource = player_characters[loops]
		
		loops += 1
	
	# Checking deletion.
	for i in player_children:
		i.check_deletion()
	
	await get_tree().process_frame
	
	player_children = get_children()
	
	for i in player_children:
		i.ready()
