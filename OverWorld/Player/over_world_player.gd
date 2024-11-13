extends Area2D

@onready var overworld_menu = $CanvasLayer/OverworldMenu
@onready var ray = $CollisionRaycast
@onready var interact_raycast = $InteractRaycast

@export var pc: Array[BattlerStats]
@export var inv: Array[ItemStats]

var tile_size = 16
var inputs = {"right": Vector2.RIGHT, "left": Vector2.LEFT, "up": Vector2.UP, "down": Vector2.DOWN}

var animation_speed = 10
var moving = false

var target_pathfind_pos: Vector2

func _ready():
	GameManager.player_characters = pc
	GameManager.armor_items = inv
	GameManager.weapon_items = inv
	
	
	
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	
	
	position = GameManager.last_player_pos


func _unhandled_input(event):
	interact_raycast.target_position = ray.target_position
	if event.is_action_pressed("use"):
		if interact_raycast.is_colliding():
			var interactable = interact_raycast.get_collider()
			interactable.interact()
	
	if !overworld_menu.menu_open:
		if moving:
			return
		
		target_pathfind_pos = global_position
		
		
		for dir in inputs.keys():
			if event.is_action_pressed(dir):
				GameManager.last_player_pos = position
				move(dir)

func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		#position += inputs[dir] * tile_size
		var tween = create_tween()
		tween.tween_property(self, "position", position + inputs[dir] *    tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
		moving = true
		await tween.finished
		moving = false
		
		

func start_encounter(enemies):
	
	
	# This is needed to start encounter.
	GameManager.encounter_enemies = enemies
	GameManager.switch_Scene("res://TurnBased/turn_based_combat_scene.tscn", get_tree().current_scene.scene_file_path)

func _on_area_entered(area):
	area.kill_enemy()
	start_encounter(area.encounter_enemies)
