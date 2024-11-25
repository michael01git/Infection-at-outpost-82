extends Area2D

## NOTE
# Has to be a child of the room.

@onready var player := get_tree().get_first_node_in_group("Player")
@export var next_scene: String

func _ready():
	$Icon.hide()

func interact():
	GameManager.change_room(next_scene, player.global_position, get_parent().name)
