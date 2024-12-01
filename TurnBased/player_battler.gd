extends Node2D
# NOTE: This handles the individual players health, damage, speed, etc. The turnmanager connects to this to get info and pass that over to ex. enemies as damage.

@export var stats_resource: BattlerStats = null
@export var own_button: Label

@onready var hp_label = $RectW/RectB/HPLabel

@onready var hit_fx_player = $HitFXPlayer
@onready var damage_player = $DamagePlayer

@onready var turn_based_combat_scene = $"../.."
@onready var sprite_2d = $Sprite2D

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
	
	set_up_icon()
	
	update_health_bar()

func set_up_icon():
	sprite_2d.texture = stats_resource.battle_sprite

func update_health_bar() -> void:
	hp_label.text = str(stats_resource.current_hp)+" / "+str(stats_resource.max_hp)

func start_turn() -> void:
	
	
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
	hit_fx_player.play("RESET")
	damage_player.play("RESET")

func start_attacking(enemy_target: Node2D) -> void:
	play_attack_anim()
	await get_tree().create_timer(0.6).timeout
	enemy_target.play_hit_fx_anim()
	await get_tree().create_timer(0.5).timeout
	enemy_target.be_damaged(get_attack_damage())
	await get_tree().create_timer(0.1).timeout
	turn_ended.emit()

func play_attack_anim() -> void:
	hit_fx_player.play("play")

func get_attack_damage() -> int:
	return stats_resource.damage

func play_hit_fx_anim() -> void:
	damage_player.play("play")

func be_damaged(amount: int) -> void:
	AudioManager.play_sfx(1)
	
	var damage_dealt: int = amount - stats_resource.armor
	if damage_dealt < 0:
		damage_dealt = 0
	else:
		check_infection(damage_dealt)
	
	stats_resource.current_hp -= damage_dealt
	
	
	
	update_health_bar()
	if stats_resource.current_hp <= 0:
		stats_resource.current_hp = 0
		dead.emit(self)
		queue_free()

func check_infection(damage_dealt: int) -> void:
	var infection_resistance: int = randi_range(0, 10) + stats_resource.armor
	var random: int = randi_range(0, 10) + damage_dealt
	
	if random > infection_resistance:
		## Get infected
		if randi_range(0,1) == 1:
			## Last Chance
			stats_resource.will_infect = true
	
	
