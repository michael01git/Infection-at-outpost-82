extends Node
# NOTE: This handles passing data over to other enemies and players.

@onready var turn_action_buttons = $CanvasLayer/TurnActionButtons
@onready var attack_button = $CanvasLayer/TurnActionButtons/MarginContainer/TurnActions/AttackButton
#@onready var skip_turn_button = $CanvasLayer/TurnActionButtons/TurnActions/SkipTurnButton
@onready var use_item_button = $CanvasLayer/TurnActionButtons/MarginContainer/TurnActions/UseItemButton
@onready var heal_menu = $CanvasLayer/HealMenu

@onready var battle_end_panel = $CanvasLayer/BattleEndPanel
@onready var battle_end_label = $CanvasLayer/BattleEndPanel/BattleEndLabel

@onready var enemy_battle_organiser = $EnemyBattleOrganiser
@onready var player_battle_organizer = $PlayerBattleOrganizer

var all_battlers = []
var player_battlers = []
var enemy_battlers = []

var current_turn: Node2D
var current_turn_index: int

func _ready() -> void:
	
	
	# Organize enemies and players here, otherwise get deleted nodes.
	enemy_battle_organiser.organize()
	player_battle_organizer.organize()
	
	print(GameManager.encounter_enemies)
	print(GameManager.player_characters)
	
	# You have to wait a frame for non used battlers to be removed, otherwise it will be included in the get all nodes.
	await get_tree().process_frame
	
	
	turn_action_buttons.hide_TA()
	battle_end_panel.hide()
	
	player_battlers = get_tree().get_nodes_in_group("PlayerBattler")
	enemy_battlers = get_tree().get_nodes_in_group("EnemyBattler")
	all_battlers.append_array(player_battlers)
	all_battlers.append_array(enemy_battlers)
	
	all_battlers.sort_custom(sort_turn_order_ascending)
	
	## Used to exist. No more.
	#skip_turn_button.pressed.connect(next_turn)
	attack_button.pressed.connect(show_target_buttons)
	use_item_button.pressed.connect(show_use_buttons)
	
	for p in player_battlers:
		p.turn_ended.connect(next_turn)
		p.dead.connect(on_player_dead)
	
	for e in enemy_battlers:
		e.be_selected.connect(attack_selected_enemy)
		e.dead.connect(on_enemy_dead)
		e.deal_damage.connect(attack_random_player_battler)
	
	current_turn = all_battlers[current_turn_index]
	
	
	
	update_turn()

func sort_turn_order_ascending(battler_1, battler_2) -> bool:
	if battler_1.stats_resource.turn_speed < battler_2.stats_resource.turn_speed:
		return true
	return false

func update_turn() -> void:
	
	## If current turn holder is a player. Show turn action buttons.
	if current_turn.stats_resource.type == BattlerStats.BattlerType.PLAYER and !current_turn.stats_resource.infected:
		turn_action_buttons.show_TA()
	else:
		turn_action_buttons.hide_TA()
	
	current_turn.start_turn()

func next_turn() -> void:
	if turn_action_buttons.visible:
		turn_action_buttons.hide_TA()
	current_turn.stop_turn()
	if check_for_battle_end() == false:
		current_turn_index = (current_turn_index + 1) % all_battlers.size()
		current_turn = all_battlers[current_turn_index]
		update_turn()

## Show attackable targets.
func show_target_buttons() -> void:
	turn_action_buttons.hide_TA()
	
	turn_action_buttons.show_enemy_buttons(enemy_battlers)

func hide_target_buttons() -> void:
	turn_action_buttons.hide_enemy_buttons(enemy_battlers)

## Show heal targets
func show_use_buttons() -> void:
	turn_action_buttons.hide_TA()
	
	heal_menu.show_use_targets()

func hide_use_buttons() -> void:
	heal_menu.hide_use_targets()
	turn_action_buttons.show_TA()



func attack_selected_enemy(selected_enemy: Node2D) -> void:
	hide_target_buttons()
	current_turn.start_attacking(selected_enemy)

func attack_random_player_battler(damage: int) -> void:
	var rand = randi_range(0, player_battlers.size()-1)
	player_battlers[rand].play_hit_fx_anim()
	await get_tree().create_timer(0.5).timeout
	player_battlers[rand].be_damaged(damage)
	await get_tree().create_timer(0.1).timeout
	next_turn()

func on_enemy_dead(dead_enemy: Node2D) -> void:
	enemy_battlers.erase(dead_enemy)
	all_battlers.erase(dead_enemy)

func on_player_dead(dead_battler: Node2D) -> void:
	player_battlers.erase(dead_battler)
	all_battlers.erase(dead_battler)

func check_for_battle_end() -> bool:
	if enemy_battlers.is_empty():
		show_battle_end_panel("Player won!")
		return true
	elif player_battlers.is_empty():
		show_battle_end_panel("Player lost!")
		return true
	return false

func show_battle_end_panel(message: String) -> void:
	battle_end_label.text = ""
	battle_end_label.text = message
	battle_end_panel.show()
	if turn_action_buttons.visible:
		turn_action_buttons.hide_TA()
	
	await get_tree().create_timer(1).timeout
	if enemy_battlers.is_empty():
		GameManager.return_to_overworld()
	else:
		GameManager.GameOver()


func start_encounter():
	var enemies: Array[BattlerStats] = GameManager.infected
	GameManager.clear_out_infected()
	
	for i in enemy_battlers:
		enemies.append(i.stats_resource)
	
	
	
	GameManager.encounter_enemies = enemies
	GameManager.switch_Scene("res://TurnBased/turn_based_combat_scene.tscn", GameManager.lastScene)
