extends Area2D

@onready var game_manager: Node = %GameManager


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var scene_name = get_tree().current_scene.name
		scene_name = scene_name.substr(0, scene_name.length() - 1)
		if scene_name == "Level_1":
			game_manager.linganguli()
