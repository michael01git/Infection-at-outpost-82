extends Node2D

@export var stats_resource: BattlerStats = null

@export var own_button: Label

@onready var hp_label = $RectW/RectB/HPLabel

@onready var attack_animation = $AttackAnimation
@onready var hit_animation = $HitAnimation

@onready var sprite_2d = $Sprite2D



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
	
	set_up_icon()
	
	
	update_health_bar()

func set_up_icon():
	sprite_2d.texture = stats_resource.enemy_battle_sprite

func update_health_bar() -> void:
	hp_label.text = str(stats_resource.current_hp)+" / "+str(stats_resource.max_hp)

func start_turn() -> void:
	
	play_attack_anim()
	await get_tree().create_timer(0.6).timeout
	deal_damage.emit(get_attack_damage())

func stop_turn() -> void:
	
	attack_animation.play("RESET")
	hit_animation.play("RESET")

func on_select_button_pressed() -> void:
	be_selected.emit(self)

func play_attack_anim() -> void:
	attack_animation.play("attack")

func get_attack_damage() -> int:
	return stats_resource.damage

func play_hit_fx_anim() -> void:
	hit_animation.play("hit")

func be_damaged(amount: int) -> void:
	AudioManager.play_sfx(1)
	
	stats_resource.current_hp -= amount
	
	update_health_bar()
	if stats_resource.current_hp <= 0:
		stats_resource.current_hp = 0
		dead.emit(self)
		own_button.queue_free()
		queue_free()
