extends Node

## Scene Stuff
var last_ID: int = 0

var lastScene = null
var currentScene = null

# Used to spawn player in same position after fight
var last_player_pos: Vector2 = Vector2.ZERO

# Interacted items.
var interacted_array: Array[String]

# Dictionary of dead enemies. Handled by persistance.
var deadEnemies := Dictionary()

## NEEDED? var next_room_position: Vector2

# Used to spawn player at door in room.
var room_positions := Dictionary()
var pause_mobs: bool = false

## Player Stuff
var encounter_enemies: Array[BattlerStats]
var player_characters: Array[BattlerStats]

var humans: Array[BattlerStats]
var infected: Array[BattlerStats]

## Inventory
var items: Array[ItemStats]
var keys: Array[String]

var events: Array[String] = ["START"]

func reset():
	items.clear()
	keys.clear()
	events.clear()
	
	humans.clear()
	infected.clear()
	
	encounter_enemies.clear()
	player_characters.clear()
	
	room_positions.clear()
	pause_mobs = false
	
	last_ID = 0
	
	
	last_player_pos = Vector2.ZERO
	
	interacted_array.clear()
	
	deadEnemies.clear()
	

func add_party_member(member_string_path: String) -> void:
	var member = ResourceLoader.load(member_string_path).duplicate()
	
	if member == null:
		return
	
	GameManager.player_characters.append(member)

func add_item(item_string_path: String) -> void:
	
	## Create a duplicate of an item to give player.
	var item = ResourceLoader.load(item_string_path).duplicate()
	
	if item == null:
		return
	
	GameManager.items.append(item)
	


# HANDLES DANGER LEVEL IE PLAYER TURNING
func danger_enough_fight(enemies: Array[BattlerStats]) -> bool:
	
	figure_out_infected()
	
	
	var fight_enemies: Array[BattlerStats] = infected + enemies
	
	
	var danger: bool = calculate_danger_level(humans, fight_enemies)
	return danger

## Calculate danger level in overworld. Return a true or false
func danger_enough_overworld() -> bool:
	
	## We find out infected. assign them to infected and human variables.
	figure_out_infected()
	
	## Get danger level on health, armor, etc. If more with infected, return true.
	var danger: bool = calculate_danger_level(humans, infected)
	return danger

func check_battle_inf():
	for i in player_characters:
		if i.will_infect == true:
			i.will_infect = false
			i.infected = true


## Go thru all players and see if they are all infected.
func if_all_infected():
	var all_inf: int = 0
	for i in player_characters:
		if i.infected == true:
			all_inf += 1
	
	if all_inf == player_characters.size():
		return true
	else:
		return false

## Go thru player characters and update the humans and infected.
func figure_out_infected():
	humans.clear()
	infected.clear()
	for i in player_characters:
		if i.infected:
			infected.append(i)
		else:
			humans.append(i)


## Go thru infected and remove them from players.
func clear_out_infected():
	var inf_1: BattlerStats
	var inf_2: BattlerStats
	
	
	
	figure_out_infected()
	
	if infected.size() >= 1:
		inf_1 = infected[0]
	if infected.size() >= 2:
		inf_2 = infected[1]
	
	
	for i in player_characters:
		
		if inf_2 != null:
			if i.character == inf_2.character:
				print("inf_2foudn1")
				
				## Remove infected from party
				player_characters.erase(i)
				
				if inf_2.Armor != null:
					items.erase(inf_2.Armor)
				if inf_2.Weapon != null:
					items.erase(inf_2.Weapon)
	
	for i in player_characters:
		if inf_1 != null:
			if i.character == inf_1.character:
				
				print("inf_1foudn1")
				
				## Remove infected from party
				player_characters.erase(i)
				
					## Same with gear
				if inf_1.Armor != null:
					items.erase(inf_1.Armor)
				if inf_1.Weapon != null:
					items.erase(inf_1.Weapon)
				
				
		
	
	
	
	print("Currently in party:", GameManager.player_characters)


## Get the danger level.
func calculate_danger_level(players: Array[BattlerStats], enemies: Array[BattlerStats]):
	
	## Its possible that there are no playercharacters that are infected. Do nothing
	if infected.is_empty():
		return false
	
	var human_level: int = 0
	var enemy_level: int = 0
	
	for i in players:
		human_level += i.current_hp
		human_level += i.damage
		human_level += i.armor
		human_level -= i.turn_speed
	
	for i in enemies:
		enemy_level += i.current_hp
		enemy_level += i.damage
		human_level += i.armor
		enemy_level -= i.turn_speed
		enemy_level += i.test_danger
	
	if enemy_level > human_level:
		return true
	else:
		return false

## Moved from player
func start_encounter(enemies):
	
	AudioManager.play_sfx(4)
	
	# This is needed to start encounter.
	encounter_enemies = enemies
	switch_Scene("res://TurnBased/turn_based_combat_scene.tscn", get_tree().current_scene.scene_file_path)

func _process(_delta):
	if Input.is_action_just_pressed("Escape"):
		get_tree().quit()

## PERSISTANCE ##

# add enemy to deadlist
func insert_dead_enemy(scene_name: String, mob_name: String) -> void:
	print(scene_name)
	if deadEnemies.has(scene_name):
		deadEnemies[scene_name].append(mob_name)
	else:
		deadEnemies[scene_name] = [mob_name]

# check if enemy in deadlist
func check_defeated_enemies(scene_name: String, mob_name: String) -> bool:
	print(scene_name)
	if deadEnemies.has(scene_name):
		return deadEnemies[scene_name].has(mob_name)
	return false

# ---

# HANDLES SCENE SWITCH


func change_room(next_scene: String, pos: Vector2, room_name: String):
	## Add a key to room. Room name and players pos at door.
	room_positions[room_name] = pos
	
	last_player_pos = Vector2.ZERO
	switch_Scene(next_scene, next_scene)
	


func _ready():
	
	var root = get_tree().root
	currentScene = root.get_child(root.get_child_count() - 1)

func switch_Scene(next_scene: String, this_scene: String):
	lastScene = this_scene
	call_deferred("_deferred_switch_scene", next_scene)
	


func _deferred_switch_scene(res_path):
	currentScene.free()
	last_ID = 0
	var s = load(res_path)
	currentScene = s.instantiate()
	get_tree().root.add_child(currentScene)
	get_tree().current_scene = currentScene

# ---

func return_to_overworld():
	call_deferred("_deferred_switch_scene", lastScene)
