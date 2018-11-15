extends Label

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "handle_animation_finished")
	$AnimationPlayer.play("fade")

func handle_animation_finished(animation):
	queue_free()

func _process(delta):
	rect_position += Vector2(0, 1)