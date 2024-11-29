extends Node2D

@export var stats_resource: BattlerStats = null

@export var own_button: Label

@onready var health_bar = $HealthBar
@onready var turn_indicator_animation = $TurnIndicator/TurnIndicatorAnimation
@onready var animation_player = $AnimationPlayer
@onready var hit_fx_animation = $HitFX/HitFXAnimation



signal be_selected(this_target: Node2D)
signal dead(this_enemy: Node2D)
signal deal_damage(damage: int)

func check_deletion():
	if stats_resource == null:
		own_button.queue_free()
		queue_free()

func ready():
	
	
	stop_turn()
	
	
	
	
	
	own_button.set_up(stats_resource.character)
	update_health_bar()

func update_health_bar() -> void:
	health_bar.max_value = stats_resource.max_hp
	health_bar.value = stats_resource.current_hp

func start_turn() -> void:
	turn_indicator_animation.play("in_turn")
	play_attack_anim()
	await get_tree().create_timer(0.6).timeout
	deal_damage.emit(get_attack_damage())

func stop_turn() -> void:
	turn_indicator_animation.play("RESET")
	animation_player.play("RESET")
	hit_fx_animation.play("RESET")

func on_select_button_pressed() -> void:
	be_selected.emit(self)

func play_attack_anim() -> void:
	animation_player.play("attack")

func get_attack_damage() -> int:
	return stats_resource.damage

func play_hit_fx_anim() -> void:
	hit_fx_animation.play("play")

func be_damaged(amount: int) -> void:
	AudioManager.play_sfx(1)
	
	stats_resource.current_hp -= amount
	update_health_bar()
	if stats_resource.current_hp <= 0:
		stats_resource.current_hp = 0
		dead.emit(self)
		own_button.queue_free()
		queue_free()
