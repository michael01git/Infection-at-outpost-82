extends Area2D

## NOTE
# Has to be a child of the room.


@onready var overworld_menu = $CanvasLayer/OverworldMenu
@onready var ray = $CollisionRaycast
@onready var interact_raycast = $InteractRaycast
@onready var point_light_2d = $PointLight2D

@onready var danger_level_timer = $DangerLevelTimer
@onready var move_timer = $MoveTimer

@onready var follower = $Follower1
@onready var follower_2 = $Follower2
@onready var follower_pos_array: Array[Vector2] = [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO]

@export var light: bool = true

@export_subgroup("Debug")
@export var pc: Array[String]
@export var inv: Array[String]
@export var events: Array[String]
@export var keys: Array[String]

@onready var icon = $Icon
@onready var follower_sprite = $Follower1/FollowerSprite
@onready var follower_sprite2 = $Follower2/FollowerSprite

var tile_size = 16
var inputs = {"right": Vector2.RIGHT, "left": Vector2.LEFT, "up": Vector2.UP, "down": Vector2.DOWN}

var animation_speed = 100
var moving = false

var target_pathfind_pos: Vector2


func _ready():
	
	
	
	## Show canvas.
	$CanvasLayer.show()
	
	## Start checking party infected
	danger_level_timer.start()
	
	## Debug
	#if GameManager.player_characters.is_empty():
	#	for i in pc:
	#		GameManager.add_party_member(i)
	#	for i in inv:
	#		GameManager.add_item(i)
	#	for i in events:
	#		GameManager.events.append(i)
	#	for i in keys:
	#		GameManager.keys.append(i)
	
	## Set infected after fight
	GameManager.check_battle_inf()
	
	## Room positions between rooms
	check_if_previously_in_room()
	
	## Play track 3 ambiance
	if GameManager.events.has("SLEPT"):
		AudioManager.play_music(3)
	
	## After fight
	if GameManager.last_player_pos != Vector2.ZERO:
		
		
		global_position = GameManager.last_player_pos
		GameManager.last_player_pos = Vector2.ZERO
		
		#global_position = global_position.snapped(Vector2.ONE * tile_size)
		#global_position += Vector2.ONE * tile_size/2
	
	if !light:
		point_light_2d.enabled = false
	
	## Handles sprites and overworld visible party size.
	change_follower_size()
	

func change_follower_size() -> void:
	
	## Fix pos clipping with followers after fight
	var new_array: Array[Vector2]
	for i in follower_pos_array.size():
		new_array.append(global_position)
	follower_pos_array.clear()
	follower_pos_array = new_array
	
	
	if GameManager.player_characters.size() == 1:
		follower.hide()
		follower.disabled = true
		
		follower_2.hide()
		follower_2.disabled = true
		
		
		icon.texture = GameManager.player_characters[0].overworld_sprite
		
	elif GameManager.player_characters.size() == 2:
		follower_2.hide()
		follower_2.disabled = true
		
		follower.show()
		follower.disabled = false
		
		icon.texture = GameManager.player_characters[0].overworld_sprite
		follower_sprite.texture = GameManager.player_characters[1].overworld_sprite
	elif GameManager.player_characters.size() == 3:
		follower.show()
		follower.disabled = false
		
		follower_2.show()
		follower_2.disabled = false
		
		icon.texture = GameManager.player_characters[0].overworld_sprite
		follower_sprite.texture = GameManager.player_characters[1].overworld_sprite
		follower_sprite2.texture = GameManager.player_characters[2].overworld_sprite


func check_if_previously_in_room():
	if GameManager.room_positions.has(get_parent().name):
		global_position = GameManager.room_positions[get_parent().name]
	else:
		return

func _unhandled_input(event):
	if GameManager.pause_mobs:
		danger_level_timer.stop()
		return
	
	if danger_level_timer.is_stopped():
		danger_level_timer.start()
	
	
	interact_raycast.target_position = ray.target_position
	
	if event.is_action_pressed("use"):
		if interact_raycast.is_colliding():
			AudioManager.play_sfx(4)
			var interactable = interact_raycast.get_collider()
			interactable.interact()
	
	if !overworld_menu.menu_open:
		if moving:
			return
		
		target_pathfind_pos = global_position
		
		
		for dir in inputs.keys():
			if event.is_action(dir):
				
				
				move(dir)
				
				## Just to give an indication on where player is looking.
				point_light_2d.global_position = interact_raycast.target_position + global_position

func move(dir):
	
	if !move_timer.is_stopped():
		return
	
	
	
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		
		follower_pos_array.remove_at(0)
		follower_pos_array.append(global_position)
		
		
		#position += inputs[dir] * tile_size
		var tween = create_tween()
		tween.tween_property(self, "position", position + inputs[dir] *    tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
		moving = true
		await tween.finished
		moving = false
		
		AudioManager.play_sfx(4)
		
		GameManager.last_player_pos = global_position
		
		follower.global_position = follower_pos_array[2]
		follower_2.global_position = follower_pos_array[1]
	
	
	move_timer.start()

## --- OVERWORLD INFECTION ---

## If infected players exist. Battle them.
func _on_danger_level_timer_timeout():
	## Every x time checks if the power level of infected players is enough. A test forces this to happen by adding an arbitary +1000 to this.
	
	## If every player is infected, do not start fight as this would break the game and code. Game over.
	if GameManager.if_all_infected():
		GameOver()
		return
	
	## If danger level is enough.
	elif GameManager.danger_enough_overworld():
		
		## Remove infected from party.
		GameManager.clear_out_infected()
		
		AudioManager.play_sfx(3)
		
		## Start an encounter with infected individuals.
		GameManager.start_encounter(GameManager.infected)

## Switch scene to game over.
func GameOver():
	GameManager.switch_Scene("res://OverWorld/MenuScenes/death_scene.tscn", "res://OverWorld/MenuScenes/death_scene.tscn")


## When hit enemy
func _on_area_entered(area):
	area.kill_enemy()
	
	if GameManager.if_all_infected():
		GameOver()
		return
	
	GameManager.start_encounter(area.encounter_enemies)
