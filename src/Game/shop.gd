extends Control

const shop_card = preload("res://src/Game/shop_card.tscn")

func _ready() -> void:
	var new_slot = shop_card.instantiate()
	%Cards.add_child(new_slot)



func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Game/game.tscn")
