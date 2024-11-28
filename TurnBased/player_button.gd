extends Label

@onready var heal_menu = $"../../.."
var own_player: Node2D

func cursor_select() -> void:
	heal_menu.use_action(own_player)

func set_up(node: Node2D) -> void:
	own_player = node
	text = own_player.stats_resource.character
