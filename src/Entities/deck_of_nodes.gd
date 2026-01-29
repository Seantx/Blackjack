extends Node
class_name NodeDeck

#var cards:Array[Card] = []
var cards : Array
@onready var card_shell = preload("res://src/Game/card.tscn")
	
func _init() -> void:
	for suit in 4:   # suit
		for value in range(1, 14): 
			
			var card = Card.new() 
			card.face_value = value
			card.suit_value = suit
			cards.append(card) 
	cards.shuffle()
	#for card in my_deck:
		#print(card.face_value, ' ', card.suit_value)
