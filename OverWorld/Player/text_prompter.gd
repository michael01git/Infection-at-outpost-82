extends Control

@onready var player = get_tree().get_first_node_in_group("Player")

@onready var text = $Panel/Text
@onready var color_rect = $ColorRect
@onready var use_timer = $UseTimer

var prompts_array: Array[String]

var prompts_empty: bool = true

var process_next: bool = true

var can_use: bool = false



func prompt_array(array: Array[String]) -> void:
	## Get an array of propmts to process
	
	
	GameManager.pause_mobs = true
	
	## Show screen
	color_rect.show()
	
	
	var arr = array
	arr.append("FINALPROMPT")
	prompts_array += arr
	
	prompts_empty = false
	
	use_timer.start()


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
		
		elif first_prompt[0] == "$":
			if !GameManager.events.has(first_prompt.erase(0)):
				GameManager.events.append(first_prompt.erase(0))
			change_text()
		
		else:
			prompt(first_prompt)
	
	

func end_prompts():
	prompts_empty = true
	process_next = true
	GameManager.pause_mobs = false
	use_timer.stop()
	color_rect.hide()
	hide()


## Get Shown percentage from timer.
func _process(delta):
	print(prompts_empty, process_next)
	
	
	
	
	
	## Go thru propmts array and show them.
	process_prompts_array()
	
	
	if Input.is_action_just_pressed("use") and can_use:
		can_use = false
		AudioManager.play_sfx(4)
		use_timer.start()
		change_text()

## Show text
func prompt(text_to_add: String) -> void:
	show()
	
	
	
	
	text.text = ""
	text.text += text_to_add

## Show new text.
func change_text():
	text.text = ""
	
	if !prompts_empty:
		prompts_array.remove_at(0)
	
	# Can process next prompt
	process_next = true

func _on_use_timer_timeout():
	can_use = true
