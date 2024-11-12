extends Resource
class_name ItemStats

enum ItemType{
	USE,
	ARMOR,
	WEAPON
}

enum StatImprove{
	HEALTH,
	DEFENSE,
	DAMAGE
}

var equipped: bool = false

@export_category("Item Type")
## What type of item this is. Useable items are consumed, Equiable are permanent.
@export var type: ItemType

@export_category("Name")
## Name of item.
@export var item_name: String

@export_category("Stat Improvement")
@export var stat_improve: StatImprove
@export var amount: int

@export_category("Uses")
@export var is_permanent: bool
@export var uses: int
