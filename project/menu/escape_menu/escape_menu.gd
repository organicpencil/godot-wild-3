extends Control

export(NodePath) var book # Hide the book when paused

var book_was_active := false

func _ready():
	book = get_node(book)
	assert(book)
	connect("visibility_changed", self, "_visibility_changed")

func _input(event):
	if event.is_action_pressed("escape"):
		visible = !visible

func _visibility_changed():
	# Call this via signal because outside nodes can change the visibility
	get_tree().paused = visible

	if visible:
		book_was_active = book.active
		if book_was_active:
			book.fade_out()
	else:
		if book_was_active:
			book.fade_in()
