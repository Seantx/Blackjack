extends Node2D
class_name Card2

@export var card_resource: Resource
var clickable = false
var power
var size


func _ready() -> void:
	%CardFace.texture = card_resource.texture
	power = card_resource.power
	size = card_resource.size
	print('ready?')

func _physics_process(delta: float) -> void:
	if clickable == true and Input.is_action_pressed('click'):
		self.global_position = get_global_mouse_position()
	if Input.is_action_just_released('click'):
		clickable = false

func _on_area_2d_mouse_entered() -> void:
	clickable = true
	print('click me')
	print(power)

func _on_area_2d_mouse_exited() -> void:
	if not Input.is_action_pressed('click'):
		clickable = false
		print('come back')
