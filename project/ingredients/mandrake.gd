extends "res://ingredients/ingredient.gd"

const TEXTURE_SAD = preload("res://ingredients/mandrake.png")
const TEXTURE_SAD_HOVER = preload("res://ingredients/mandrake_hoover.png")

func _init():
	ingredient_id = Global.ING_MANDRAKE
	mix_color = Color(0, 1, 0, 1)

func handle_button_pressed():
	.handle_button_pressed()
	if !active_mode:
		$TextureButton.texture_normal = TEXTURE_SAD
		$TextureButton.texture_hover = TEXTURE_SAD_HOVER
