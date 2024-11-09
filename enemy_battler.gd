extends Node2D

@export var stats_resource: BattlerStats

@onready var health_bar = $HealthBar
@onready var turn_indicator_animation = $TurnIndicator/TurnIndicatorAnimation
@onready var select_target_button = $SelectTargetButton
@onready var animation_player = $AnimationPlayer
@onready var hit_fx_animation = $HitFX/HitFXAnimation

var current_hp: int

signal be_selected(this_target: Node2D)
signal dead(this_enemy: Node2D)
signal deal_damage(damage: int)

func _ready():
	select_target_button.hide()
	stop_turn()
	
	current_hp = stats_resource.max_hp
	
	select_target_button.pressed.connect(on_select_button_pressed)
	
	update_health_bar()

func update_health_bar() -> void:
	health_bar.max_value = stats_resource.max_hp
	health_bar.value = current_hp

func start_turn() -> void:
	turn_indicator_animation.play("in_turn")
	play_attack_anim()
	await get_tree().create_timer(0.6).timeout
	deal_damage.emit(get_attack_damage())

func stop_turn() -> void:
	turn_indicator_animation.play("RESET")
	animation_player.play("RESET")
	hit_fx_animation.play("RESET")


func show_select_button() -> void:
	select_target_button.show()

func hide_select_button() -> void:
	select_target_button.hide()

func on_select_button_pressed() -> void:
	be_selected.emit(self)

func play_attack_anim() -> void:
	animation_player.play("attack")

func get_attack_damage() -> int:
	return randi_range(stats_resource.min_damage, stats_resource.max_damage)

func play_hit_fx_anim() -> void:
	hit_fx_animation.play("play")

func be_damaged(amount: int) -> void:
	current_hp -= amount
	update_health_bar()
	if current_hp <= 0:
		current_hp = 0
		dead.emit(self)
		queue_free()
