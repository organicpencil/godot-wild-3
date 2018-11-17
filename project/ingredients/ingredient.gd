extends TextureButton

var mix_color
var ingredient_id
var active_mode = false

func _ready():
	assert(ingredient_id != null)
	
func _pressed():
	"""
	if active_mode:
		Global.emit_signal("remove_ingredient", ingredient_id)
		get_parent().remove_child(self)
		queue_free()
	else:
	"""
	if !active_mode:
		Global.emit_signal("add_ingredient", ingredient_id, mix_color)