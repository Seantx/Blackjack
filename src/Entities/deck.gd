extends Node
class_name Deck

#var cards:Array[Card] = []
var cards : Array
var cards2: Array
@onready var card_shell = preload("res://src/Game/card.tscn")
#@onready var card_test_shell = preload("res://src/Game/card_test.tscn")

func _init() -> void:
	#var deck_id: CardDeck
	var card_test_shell = preload("res://src/Game/card_test.tscn")
	for n in range(1,4):
		#for key in DeckDic.deck_dic:
			#var card_id = load(DeckDic.deck_dic[key])
		var card_id = load('res://src/CardResources/s2.tres')
		var new_card : Card2 = card_test_shell.instantiate()
		new_card.card_resource = card_id
		print('ptest ',n,' ',new_card.power)
		add_child(new_card)
		print('ptest2',new_card.power)
			#cards2.append(card_test_shell)
	for suit in 4:   # suit
		for value in range(1, 14): 
			var new_card = [suit,value]
			cards.append(new_card)
			
	cards.shuffle()
