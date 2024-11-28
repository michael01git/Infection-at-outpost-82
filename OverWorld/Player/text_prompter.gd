extends Control

@onready var player = get_tree().get_first_node_in_group("Player")

@onready var text = $Panel/Text
@onready var color_rect = $ColorRect

@onready var animation_player = $AnimationPlayer

var show_percentage: float = 0

var prompts_array: Array[String]

var prompts_empty: bool = true

var process_next: bool = true

func prompt_array(array: Array[String]) -> void:
	## Get an array of propmts to process
	
	
	GameManager.pause_mobs = true
	
	## Show screen
	color_rect.show()
	
	
	var arr = array
	arr.append("FINALPROMPT")
	prompts_array += arr
	
	prompts_empty = false
	


func process_prompts_array():
	if prompts_empty:
		return
	
	if process_next:
		process_next = false
		
		var first_prompt = prompts_array[0]
		
		# If prompt is final, leave propmts screen.
		if first_prompt == "FINALPROMPT":
			text.text = ""
			prompts_array.remove_at(0)
			end_prompts()
		
		# If prompt includes this character, add an item.
		elif first_prompt[0] == "@":
			GameManager.add_item(first_prompt.erase(0))
			change_text()
			
		
		elif first_prompt[0] == "£":
			GameManager.add_party_member(first_prompt.erase(0))
			change_text()
			player.change_follower_size()
		
		elif first_prompt[0] == "%":
			if !GameManager.keys.has(first_prompt.erase(0)):
				GameManager.keys.append(first_prompt.erase(0))
			change_text()
			
		
		else:
			prompt(first_prompt)
	
	

func end_prompts():
	prompts_empty = true
	process_next = true
	GameManager.pause_mobs = false
	color_rect.hide()
	hide()


## Get Shown percentage from timer.
func _process(delta):
	print(prompts_empty, process_next)
	
	
	
	
	
	## Go thru propmts array and show them.
	process_prompts_array()
	
	
	return
	if Input.is_action_just_pressed("use"):
		if animation_player.current_animation != "wait":
			animation_player.play("wait")

## Show text
func prompt(text_to_add: String) -> void:
	show()
	
	text.text = ""
	text.text += text_to_add 
	animation_player.play("show_text")

## Show new text.
func change_text():
	text.text = ""
	
	if !prompts_empty:
		prompts_array.remove_at(0)
	
	# Can process next prompt
	process_next = true


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "wait":
		change_text()
	else:
		animation_player.play("wait")
