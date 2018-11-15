extends CheckButton

func _ready():
	connect("visibility_changed", self, "update_status")

func update_status():
	pressed = !AudioServer.is_bus_mute(0)
	
func _toggled(button_pressed):
	AudioServer.set_bus_mute(0, !AudioServer.is_bus_mute(0))