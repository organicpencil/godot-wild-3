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
        Global.ING_DANDELION: pass
        Global.ING_FEATHER: pass
        Global.ING_MANDRAKE: pass
        Global.ING_MUSHROOM: pass
        Global.ING_SEED: pass
"""

extends Object

var orders = []
var current_order = 0

func _init():
	orders.append({	'message': "An angry duck violently waddles in, demanding something that will aid with floatation.",
					'ingredients': [Global.ING_DANDELION, Global.ING_SUNFLOWERSEED],
					'good_message': "Excellent!", # Could use a generic message instead
					'bad_message': "The duck is not pleased. Try again.", # Could use a generic message instead
					'fail_message': "The duck decides to take its business elsewhere." # Could use a generic message instead
					})
					
	orders.append({	'message': 'A huge rat enters the shop. It\'s walking half-sideways while compulsively scratching its cheek. "Hey man... you got something for me?"',
				'ingredients': [Global.ING_MUSHROOM],
				'good_message': "Excellent!", # Could use a generic message instead
				'bad_message': "What? No! Something *else*", # Could use a generic message instead
				'fail_message': "The cops show up and take the rat before you can finish." # Could use a generic message instead
				})
					
"""
	register_order("A local farmer needs help with a termite problem.", [Global.ING_MUSHROOM])#, "res://faces/farmer.png")
	register_order("An angry duck violently charges in, demanding something that will help it float.", [Global.ING_DANDELION, Global.ING_SUNFLOWERSEED]) # Face is optional

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
"""

func get_next_order():
	"""
	Gets a different order each time until running out of orders. The returned object is a dictionary with the following fields, or null when no orders remain:
	
	message: Message shown to the player. String.
	
	ingredients: Array of integers. Possible values are Global.ING_DANDELION, Global.ING_FEATHER, Global.ING_MANDRAKE, Global.ING_MUSHROOM, Global.ING_SEED.
	
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