extends Node2D
class_name Card

@export var face_value: int
@export var suit_value: int

@onready var face_label: Label
@export var suit_label: Label

var suit_set: int
var face_set: int

#func _init(suit,value) -> void:
	#suit_set = suit
	#face_set = value
#
#func _ready() -> void:
	#face_label.text = str(face_set)
	#suit_label.text = str(suit_set)
	#print(face_set)
