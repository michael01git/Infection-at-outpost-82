extends Area2D

## NOTE
# Has to be a child of the room.
@onready var prompter: Control = get_tree().get_first_node_in_group("text_prompter")

@onready var player := get_tree().get_first_node_in_group("Player")
@export var next_scene: String
@export var need_key: String
@export_multiline var no_key_prompt: Array[String]

func _ready():
	$Icon.hide()

func interact():
	if need_key.is_empty() or GameManager.keys.has(need_key):
		GameManager.change_room(next_scene, player.global_position, get_parent().name)
	else:
		if prompter.prompts_empty:
			prompter.prompt_array(no_key_prompt)
