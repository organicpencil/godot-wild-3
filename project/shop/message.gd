extends Control

var speed = 1.0

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "handle_animation_finished")
	$AnimationPlayer.play("message_fade", -1, speed)

func handle_animation_finished(animation):
	queue_free()

func _process(delta):
	rect_position += Vector2(0, 1)