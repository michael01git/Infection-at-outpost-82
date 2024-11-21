extends Area2D

@onready var prompter: Control = get_tree().get_first_node_in_group("text_prompter")

## You can give a player an item trhu the multiline string arrays by typing an @res://resourcefilepath.tre
@export_multiline var text_on_interact: Array[String]

var interacted: bool = false

func interact():
	if !prompter.finished_showing:
		return
	
	if !interacted:
		interacted = true
		prompter.prompt_array(text_on_interact)
	
