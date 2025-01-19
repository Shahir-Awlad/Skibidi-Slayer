extends Control

@onready var game_manager: Node = %GameManager

func _ready() -> void:
	if not is_inside_tree():
		print("This root node is not in the tree!")
	else:
		print("Root node is properly in the tree.")


func _on_start_pressed() -> void:
	game_manager.fanum_tax()

func _on_how_to_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/how_to_play.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
