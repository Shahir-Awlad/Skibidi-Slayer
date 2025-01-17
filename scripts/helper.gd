extends Area2D

@onready var label: Label = $Label

func _on_body_entered(body: Node2D) -> void:
	label.scale = Vector2(0.3, 0.3)
	var scene_name = get_tree().current_scene.name
	scene_name = scene_name.substr(0, scene_name.length() - 1)
	#print(scene_name)
	
	if scene_name == "Level_1":
		label.text = "You're trapped Gunther! Can you reach the end and hopefully save yourself? Or will you be forever stuck in this endless nightmare"
	elif scene_name == "Level_2":
		label.text = "You've proven yourself worthy o Gunther. I see now that you have the potential for growth & development. Use CTRL to dodge your enemies and avoid damage"
	

func _on_body_exited(body: Node2D) -> void:
	label.text = ""
