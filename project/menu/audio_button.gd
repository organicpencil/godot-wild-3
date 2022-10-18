extends TextureButton


func _ready():
	pressed = !AudioServer.is_bus_mute(0)

func _toggled(button_pressed: bool):
	AudioServer.set_bus_mute(0, !button_pressed)
