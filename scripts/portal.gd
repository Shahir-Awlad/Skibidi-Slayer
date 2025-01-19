extends Area2D

@onready var game_manager: Node = %GameManager


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var scene_name = get_tree().current_scene.name
		scene_name = scene_name.substr(0, scene_name.length() - 1)
		if scene_name == "Level_1":
			game_manager.linganguli()
		elif scene_name == "Level_2":
			game_manager.hawktuah()
		elif scene_name == "Level_3":
			Transition.transition()
			await Transition.on_transition_finished
			get_tree().change_scene_to_file("res://scenes/level_4A.tscn")
		elif scene_name == "Level_4":
			Transition.transition()
			await Transition.on_transition_finished
			get_tree().change_scene_to_file("res://scenes/level_4B.tscn")
