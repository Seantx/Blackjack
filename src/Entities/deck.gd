extends Node
class_name Deck

var my_deck:Array[Card] = []
	
func _init() -> void:
	for suit in 4:   # suit
		for value in range(1, 14): 
			var card = Card.new(suit, value) 
			card.face_value = value
			card.suit_value = suit
			my_deck.append(card)
			#print(card.face_value)  
	my_deck.shuffle()
	#for card in my_deck:
		#print(card.face_value, ' ', card.suit_value)
