extends Node2D
class_name Card

@export var face_value: int
@export var suit_value: int


@onready var face_label: Label
@export var suit_label: Label

@export var card_definition: Resource

var suit_set: int
var face_set: int
var clickable = false

func _physics_process(delta: float) -> void:
	if clickable == true and Input.is_action_pressed('click'):
		self.global_position = get_global_mouse_position()
	if Input.is_action_just_released('click'):
		clickable = false

func _on_area_2d_mouse_entered() -> void:
	clickable = true
	print('click me')

func _on_area_2d_mouse_exited() -> void:
	clickable = false
	print('come back')
