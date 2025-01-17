extends Control

@onready var game_manager: Node = %GameManager

func _on_start_pressed() -> void:
	game_manager.fanum_tax()


func _on_about_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
