extends Control

@onready var inventory_view = $"../Menu/MarginContainerInvFull/InventoryView"

func pressed(type: String, number: int):
	if GameManager.player_characters.size() < number:
		return
	
	inventory_view.button_pressed(type, number)
	

func _on_armor_1_pressed():
	pressed("armor", 1)

func _on_armor_2_pressed():
	pressed("armor", 2)

func _on_armor_3_pressed():
	pressed("armor", 3)

func _on_weapon_1_pressed():
	pressed("weapon", 1)

func _on_weapon_2_pressed():
	pressed("weapon", 2)

func _on_weapon_3_pressed():
	pressed("weapon", 3)


func _on_use_1_pressed():
	pressed("use", 1)

func _on_use_2_pressed():
	pressed("use", 2)

func _on_use_3_pressed():
	pressed("use", 3)


func _on_inventory_pressed():
	pressed("inventory", 0)
