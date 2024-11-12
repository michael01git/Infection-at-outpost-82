extends Control

@export var my_armor_button: Button
@export var my_weapon_button: Button
@export var my_character_button: Button

func _ready():
	my_armor_button.connect("pressed", on_armor_pressed)

func on_armor_pressed():
	pass
	## Spawn new boxes
	## Get info from them

## call from box
func change_armor_value():
	pass
