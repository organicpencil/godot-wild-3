extends Node

const GameScene = preload("res://shop/shop.tscn")
const Witch = preload("res://shop/witch.tscn")

func _ready():
	$Menu/Begin.connect("pressed", self, "start_game")
	$Menu/Exit.connect("pressed", get_tree(), "quit")
	
func start_game():
	$Menu.hide()
	
	# Uncomment to add witch after starting
	#var witch = Witch.instance()
	#$Background.add_child(witch)
	
	var shop = GameScene.instance()
	add_child(shop)