"""
### Stores data for potential orders. Usage example:
var order = Orders.get_next_order()

if !order:
    # Went through all orders. End the game or something
    $Label.text = 'You win?'
    return

$Label.text = order['message']
$TextureRect.texture = orders['face'] # Face can be null, should probably handle that

for ingredient in order['ingredients']:
    match ingredient:
        Orders.ING_DANDELION: pass
        Orders.ING_FEATHER: pass
        Orders.ING_MANDRAKE: pass
        Orders.ING_MUSHROOM: pass
        Orders.ING_SEED: pass
"""

extends Node

enum {ING_DANDELION, ING_FEATHER, ING_MANDRAKE, ING_MUSHROOM, ING_SEED}

var orders = []
var current_order = 0

func _ready():
	# Call register_order for each possible order.
	register_order("A local farmer needs help with a termite problem.", [ING_MUSHROOM], "res://faces/farmer.png")
	register_order("I require floatation and happiness.", [ING_DANDELION, ING_SEED]) # Face is optional

func register_order(message : String, ingredients : Array, face=null):
	var order = {}
	order['message'] = message
	#order['message_key'] = message_key # Translations
	order['ingredients'] = ingredients
	if face:
		order['face'] = load(face)
	else:
		order['face'] = null
		
	orders.append(order)

func get_next_order():
	"""
	Gets a different order each time until running out of orders. The returned object is a dictionary with the following fields, or null when no orders remain:
	
	message: Message shown to the player. String.
	
	ingredients: Array of integers. Possible values are ING_DANDELION, ING_FEATHER, ING_MANDRAKE, ING_MUSHROOM, ING_SEED.
	
	face: Customer's face texture resource. ImageTexture resource or null
	
	
	"""
	var order
	
	if current_order < orders.size():
		order = orders[current_order]
		#order['message'] = Translation.get_message(order['message_key']) # Translations
		current_order += 1
	else:
		print("No more orders...")
	
	return order
	
func reset():
	"""
	Resets current_order to 0, so the next call of get_next_order will return the first order.
	Useful for resetting the game without remaking this node.
	"""
	current_order = 0