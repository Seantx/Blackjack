extends Node2D
class_name Card

@export var face_value: int
@export var suit_value: int

@export var face: Label
@export var suit: Label

func _init(suit, value) -> void:
	print(suit)
	print(value)
