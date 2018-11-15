extends Node

var orders

func _ready():
	orders = preload("res://orders.gd").new()
	
	$NextOrder.connect("pressed", self, "handle_nextorder_pressed")
	$BookButton.connect("pressed", self, "handle_bookbutton_pressed")
	$Timer.connect("timeout", self, "handle_timeout")
	
func _input(event):
	if event.is_action_pressed("escape"):
		$EscapeMenu.visible = !$EscapeMenu.visible
		
func handle_nextorder_pressed():
	assert($Timer.is_stopped())
	
	$NextOrder.hide()
	
	var order = orders.get_next_order()
	
	if !order:
		# Went through all orders. End the game or something
		$ColorRect/Label.text = "Closing time!"
		return
		
	# Process the order
	$ColorRect/Label.text = order['message']
	
	$Timer.wait_time = 30.0
	$Timer.start()
	
func handle_bookbutton_pressed():
	$Book.toggle()
	
func handle_timeout():
	$ColorRect/Label.text = "YOU HAVE FAILED TO DELIVER ON TIME"
	$NextOrder.show()
	
func _process(delta):
	if !$Timer.is_stopped():
		var time_left = int($Timer.time_left)
		$TimeLabel.text = "%d" % time_left
		if time_left > 9:
			$TimeLabel.modulate = Color(0, 1, 0, 1)
		else:
			$TimeLabel.modulate = Color(1, 0, 0, 1)