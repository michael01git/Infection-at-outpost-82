extends CharacterBody2D

const SPEED = 300.0

func _ready():
	global_position = GameManager.last_player_pos

func _physics_process(delta):
	var dir: Vector2 = input()
	velocity = dir * SPEED
	move_and_slide()

func input() -> Vector2:
	var direction = Input.get_vector("left", "right", "up", "down")
	if Input.is_action_pressed("right") || Input.is_action_pressed("left"):
		direction.y = 0
	elif Input.is_action_pressed("up") || Input.is_action_pressed("down"):
		direction.x = 0
	else:
		direction = Vector2.ZERO
	
	direction = direction.normalized()
	return direction

func start_encounter():
	GameManager.last_player_pos = global_position
	GameManager.switch_Scene("res://TurnBased/turn_based_combat_scene.tscn", get_tree().current_scene.scene_file_path)
