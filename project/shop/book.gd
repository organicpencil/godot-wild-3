extends TextureRect

var current_page := 1
var active := false

func _ready():
	active = visible

	$AnimationPlayer.connect("animation_finished", self, "handle_animation_finished")
	$closeBtn.connect("pressed", self, "fade_out")
	$prevBtn.connect("pressed", self, "previous_page")
	$nextBtn.connect("pressed", self, "next_page")

	$prevBtn.hide()

func _unhandled_input(event):
	if event.is_action_pressed("next_page"):
		next_page()

	if event.is_action_pressed("previous_page"):
		previous_page()

func toggle():
	if active:
		fade_out()
	else:
		fade_in()

func handle_animation_finished(animation):
	# Lets you click stuff that was behind the book after it fades out
	visible = active

func fade_in():
	visible = true
	active = true
	$AnimationPlayer.play_backwards("fade")
	$Close.play()

func fade_out():
	active = false
	$AnimationPlayer.play("fade")#, -1, 1.5)
	$Open.play()

func previous_page():
	if current_page == 1: return

	get_node("page%d" % current_page).hide()
	current_page -= 1
	get_node("page%d" % current_page).show()

	$nextBtn.show()
	if current_page == 1: $prevBtn.hide()

	$PageFlip.play()

func next_page():
	if !has_node("page%d" % [current_page + 1]): return

	get_node("page%d" % current_page).hide()
	current_page += 1
	get_node("page%d" % current_page).show()

	$prevBtn.show()
	if !has_node("page%d" % [current_page + 1]): $nextBtn.hide()

	$PageFlip.play()
