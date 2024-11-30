extends CanvasModulate

@export var modulat: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if modulat:
		show()
