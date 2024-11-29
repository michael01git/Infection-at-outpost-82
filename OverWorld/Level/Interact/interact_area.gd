extends Area2D

@onready var prompter: Control = get_tree().get_first_node_in_group("text_prompter")

## You can give a player an item trhu the multiline string arrays by typing an @res://resourcefilepath.tre
@export_multiline var text_on_interact: Array[String]
@export_multiline var already_interact: Array[String]
@export var queue_free_on_use: bool = false

## You can add stuff trhu the multiline string arrays by typing an MARKres://resourcefilepath.tre.  @ for item, £ for member, % for key, $ for events.
@export_category("Member Adding")
@export_multiline var can_fit_in_party_text: Array[String]
@export_multiline var cant_fit_in_party_text: Array[String]


func interact():
	print("interacted")
	
	if !prompter.prompts_empty:
		return
	
	## If has not interacted before.
	if !GameManager.interacted_array.has(get_parent().name+name):
		## Does not have.
		GameManager.interacted_array.append(get_parent().name+name)
		
		
		## If join party text exists.
		if cant_fit_in_party_text.size() != 0 or can_fit_in_party_text.size() != 0:
			member_text()
		else:
			prompter.prompt_array(text_on_interact)
		
		if queue_free_on_use:
			queue_free()
		
	
	## Has interacted before.
	else:
		
		
		prompter.prompt_array(already_interact)

func member_text():
	if GameManager.player_characters.size() >= 3:
		prompter.prompt_array(cant_fit_in_party_text)
	else:
		prompter.prompt_array(can_fit_in_party_text)
