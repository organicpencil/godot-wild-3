extends Control

func _ready():
	var container = $PanelContainer/VBoxContainer
	var resume = container.get_node("Resume")
	var exit = container.get_node("Exit")
	
	resume.connect("pressed", self, "hide")
	$CloseButton.connect("pressed", self, "hide")
	exit.connect("pressed", self, "handle_exit_pressed")
	
func handle_exit_pressed():
	get_tree().change_scene("res://start.tscn")