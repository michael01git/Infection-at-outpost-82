extends Control

@onready var text = $Panel/Text

@onready var animation_player = $AnimationPlayer

var show_percentage: float = 0
var finished_showing: bool = true

var prompts_array: Array[String]


func prompt_array(array: Array[String]) -> void:
	prompts_array += array
	


func process_prompts_array():
	
	
	if !prompts_array.is_empty():
		if finished_showing:
			var first_prompt = prompts_array[0]
			
			if first_prompt[0] == "@":
				GameManager.add_item(first_prompt.erase(0))
				prompts_array.remove_at(0)
			else:
				prompt(first_prompt)

## Get Shown percentage from timer.
func _process(delta):
	process_prompts_array()
	
	if Input.is_action_just_pressed("use"):
		if animation_player.current_animation != "wait":
			animation_player.play("wait")

## Show text
func prompt(text_to_add: String) -> void:
	show()
	finished_showing = false
	
	text.text = ""
	text.text += text_to_add 
	animation_player.play("show_text")

## Show new text.
func change_text():
	hide()
	text.text = ""
	prompts_array.remove_at(0)
	finished_showing = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "wait":
		change_text()
	else:
		animation_player.play("wait")
