extends Node

func _ready():
	# Deferred rather than autoloaded, prevents music from playing during the initial load
	call_deferred("add_music_player")
	
func add_music_player():
	add_child(load("res://music_player.tscn").instance())

func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen