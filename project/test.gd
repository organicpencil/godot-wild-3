extends Control

func _ready():
	$NextOrder.connect("pressed", self, "handle_next_order")
	handle_next_order()
	
func handle_next_order():
	var order = Orders.get_next_order()
	
	if !order:
	    # Went through all orders. End the game or something
	    $Label.text = 'You win?'
	    return
	
	$Label.text = order['message']