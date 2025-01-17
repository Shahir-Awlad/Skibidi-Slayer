extends Area2D
func _on_body_entered(body: Node2D) -> void:
	print("Death")
	Engine.time_scale = 0.5
	body.get_node("CollisionShape2D").queue_free()
	body.player_dies()
