extends TextureButton


func _pressed():
	get_tree().paused = false
	get_tree().change_scene("res://start.tscn")
