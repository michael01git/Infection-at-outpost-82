extends Node

## Scene Stuff
var last_ID: int = 0

var lastScene = null
var currentScene = null

var last_player_pos: Vector2 = Vector2(8, 8)

var deadEnemies := Dictionary()

var next_room_position: Vector2

## Player Stuff
var encounter_enemies: Array[BattlerStats]
var player_characters: Array[BattlerStats]

var infected_players: BattlerStats = load("res://BattlerStats/enemy_battler_1.tres")

## Inventory
var items: Array[ItemStats]


func _process(delta):
	print(player_characters[0].damage)
	
	if Input.is_action_just_pressed("Escape"):
		get_tree().quit()

# set enemy id
func get_ID(enemy):
	enemy.ID = last_ID
	
	last_ID += 1

# add enemy to deadlist
func insert_dead_enemy(scene_name: String, ID: int) -> void:
	print(scene_name)
	if deadEnemies.has(scene_name):
		deadEnemies[scene_name].append(ID)
	else:
		deadEnemies[scene_name] = [ID]

# check if enemy in deadlist
func check_defeated_enemies(scene_name: String, ID: int) -> bool:
	print(scene_name)
	if deadEnemies.has(scene_name):
		return deadEnemies[scene_name].has(ID)
	return false

# ---

# HANDLES SCENE SWITCH



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
