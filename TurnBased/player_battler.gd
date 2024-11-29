extends Node2D
# NOTE: This handles the individual players health, damage, speed, etc. The turnmanager connects to this to get info and pass that over to ex. enemies as damage.

@export var stats_resource: BattlerStats = null
@export var own_button: Label

@onready var health_bar = $HealthBar
@onready var turn_indicator_animation = $TurnIndicator/TurnIndicatorAnimation
@onready var animation_player = $AnimationPlayer
@onready var hit_fx_animation = $HitFX/HitFXAnimation
@onready var turn_based_combat_scene = $"../.."

# NOTE: Character health is handled in its statistics.

signal dead(this_battler: Node2D)
signal turn_ended

func check_deletion():
	if stats_resource == null:
		own_button.queue_free()
		queue_free()

func ready():
	
	stop_turn()
	
	own_button.set_up(self)
	
	update_health_bar()


func update_health_bar() -> void:
	health_bar.max_value = stats_resource.max_hp
	health_bar.value = stats_resource.current_hp

func start_turn() -> void:
	
	turn_indicator_animation.play("in_turn")
	
	## If infected, check if turn.
	if stats_resource.infected != true:
		return
	
	var enemies: Array[BattlerStats]
	## Get enemies for encounter check
	for i in turn_based_combat_scene.enemy_battlers:
		enemies.append(i.stats_resource)
	
	## Encounter check.
	if GameManager.danger_enough_fight(enemies):
		
		AudioManager.play_sfx(3)
		turn_based_combat_scene.start_encounter()


func stop_turn() -> void:
	turn_indicator_animation.play("RESET")
	animation_player.play("RESET")
	hit_fx_animation.play("RESET")

func start_attacking(enemy_target: Node2D) -> void:
	play_attack_anim()
	await get_tree().create_timer(0.6).timeout
	enemy_target.play_hit_fx_anim()
	await get_tree().create_timer(0.5).timeout
	enemy_target.be_damaged(get_attack_damage())
	await get_tree().create_timer(0.1).timeout
	turn_ended.emit()

func play_attack_anim() -> void:
	animation_player.play("attack")

func get_attack_damage() -> int:
	return stats_resource.damage

func play_hit_fx_anim() -> void:
	hit_fx_animation.play("play")

func be_damaged(amount: int) -> void:
	AudioManager.play_sfx(1)
	
	var damage_dealt: int = amount - stats_resource.armor
	if damage_dealt < 0:
		damage_dealt = 0
	
	stats_resource.current_hp -= damage_dealt
	
	check_infection()
	
	update_health_bar()
	if stats_resource.current_hp <= 0:
		stats_resource.current_hp = 0
		dead.emit(self)
		queue_free()

func check_infection() -> void:
	var infection_resistance: int = randi_range(0, 10) + stats_resource.armor
	var random: int = randi_range(0, 10)
	if random > infection_resistance:
		## Get infected
		if randi_range(0,1) == 1:
			## Last Chance
			stats_resource.will_infect = true
	
	
