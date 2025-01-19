extends Area2D

@onready var label: Label = $Label
@onready var game_manager: Node = %GameManager

var player_in_area = false  # Tracks if the player is inside the NPC's area

func _process(delta: float) -> void:
	# Only check for interaction if the player is in the area
	if player_in_area:
		var scene_name = get_tree().current_scene.name
		scene_name = scene_name.substr(0, scene_name.length() - 1)

		if scene_name == "Level_4":
			var gold = game_manager.hustling()
			if gold >= 50 and Input.is_action_just_pressed("interact"):
				#print("interacted")
				label.text = "You can now double jump! Hope this helps you defeat Lysanderoth and get out of this nightmare"
				player_in_area.double_jump_activator()  # Call player's function
			elif gold < 50 and Input.is_action_just_pressed("interact"):
				label.text = "Get yo broke ass outta here! You have only " + gold + " coins"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = body  # Save the player reference
		label.scale = Vector2(0.3, 0.3)
		var scene_name = get_tree().current_scene.name
		scene_name = scene_name.substr(0, scene_name.length() - 1)

		if scene_name == "Level_1":
			label.text = "You're trapped Chadicus! Can you reach the end and hopefully save yourself? Or will you be forever stuck in this endless nightmare"
		elif scene_name == "Level_2":
			label.text = "You've proven yourself worthy o Chadicus. I see now that you have the potential for growth & development. Use CTRL to dodge your enemies and avoid damage"
		elif scene_name == "Level_3":
			label.text = "Chadicus you have made it this far, but the path ahead is frought with danger and you're gonna need this. Take this sword and vanquish your foes by using SHIFT"
		elif scene_name == "Level_4":
			label.text = "Congratulation on getting this far Chadicus but the fight isn't over yet. Ahead lies your final battle. A fight against the dreadful Lysanderoth. I have one last ability to give but I would need 50 gold from you. Press E to buy my double jump ability"

func _on_body_exited(body: Node2D) -> void:
	if body == player_in_area:
		player_in_area = null
		label.text = ""
