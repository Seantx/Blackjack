extends Node2D
class_name Game

@export var PlayerMoney:Label
@export var DealerMoney:Label
@export var PlayerScore:Label
@export var DealerScore:Label
@export var WagerAmt:Label

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
var round_calc = false
var player_cards_dealt = 0
var dealer_cards_dealt = 0
var cards_dealt = player_cards_dealt + dealer_cards_dealt
var player_total = 0
var dealer_total = 0
var round_over: bool = false
var hand_size = 2

var player_money = 5
var dealer_money = 5
var wager_amt = 1
var resultscreen
var result : String
var card_back = preload('res://PNG/Cards (large)/card_back.png')

func _ready() -> void:
	resultscreen = get_node("ResultScreen/Label")
	print('leggo')
	#deck = Deck.new()
	create_deck()
	print('power: ', $Deck.get_child(0).power)
	starter_deal()
	player_turn = true
	DealerMoney.text = str("$",dealer_money)
	PlayerMoney.text = str("$",player_money) 
	WagerAmt.text = str("$",wager_amt)

func create_deck() ->void:
	var card_test_shell = preload("res://src/Game/card_test.tscn")
	var card_id = load('res://src/CardResources/s2.tres')
	for n in range(1,4):
		#for key in DeckDic.deck_dic:
			#var card_id = load(DeckDic.deck_dic[key])
		#var card_id = load('res://src/CardResources/s2.tres')
		var new_card : Card2 = card_test_shell.instantiate()
		new_card.card_resource = card_id
		$Deck.add_child(new_card)
		print('ptest2:  ',new_card.power)

func _physics_process(_delta: float) -> void:
	PlayerScore.text = str(player_total)
	DealerScore.text = str(dealer_total)
	if round_over:
		if Input.is_action_just_pressed('restart'):
			if %ResultScreen.visible:
				%ResultScreen.visible = false
			new_round()
			
	if Input.is_action_just_pressed('stand') and player_turn and not round_over:
			player_turn = false
			print('stand')
	if player_turn:
		if Input.is_action_just_pressed('hit') and not player_bust:
			deal_card()
		if player_total > 21:
			if not round_calc:
				winner_calc()
			if not round_over:
				round_end()
	if not player_turn:
		if dealer_total < 17:
			deal_card()
		elif dealer_total > 16:
			if not round_calc:
				winner_calc()
			if not round_over:
				round_end()

func winner_calc() -> void:
	if player_total >= 22:
		player_bust = true
		result = 'BUST!'
	if dealer_total >= 22:
		dealer_bust = true
		result = 'Dealer BUST!'
	if player_total < 22 and dealer_total < 22:
		if player_total > dealer_total:
			dealer_bust = true
			result = 'player win!'
		if dealer_total > player_total:
			player_bust = true
			result = 'dealer win!'
		if dealer_total == player_total:
			push = true
			result = "PUUUUUSSSSHHHHH"
	resultscreen.text = result
	%ResultScreen.visible = true
	round_calc = true

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
	new_card.get_node('Sprite2D').texture = card_back
	
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


func round_end() -> void:
	if not push:
		if player_bust:
			player_money = player_money - wager_amt 
			dealer_money = dealer_money + wager_amt
		if dealer_bust:
			player_money = player_money + wager_amt
			dealer_money = dealer_money - wager_amt
	DealerMoney.text = str("$",dealer_money)
	PlayerMoney.text = str("$",player_money)
	round_over = true
	if dealer_money == 0:
		print('you win')

func new_round() -> void:
	player_bust = false
	dealer_bust = false
	push = false
	round_over = false
	round_calc = false
	player_cards_dealt = 0
	dealer_cards_dealt = 0
	cards_dealt = player_cards_dealt + dealer_cards_dealt
	player_total = 0
	dealer_total = 0
	for n in $Cards.get_children(): n.queue_free()
	deck = Deck.new()
	starter_deal()
	player_turn = true
	


func _on_hit_pressed() -> void:
	if player_turn and not round_over:
		deal_card()


func _on_stand_pressed() -> void:
	if  player_turn and not round_over:
			player_turn = false


func _on_new_round_pressed() -> void:
	if round_over:
		if %ResultScreen.visible:
				%ResultScreen.visible = false
		new_round()


func _on_raise_bet_pressed() -> void:
	if wager_amt < player_money: 
		wager_amt += 1
		WagerAmt.text = str("$",wager_amt)


func _on_lower_bet_pressed() -> void:
	if wager_amt > 1:
		wager_amt -= 1
		WagerAmt.text = str("$",wager_amt)
