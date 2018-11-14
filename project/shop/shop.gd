extends Node

func _ready():
	$Control/NextOrder.connect("pressed", self, "handle_nextorder_pressed")
	$Control/BookButton.connect("pressed", self, "handle_bookbutton_pressed")
	$Timer.connect("timeout", self, "handle_timeout")
	
func handle_nextorder_pressed():
	assert($Timer.is_stopped())
	
	$Control/NextOrder.hide()
	
	var order = Orders.get_next_order()
	
	if !order:
		# Went through all orders. End the game or something
		$Control/ColorRect/Label.text = "Closing time!"
		return
		
	# Process the order
	$Control/ColorRect/Label.text = order['message']
	
	$Timer.wait_time = 30.0
	$Timer.start()
	
func handle_bookbutton_pressed():
	$Control/Book.toggle()
	
func handle_timeout():
	$Control/ColorRect/Label.text = "YOU HAVE FAILED TO DELIVER ON TIME"
	$Control/NextOrder.show()
	
func _process(delta):
	if !$Timer.is_stopped():
		var time_left = int($Timer.time_left)
		$Control/TimeLabel.text = "%d" % time_left
		if time_left > 9:
			$Control/TimeLabel.modulate = Color(0, 1, 0, 1)
		else:
			$Control/TimeLabel.modulate = Color(1, 0, 0, 1)