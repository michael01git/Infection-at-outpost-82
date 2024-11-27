extends Resource
class_name ItemStats

enum ItemType{
	USE,
	ARMOR,
	WEAPON
}

# Need?
enum StatImprove{
	HEALTH,
	DEFENSE,
	DAMAGE
}

enum UseType{
	HEAL,
	DAMAGE,
	TEST
}

var equipped_by: String = "NULL"

@export_category("Item Type")
## What type of item this is. Useable items are consumed, Equiable are permanent.
@export var type: ItemType
@export var use_type: UseType

@export_category("Name")
## Name of item.
@export var item_name: String

@export_category("Stat Improvement")
@export var damage: int
@export var armor: int
@export var turn_speed: int
@export var health: int
