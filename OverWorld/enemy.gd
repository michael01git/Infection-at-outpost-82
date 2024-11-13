extends Area2D

@export var encounter_enemies: Array[BattlerStats]
@onready var player: Area2D = get_tree().get_first_node_in_group("Player")
@onready var tilemap: TileMapLayer = get_tree().get_first_node_in_group("tilemap")
@onready var look_raycast = $LookRaycast

var current_path: Array[Vector2i]
var target_position: Vector2

var ID: int
const time_to_move: float = 1.00
var time_now: float = 0

var look_for_player_state: bool = false

func _physics_process(delta):
	if look_for_player_state:
		follow_enemy(delta)
	else:
		wander(delta)

func wander(delta):
	
	
	
	
	
	time_now += delta
	
	if time_now > time_to_move:
		
		
		var target: Vector2
		
		match randi_range(0,4):
			0:
				target = Vector2.ZERO
				
			1:
				target = Vector2.UP
				look_raycast.look_at(global_position+target)
			2:
				target = Vector2.RIGHT
				look_raycast.look_at(global_position+target)
			3:
				target = Vector2.DOWN
				look_raycast.look_at(global_position+target)
			4:
				target = Vector2.LEFT
				look_raycast.look_at(global_position+target)
		
		if target != Vector2.ZERO:
			walk(target)
			
		
		
		
		
		
		time_now = 0
	
	if look_raycast.is_colliding() and look_raycast.get_collider() == player:
		print(look_raycast.get_collider())
		look_for_player_state = true

func follow_enemy(delta):
	time_now += delta
	if time_now > time_to_move:
		walk(player.global_position)
		time_now = 0
		
		

func walk(pos: Vector2):
	
	var move_pos = pos
	
	if tilemap.is_point_walkable(move_pos):
		print("a")
		current_path = tilemap.astar.get_id_path(
			tilemap.local_to_map(global_position), 
			tilemap.local_to_map(move_pos)
		).slice(1)
		
		target_position = tilemap.map_to_local(current_path.front())
		global_position = target_position
		
		current_path.pop_front()
		


func _ready():
	if GameManager.check_defeated_enemies(get_parent().name, ID):
		queue_free()
	
	GameManager.get_ID(self)

func kill_enemy():
	GameManager.insert_dead_enemy(get_parent().name, ID)
