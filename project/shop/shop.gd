extends Control

var orders
var current_order = null

func _ready():
	orders = preload("res://orders.gd").new()
	
	Global.connect("start_game", self, "handle_start_game")
	
	$NextOrder.connect("pressed", self, "handle_nextorder_pressed")
	$BrewButton.connect("pressed", self, "handle_brew_pressed")
	$BookButton.connect("pressed", self, "handle_bookbutton_pressed")
	$Timer.connect("timeout", self, "handle_timeout")
	
	set_process_input(false)
	
func _input(event):
	if event.is_action_pressed("escape"):
		$EscapeMenu.visible = !$EscapeMenu.visible
		
func handle_start_game():
	show()
	set_process_input(true)
	Global.connect("add_ingredient", self, "handle_add_ingredient")
	Global.connect("remove_ingredient", self, "handle_remove_ingredient")
	
func handle_add_ingredient(ingredient_id):
	# Active order required before you can start mixing
	if !current_order:
		return
		
	# Make sure we don't already have this ingredient in the cauldron
	for child in $ActiveIngredients.get_children():
		if child.ingredient_id == ingredient_id:
			return
	
	var node
	match ingredient_id:
		Global.ING_DANDELION: node = preload("res://ingredients/dandelion.tscn").instance()
		Global.ING_FEATHER: node = preload("res://ingredients/feather.tscn").instance()
		Global.ING_MANDRAKE: node = preload("res://ingredients/mandrake.tscn").instance()
		Global.ING_MUSHROOM: node = preload("res://ingredients/mushroom.tscn").instance()
		Global.ING_SUNFLOWERSEED: node = preload("res://ingredients/sunflower_seed.tscn").instance()
		
	node.active_mode = true
	$ActiveIngredients.add_child(node)
	$BrewButton.show()
	
func handle_remove_ingredient(ingredient_id):
	if $ActiveIngredients.get_child_count() == 0:
		$BrewButton.hide()
	
func handle_nextorder_pressed():
	assert($Timer.is_stopped())
	
	$NextOrder.hide()
	
	current_order = orders.get_next_order()
	
	if !current_order:
		# Went through all orders. End the game or something
		$ColorRect/Label.text = "Closing time!"
		return
		
	# Process the order
	$ColorRect/Label.text = current_order['message']
	
	$Timer.wait_time = 30.0
	$Timer.start()
	
func handle_brew_pressed():
	var score = 0
	for node in $ActiveIngredients.get_children():
		if node.ingredient_id in current_order['ingredients']:
			score += 1
		else:
			score -= 1
			
		node.queue_free()
		
	$BrewButton.hide()
	
	if score == current_order['ingredients'].size():
		# Good potion
		$Timer.stop()
		$NextOrder.show()
		$ColorRect/Label.text = 'Good job! Hit "Next Order" when you\'re ready for another.'
	else:
		# Bad potion
		var message = preload("res://shop/message.tscn").instance()
		message.text = "The duck is not pleased. Try again."
		add_child(message)
	
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