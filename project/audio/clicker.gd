extends AudioStreamPlayer

# Instance this node as the child of a button. It will play a sound when the button is clicked.

func _ready():
	get_parent().connect("pressed", self, "handle_button_pressed")

func handle_button_pressed():
	play()
