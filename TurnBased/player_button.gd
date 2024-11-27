extends Label

var own_player: Node2D

func cursor_select() -> void:
	pass
	
	## Close menu and add health if player has healing items.
	# Also exit button.

func set_up(node: Node2D) -> void:
	own_player = node
	text = own_player.stats_resource.character
