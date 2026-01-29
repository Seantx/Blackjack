extends Node2D
class_name Game

@onready var deck: Deck
@onready var nodedeck: NodeDeck
@onready var hand: Hand
@onready var deck_poition = 0
@onready var curr_hand =[]
@onready var cards = []
@onready var card_shell = preload("res://src/Game/card.tscn")
@onready var draw_no =0
@onready var players = 2
var player_turn: bool = true
var player_cards_dealt = 0
var dealer_cards_dealt = 0
var cards_dealt = player_cards_dealt + dealer_cards_dealt
var player_total = 0
var dealer_total = 0
var hand_size = 2

func _ready() -> void:
	print('leggo')
	deck = Deck.new()
	nodedeck=NodeDeck.new()
	print(deck.cards)
	starter_deal()
	#deal_hand()
	#add_child(card_shell)
	
func _physics_process(delta: float) -> void:	
	if player_turn:
		if Input.is_action_just_pressed('hit'):
			var card_def = deck.cards.pop_front()
			var new_card = card_shell.instantiate()
			new_card.face_value = card_def[1]
			new_card.get_node('Control/FaceLabel').text = str(card_def[0])
			new_card.suit_value = card_def[0]
			new_card.get_node('Control/SuitLabel').text = str(card_def[1])
			
			new_card.global_position = %PlayerHand.global_position + Vector2(player_cards_dealt * 100,0)
			
			player_total += new_card.face_value
			print(player_total)
			add_child(new_card)
			player_cards_dealt += 1
			
			
			if player_total > 21:
				%Bust.visible = true
				if Input.is_action_just_pressed("restart"):
					get_tree().reload_current_scene()
			
			if Input.is_action_just_pressed('stand'):
				player_turn = false
			
		
		 
	if Input.is_action_just_pressed("draw"):
		var new_card = nodedeck.cards[draw_no]
		var face_label = Label.new()
		var suit_label = Label.new()
		var card_face = ColorRect.new()
		face_label.text = str(new_card.face_value)
		suit_label.text = str(new_card.suit_value)
		suit_label.global_position = face_label.global_position + Vector2(0,100)
		card_face.color = Color.WHITE
		new_card.add_child(card_face)
		new_card.add_child(face_label)
		new_card.add_child(suit_label)
		add_child(new_card)
		print(new_card)
		draw_no += 1

func starter_deal() -> void:
	for bettors in players:
		for card in hand_size:
			var card_def = deck.cards.pop_front()
			var new_card = card_shell.instantiate()
			
			new_card.face_value = card_def[1]
			new_card.get_node('Control/FaceLabel').text = str(card_def[0])
			new_card.suit_value = card_def[0]
			new_card.get_node('Control/SuitLabel').text = str(card_def[1])
			
			if player_turn:
				new_card.global_position = %PlayerHand.global_position + Vector2(player_cards_dealt * 100,0)
				player_turn = false
				player_cards_dealt += 1
				player_total += new_card.face_value
			else:
				new_card.global_position = %DealerHand.global_position + Vector2(dealer_cards_dealt * 100,0)
				player_turn = true
				dealer_cards_dealt += 1
				dealer_total += new_card.face_value
			
			print(player_total)
			add_child(new_card)
	
func deal_card() -> void:
	var card_def = deck.cards.pop_front()
	var new_card = card_shell.instantiate()
		
	new_card.face_value = card_def[1]
	new_card.get_node('Control/FaceLabel').text = str(card_def[0])
	new_card.suit_value = card_def[0]
	new_card.get_node('Control/SuitLabel').text = str(card_def[1])
	
	if player_turn:
		new_card.global_position = %PlayerHand.global_position + Vector2(player_cards_dealt * 100,0)
		player_turn = false
		player_cards_dealt += 1
		player_total += new_card.face_value
	else:
		new_card.global_position = %DealerHand.global_position + Vector2(dealer_cards_dealt * 100,0)
		player_turn = true
		dealer_cards_dealt += 1
		dealer_total += new_card.face_value
	
	print(player_total)
	add_child(new_card)
