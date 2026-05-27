extends Control

@export var DealerMoney: Label
@export var PlayerMoney: Label
@export var Pot: Label

func _ready() -> void:
	DealerMoney.text = str("Dealer money: \n $",DealerInventory.money)
	PlayerMoney.text = str("Player money: \n $",PlayerInventory.money) 
	Signalbus.connect("round_end", round_end)
	#Pot.text = str("$",wager_amt)

func round_end() -> void:
	DealerMoney.text = str("Dealer money: \n $",DealerInventory.money)
	PlayerMoney.text = str("Player money: \n $",PlayerInventory.money) 

func hit():
	Signalbus.hit.emit()

func stand():
	Signalbus.stand.emit()

func _on_hit_pressed() -> void:
	hit()
	
func _on_stand_pressed() -> void:
	stand()

func _on_double_down_pressed() -> void:
	pass # Replace with function body.

func _on_split_pressed() -> void:
	pass # Replace with function body.
