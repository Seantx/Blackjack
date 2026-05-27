extends MarginContainer



func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Game/game.tscn")


func _on_how_to_play_pressed() -> void:
	get_tree().change_scene_to_file("res://how_to_play.tscn")
