extends Resource
class_name BattlerStats

enum Character{
	ENEMY,
	JOHN,
	MCCREADY,
	WINDOWS
}

enum BattlerType{
	PLAYER,
	ENEMY
}

@export_category("Type And Infection")
## If statistics belong to an enemy or a player.
@export var type: BattlerType
## If player character is infected.
@export var infected: bool

@export_category("Name")
## Name that is show for statistics.
@export var character: String

@export_category("HP")
@export var max_hp: int
## Stuff is stupid and a resource doesnt process anything itself, so manually replace the current hp.
@export var current_hp: int

@export_category("Damage")
@export var damage: int

@export_category("Armor")
@export var armor: int

@export_category("Speed")
@export var turn_speed: int

## Weapons
var Armor: ItemStats
var Weapon: ItemStats
