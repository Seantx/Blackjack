extends Node2D
class_name Game

@onready var deck: Deck
@onready var hand: Hand
@onready var deck_poition = 0
@onready var curr_hand =[]
@onready var cards = []
@onready var card_shell = preload("res://src/Game/card.tscn")
var cards_dealt = 0

func _ready() -> void:
	print('leggo')
	deck = Deck.new()
	deal_hand()
	#add_child(card_shell)
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed('hit'):
		
		var new_card = card_shell.instantiate()
		print(cards[cards_dealt].face_value)
		new_card.face_value = 3
		add_child(new_card)
		
		cards_dealt += 1 

#need to figure out how to access the cards save in the deck
#also need to determine where to save hand size
func deal_hand() -> void:
	for card_spot in range(0,7):
		cards.append(deck.my_deck.pop_front())
		#cards.append(deck.my_deck[card_spot])
		print(deck.my_deck[card_spot].suit_value, " ",deck.my_deck[card_spot].face_value)
		cards[card_spot].global_position = Vector2.ZERO + Vector2(card_spot * 100, 0)
		add_child(cards[card_spot])
		
