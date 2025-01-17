extends Area2D

@onready var timer: Timer = $Timer
@onready var hurt: AudioStreamPlayer2D = $Hurt
@onready var game_manager: Node = %GameManager

# Dictionary to store original positions of platforms
var original_positions: Dictionary = {}

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Death")
		Engine.time_scale = 0.5
		hurt.play()
		body.player_dies()
		timer.start()
		
	if body.is_in_group("Platform"):
		if body.name in original_positions:
			body.reset()
			body.global_position = original_positions[body.name]
		else:
			print("Error: Platform original position not found")

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	game_manager.fanum_tax()

func _ready() -> void:
	for platform in get_tree().get_nodes_in_group("Platform"):
		original_positions[platform.name] = platform.global_position
