extends Node2D
class_name Game

@export var CurrentMoney:Label
@export var WagerAmount:Label

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
var cards_dealt = 0
var player_total = 0
var dealer_total = 0
var round_over: bool = false
var hand_size = 2
var cards_in_deck : Array

var player_money = PlayerInventory.money
var dealer_money = 5
var wager_amt = 1
var resultscreen
var result : String
var weight = 4
var fulldeck
#var card_back = preload('res://PNG/Cards (large)/card_back.png')

func _ready() -> void:
	resultscreen = get_node("ResultScreen/VBoxContainer/RoundResult")
	
	var player_hand = get_node("Phand")
	WagerAmount.text = str("Wager Amount: \n$",wager_amt)
	CurrentMoney.text = str("Current Money: \n$",PlayerInventory.money)
	WagerAmount.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	CurrentMoney.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	Signalbus.connect("hit", hit)
	Signalbus.connect("stand", stand)
	
	print('leggo')
	
	create_deck()
	print('power: ', $Deck.get_child(0).power)
	starter_deal()
	player_turn = true
	#DealerMoney.text = str("$",DealerInventory.money)
	#PlayerMoney.text = str("$",player_money) 
	#WagerAmt.text = str("$",wager_amt)

func create_deck() ->void:
	var card_test_shell = preload("res://src/Game/card_test.tscn")
	
	var cards = 0
	#var card_id = load('res://src/CardResources/s2.tres')
	for key in DeckDic.deck_dic:
		var card_id = load(DeckDic.deck_dic[key])
		var new_card : Card2 = card_test_shell.instantiate()
		new_card.card_resource = card_id
		
		$Deck.add_child(new_card)
		new_card.global_position = %DeckLocation.global_position + Vector2(cards, 0)
	fulldeck = get_node("Deck").get_children()


func _physics_process(delta: float) -> void:
	#PlayerScore.text = str(player_total)
	#DealerScore.text = str(dealer_total)
	weight += delta
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
	cards_in_deck = $Deck.get_children()
	print('preshuff',cards_in_deck[0])
	cards_in_deck.shuffle()
	print('postshuff',cards_in_deck[0])
	var n = 0
	for c in cards_in_deck:
		c.global_position = %DeckLocation.global_position + Vector2(n*1,0)
		c.dealt = false
		n+=1
		if n>10: n=10
	
	for bettors in players:
		for card in hand_size:
			deal_card()
			if player_turn:
				player_turn = false
			else:
				player_turn = true


func deal_card() -> void:
	print(wager_amt)
	cards_dealt = player_cards_dealt + dealer_cards_dealt
	var new_card = cards_in_deck[cards_dealt]
	new_card.dealt = true
	
	if player_turn:
		new_card.global_position = lerp(%DeckLocation.global_position,
		%PlayerHand.global_position + Vector2(player_cards_dealt * 100,0),1)
		
		player_cards_dealt += 1
		player_total += new_card.power
	else:
		new_card.global_position = %DealerHand.global_position + Vector2(dealer_cards_dealt * 100,0)
		dealer_cards_dealt += 1
		dealer_total += new_card.power


func round_end() -> void:
	if not push:
		if player_bust:
			PlayerInventory.money = PlayerInventory.money - wager_amt 
			DealerInventory.money = DealerInventory.money + wager_amt
		if dealer_bust:
			PlayerInventory.money = PlayerInventory.money + wager_amt
			DealerInventory.money = DealerInventory.money - wager_amt
	CurrentMoney.text = str("Current Money: \n$",PlayerInventory.money)
	Signalbus.round_end.emit()
	round_over = true
	if dealer_money == 0:
		print('you win')
	for card in fulldeck:
		card.dealt = false

func new_round() -> void:
	player_bust = false
	dealer_bust = false
	push = false
	round_over = false
	round_calc = false
	player_cards_dealt = 0
	dealer_cards_dealt = 0
	cards_dealt = 0
	player_total = 0
	dealer_total = 0
	starter_deal()
	player_turn = true
	


func hit() -> void:
	if player_turn and not round_over:
		deal_card()


func stand() -> void:
	if  player_turn and not round_over:
			player_turn = false


func _on_new_round_pressed() -> void:
	if round_over:
		if %ResultScreen.visible:
				%ResultScreen.visible = false
		new_round()


func _on_raise_bet_pressed() -> void:
	if wager_amt <= player_money: 
		wager_amt += 1
		WagerAmount.text = str("Wager Amount: \n$",wager_amt)
		


func _on_lower_bet_pressed() -> void:
	if wager_amt > 1:
		wager_amt -= 1
		WagerAmount.text = str("Wager Amount: \n$",wager_amt)
	

func _on_check_shop_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Game/shop.tscn")
