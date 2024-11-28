extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func show_keys():
	text = ""
	
	for i in GameManager.keys:
		text += i+" "
