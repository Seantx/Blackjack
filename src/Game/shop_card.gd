extends VBoxContainer
class_name ShopCard

const CARD_MENU_UI = preload("res://src/Game/card_menu_ui.tscn")



@onready var card_container: CenterContainer = %CardContainer
@onready var price: HBoxContainer = %Price
@onready var price_label: Label = %PriceLabel
@onready var buy_button : Button = %BuyButton
@onready var gold_cost := randi_range(1,10)


	

func _on_buy_button_pressed() -> void:
	remove_child(%CardContainer)
	remove_child(%Price)
	remove_child(%BuyButton) 
