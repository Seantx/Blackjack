extends Node2D
class_name Game

@export var PlayerMoney:Label
@export var DealerMoney:Label
@export var PlayerScore:Label
@export var DealerScore:Label

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
var player_bust = false
var dealer_bust = false
var push = false
var player_cards_dealt = 0
var dealer_cards_dealt = 0
var cards_dealt = player_cards_dealt + dealer_cards_dealt
var player_total = 0
var dealer_total = 0
var round_over: bool = false
var hand_size = 2

var player_money = 5
var dealer_money = 5
var pot = 1

func _ready() -> void:
	print('leggo')
	deck = Deck.new()
	print(deck.cards)
	starter_deal()
	player_turn = true
	DealerMoney.text = str("$",dealer_money)
	PlayerMoney.text = str("$",player_money) 
	#deal_hand()
	#add_child(card_shell)
	
func _physics_process(delta: float) -> void:
	PlayerScore.text = str(player_total)
	DealerScore.text = str(dealer_total)
	if round_over:
		if Input.is_action_just_pressed('restart'):
			if %DealerBust.visible:
				%DealerBust.visible = false
			if %Bust.visible:
				%Bust.visible = false
			new_round()
	if Input.is_action_just_pressed('stand') and player_turn:
			player_turn = false
			print('stand')
	if player_turn:
		if Input.is_action_just_pressed('hit') and not player_bust:
			var card_def = deck.cards.pop_front()
			var new_card = card_shell.instantiate()
			new_card.face_value = card_def[1]
			new_card.get_node('Control/FaceLabel').text = str(card_def[0])
			new_card.suit_value = card_def[0]
			new_card.get_node('Control/SuitLabel').text = str(card_def[1])
			
			new_card.global_position = %PlayerHand.global_position + Vector2(player_cards_dealt * 100,0)
			
			player_total += clamp(new_card.face_value,0,10)
			print(player_total)
			$Cards.add_child(new_card)
			player_cards_dealt += 1
			
			if player_total > 21:
				%Bust.visible = true
				player_bust = true
				round_end()
				
				
	if not player_turn:
		if Input.is_action_just_pressed('hit'):
			var card_def = deck.cards.pop_front()
			var new_card = card_shell.instantiate()
			new_card.face_value = card_def[1]
			new_card.get_node('Control/FaceLabel').text = str(card_def[0])
			new_card.suit_value = card_def[0]
			new_card.get_node('Control/SuitLabel').text = str(card_def[1])
			
			new_card.global_position = %DealerHand.global_position + Vector2(dealer_cards_dealt * 100,0)
			
			dealer_total += clamp(new_card.face_value,0,10)
			print('dealer turn ', dealer_total)
			$Cards.add_child(new_card)
			dealer_cards_dealt += 1
			if dealer_total > 21:
				%DealerBust.visible = true
				dealer_bust = true
				round_end()
		if Input.is_action_just_pressed('stand'):
			if player_total > dealer_total:
				dealer_bust = true
			if dealer_total > player_total:
				player_bust = true
			if dealer_total == player_total:
				push = true
			round_end()

func starter_deal() -> void:
	for bettors in players:
		for card in hand_size:
			deal_card()
			if player_turn:
				player_turn = false
			else:
				player_turn = true

	
func deal_card() -> void:
	var card_def = deck.cards.pop_front()
	var new_card = card_shell.instantiate()
		
	new_card.face_value = card_def[1]
	new_card.get_node('Control/FaceLabel').text = str(card_def[0])
	new_card.suit_value = card_def[0]
	new_card.get_node('Control/SuitLabel').text = str(card_def[1])
	
	if player_turn:
		new_card.global_position = %PlayerHand.global_position + Vector2(player_cards_dealt * 100,0)
		player_cards_dealt += 1
		player_total += clamp(new_card.face_value,0,10)
	else:
		new_card.global_position = %DealerHand.global_position + Vector2(dealer_cards_dealt * 100,0)
		dealer_cards_dealt += 1
		dealer_total += clamp(new_card.face_value,0,10)
	
	print(player_total)
	$Cards.add_child(new_card)
	#PlayerScore.text = str(player_total)
	#DealerScore.text = str(dealer_total)

func round_end() -> void:
	print('round end')
	if not push:
		if player_bust:
			player_money = player_money - pot 
			dealer_money = dealer_money + pot
		if dealer_bust:
			player_money = player_money + pot
			dealer_money = dealer_money - pot
	DealerMoney.text = str("$",dealer_money)
	PlayerMoney.text = str("$",player_money)
	round_over = true

func new_round() -> void:
	player_bust = false
	dealer_bust = false
	push = false
	player_cards_dealt = 0
	dealer_cards_dealt = 0
	cards_dealt = player_cards_dealt + dealer_cards_dealt
	player_total = 0
	dealer_total = 0
	for n in $Cards.get_children(): n.queue_free()
	deck = Deck.new()
	starter_deal()
	player_turn = true
	
