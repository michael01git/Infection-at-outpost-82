extends Control

@onready var inventory_view = $"../Menu/MarginContainerInvFull/InventoryView"

func _on_armor_1_pressed():
	pressed("armor", 1)


func _on_inventory_pressed():
	pressed("inventory", 0)

func pressed(type: String, number: int):
	inventory_view.button_pressed(type, number)


func _on_weapon_1_pressed():
	pressed("weapon", 1)

func _on_use_1_pressed():
	pressed("use", 1)
