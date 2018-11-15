extends Node

const Witch = preload("res://shop/witch.tscn")

func _ready():
	$Menu/Begin.connect("pressed", self, "start_game")
	$Menu/Exit.connect("pressed", get_tree(), "quit")
	
func start_game():
	$Menu.hide()
	Global.emit_signal("start_game")
	$Menu/Begin/AudioStreamPlayer.play()