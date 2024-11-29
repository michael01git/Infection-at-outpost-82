extends ColorRect

const amount_to_heal = preload("res://BattlerStats/Items/heal.tres").health
@onready var turn_cursor = $"../TurnActionButtons/TurnCursor"
@onready var use_cursor = $MenuCursor
@onready var turn_based_combat_scene = $"../.."
@onready var use_item_button = $"../TurnActionButtons/MarginContainer/TurnActions/UseItemButton"

var healing_items: bool = true

func wait_for_reset(node: Node):
	node.modulate = Color(0,0,0,0)
	await get_tree().create_timer(0.25).timeout
	node.modulate = Color(1,1,1,1)

func show_use_targets():
	await get_tree().create_timer(0.25).timeout
	use_cursor.process_mode = Node.PROCESS_MODE_INHERIT
	use_cursor.cursor_index = 0
	use_cursor.show()
	show()
	
	wait_for_reset(self)
	

func hide_use_targets():
	use_cursor.process_mode = Node.PROCESS_MODE_DISABLED
	
	use_cursor.hide()
	hide()
	

func _ready():
	turn_cursor.cursor_index = 0
	use_cursor.cursor_index = 0
	
	use_cursor.process_mode = Node.PROCESS_MODE_DISABLED
	if !check_if_heals():
		no_healing_more()

func check_if_heals() -> bool:
	if healing_items == false:
		return false
	
	var if_heal: bool = false
	
	for i in GameManager.items:
		if i.use_type == 0 and i.type == 0:
			if_heal = true
	
	return if_heal

func no_healing_more():
	if healing_items == false:
		return
	
	healing_items = false
	
	var call = Callable(turn_based_combat_scene, "show_use_buttons")
	use_item_button.disconnect("pressed", call)
	
	use_item_button.text = "No Healing Items"


func use_action(own_player: Node2D):
	own_player.stats_resource.current_hp += amount_to_heal
	own_player.stats_resource.cap_health()
	
	var deleted_item: bool = false
	for i in GameManager.items:
		if !deleted_item:
			if i.use_type == 0 and i.type == 0:
				deleted_item = true
				GameManager.items.erase(i)
	
	
	if !check_if_heals():
		no_healing_more()
	
	turn_based_combat_scene.hide_use_buttons()


func _on_exit_pressed():
	turn_based_combat_scene.hide_use_buttons()
