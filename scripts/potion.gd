extends Area2D

const SHAKE_SPEED = 8
const SHAKE_AMPLITUDE = 0.5

var time = 0.0
var original_position: Vector2

func _ready() -> void:
	# Store the original position when the potion is initialized
	original_position = position

func _process(delta: float) -> void:
	time += delta * SHAKE_SPEED
	# Apply the shake as an offset from the original position
	position = original_position + Vector2(0, sin(time) * SHAKE_AMPLITUDE)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Body revival activated")
		body.revive_activator()
		queue_free()
