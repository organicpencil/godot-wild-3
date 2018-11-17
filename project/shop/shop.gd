extends Control

export(NodePath) var potion_sprite

var orders
var current_order = null

var satisifed_customers = 0
var ingredients_wasted = 0

func _ready():
	potion_sprite = get_node(potion_sprite)
	orders = preload("res://orders.gd").new()
	
	Global.connect("start_game", self, "handle_start_game")
	
	$NextOrder.connect("pressed", self, "handle_nextorder_pressed")
	$BrewButton.connect("pressed", self, "handle_brew_pressed")
	$BookButton.connect("pressed", self, "handle_bookbutton_pressed")
	$Timer.connect("timeout", self, "handle_timeout")
	$MenuButton.connect("pressed", self, "handle_exit_pressed")
	
	set_process_input(false)
	
func _input(event):
	if event.is_action_pressed("escape"):
		$EscapeMenu.visible = !$EscapeMenu.visible
		
func handle_start_game():
	show()
	set_process_input(true)
	Global.connect("add_ingredient", self, "handle_add_ingredient")
	Global.connect("remove_ingredient", self, "handle_remove_ingredient")
	
func handle_exit_pressed():
	get_tree().change_scene("res://start.tscn")
	
func handle_add_ingredient(ingredient_id, mix_color):
	# Active order required before you can start mixing
	if !current_order:
		return
		
	# Make sure we don't already have this ingredient in the cauldron
	#for child in $ActiveIngredients.get_children():
	for child in get_node("../Background/Active").get_children():
		if child.ingredient_id == ingredient_id:
			return
			
	# Replaced with color mixing
	var node
	match ingredient_id:
		Global.ING_DANDELION: node = preload("res://ingredients/dandelion.tscn").instance()
		Global.ING_FEATHER: node = preload("res://ingredients/feather.tscn").instance()
		Global.ING_MANDRAKE: node = preload("res://ingredients/mandrake.tscn").instance()
		Global.ING_MUSHROOM: node = preload("res://ingredients/mushroom.tscn").instance()
		Global.ING_SUNFLOWERSEED: node = preload("res://ingredients/sunflower_seed.tscn").instance()
		
	node.active_mode = true
	# This hurts
	get_node("../Background/Active").add_child(node)
	
	potion_sprite.modulate *= mix_color
	
	$BrewButton.show()
	
func handle_remove_ingredient(ingredient_id):
	#if $ActiveIngredients.get_child_count() == 0:
	if get_node("../Background/Active").get_child_count() == 0:
		$BrewButton.hide()
	
func handle_nextorder_pressed():
	assert($Timer.is_stopped())
	$NextOrder/AudioStreamPlayer.play()
	$NextOrder.hide()
	potion_sprite.modulate = Color(1, 1, 1, 1)
	
	current_order = orders.get_next_order()
	
	if !current_order:
		# Went through all orders. End the game or something
		$ColorRect/Label.text = "Actually... that's everything. Need to make a win screen or something. Press escape to leave."
		return
		
	# Process the order
	$ColorRect/Label.text = current_order['message']
	
	$Timer.wait_time = 30.0
	$Timer.start()
	
func handle_brew_pressed():
	var score = 0
	var ingredient_count = get_node("../Background/Active").get_child_count()
	for node in get_node("../Background/Active").get_children():
		if node.ingredient_id in current_order['ingredients']:
			score += 1
		else:
			score -= 1
			
		node.queue_free()
		
	$BrewButton.hide()
	
	var message = preload("res://shop/message.tscn").instance()
	if score == current_order['ingredients'].size():
		# Good potion
		$Timer.stop()
		message.text = current_order['good_message']
		current_order = null
		$BrewButton/GoodSound.play()
		
		satisifed_customers += 1
		
		if orders.current_order < orders.orders.size():
			$NextOrder.show()
			$ColorRect/Label.text = 'Good job! Hit "Next customer" when you\'re ready for another.'
		else:
			game_over()
		
	else:
		# Bad potion
		message.text = current_order['bad_message']
		$BrewButton/BadSound.play()
		
		ingredients_wasted += ingredient_count
		
	add_child(message)
	
func handle_bookbutton_pressed():
	$Book.toggle()
	
func handle_timeout():
	$ColorRect/Label.text = "You ran out of time. Better luck on the next one?"
	$NextOrder.show()
	$BrewButton.hide()
	for node in get_node("../Background/Active").get_children():
		node.queue_free()
		
	var message = preload("res://shop/message.tscn").instance()
	message.text = current_order['fail_message']
	add_child(message)
	current_order = null
	
func game_over():
	$ColorRect/Label.text = 'Looks like that\'s everyone!\nSatisfied customers: %d/%d\nWasted ingredients: %d' % \
		[satisifed_customers, orders.orders.size(), ingredients_wasted]
	$MenuButton.show()
	
func _process(delta):
	if !$Timer.is_stopped():
		var time_left = int($Timer.time_left)
		$TimeLabel.text = "%d" % time_left
		if time_left > 9:
			$TimeLabel.modulate = Color(0, 1, 0, 1)
		else:
			$TimeLabel.modulate = Color(1, 0, 0, 1)