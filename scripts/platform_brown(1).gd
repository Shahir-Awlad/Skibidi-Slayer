extends AnimatableBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var count = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and count < 1:
		#print("player entered")
		count += 1
		animation_player.play("move")
