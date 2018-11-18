"""
### Stores data for potential orders. Usage example:
var order = Orders.get_next_order()

if !order:
    # Went through all orders. End the game or something
    $Label.text = 'You win?'
    return

$Label.text = order['message']

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
	normal_orders()
	alternative_orders() # Why not, I could barely make it this far anyway
	
func normal_orders():
	orders.append({	'message': "A villager steps up, complaining about insomnia.",
					'ingredients': [Global.ING_MANDRAKE],
					'good_message': "Excellent!", # Could use a generic message instead
					'bad_message': "That doesn't smell right.", # Could use a generic message instead
					'fail_message': "The villager walks out. \"I'll just live with it.\"" # Could use a generic message instead
					})
					
	orders.append({	'message': "A distressed young person is worried their lover has turned into a frog.",
					'ingredients': [Global.ING_FEATHER],
					'good_message': "Excellent!", # Could use a generic message instead
					'bad_message': "It didn't work.", # Could use a generic message instead
					'fail_message': "The frog wriggles free and makes a daring jump for the window." # Could use a generic message instead
					})
					
	orders.append({	'message': "An elderly person enters the shop, seeking youth and good health.",
					'ingredients': [Global.ING_DANDELION, Global.ING_MANDRAKE],
					'good_message': "Excellent!", # Could use a generic message instead
					'bad_message': "Nope, that just made it worse.", # Could use a generic message instead
					'fail_message': "The client leaves, dissatisfied." # Could use a generic message instead
					})
					
	orders.append({	'message': "A local ranger asks you to poison some arrows.",
					'ingredients': [Global.ING_MUSHROOM],
					'good_message': "Excellent!", # Could use a generic message instead
					'bad_message': "That doesn't smell right.", # Could use a generic message instead
					'fail_message': "The ranger leaves before you can finish." # Could use a generic message instead
					})
					
	orders.append({	'message': "A local warrior requires a strength and stamina boost for an upcoming boss event.",
					'ingredients': [Global.ING_FEATHER, Global.ING_DANDELION],
					'good_message': "Excellent!", # Could use a generic message instead
					'bad_message': "That doesn't smell right.", # Could use a generic message instead
					'fail_message': "The warrior leaves before you can finish." # Could use a generic message instead
					})
					
	orders.append({	'message': "The next client tells you their mother is suffering from hypothermia.",
					'ingredients': [Global.ING_SUNFLOWERSEED, Global.ING_MANDRAKE],
					'good_message': "Excellent!", # Could use a generic message instead
					'bad_message': "That doesn't smell right.", # Could use a generic message instead
					'fail_message': "The person walks out. \"I'll just take her to the doctor.\"" # Could use a generic message instead
					})
					
	orders.append({	'message': "The neighborhood dragon-catcher is having trouble finding good homes. They keep wanting to bite people.",
					'ingredients': [Global.ING_DANDELION, Global.ING_SUNFLOWERSEED],
					'good_message': "Excellent!", # Could use a generic message instead
					'bad_message': "That doesn't smell right.", # Could use a generic message instead
					'fail_message': "The druid grasps its club and walks out." # Could use a generic message instead
					})
	
func alternative_orders():
	orders.append({	'message': "An angry duck violently waddles in, demanding something that will help it float.",
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
				
	orders.append({	'message': "One final customer enters the store. \"Just give me everything you have.\".",
					'ingredients': [Global.ING_DANDELION, Global.ING_SUNFLOWERSEED, Global.ING_FEATHER, Global.ING_MANDRAKE, Global.ING_MUSHROOM],
					'good_message': "Excellent!", # Could use a generic message instead
					'bad_message': "That doesn't look strong enough.", # Could use a generic message instead
					'fail_message': "The client is surprised that you were unable to fill this order." # Could use a generic message instead
					})

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
