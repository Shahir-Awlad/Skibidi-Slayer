extends CharacterBody2D

const SPEED = 100.0  # Movement speed
const ATTACK_RANGE = 50.0  # Distance at which the boss will attack
const DETECTION_RANGE = 200.0  # Distance at which the boss starts tracking the player
const STOP_DISTANCE = 20.0  # Distance to stop before reaching the player

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $Area2D  # Proximity detection area
@onready var attack_timer: Timer = $Timer  # Cooldown timer for attacks

var player: CharacterBody2D = null  # Reference to the player
var is_attacking = false


func _physics_process(delta: float) -> void:
	if player:
		var distance_to_player = global_position.distance_to(player.global_position)

		if distance_to_player > ATTACK_RANGE and not is_attacking:
			# Move toward the player
			move_toward_player(distance_to_player)
		elif distance_to_player <= ATTACK_RANGE and not is_attacking:
			# Attack the player when in range
			start_attack()
	else:
		# If no player is nearby, stop horizontal movement
		velocity.x = 0

	# Apply movement and collisions
	move_and_slide()

func move_toward_player(distance_to_player: float) -> void:
	if distance_to_player > STOP_DISTANCE:
		# Calculate direction toward the player
		var direction = (player.global_position - global_position).normalized()
		velocity.x = direction.x * SPEED

		# Flip the sprite based on movement direction
		animated_sprite.flip_h = direction.x < 0
		# Play "run" animation while moving
		animated_sprite.play("run")
	else:
		# Stop moving when within the STOP_DISTANCE
		velocity.x = 0
		animated_sprite.play("idle")  # Optionally, play an idle animation

func start_attack() -> void:
	is_attacking = true
	velocity.x = 0  # Stop moving while attacking
	animated_sprite.play("attack")
	print("Boss attacks the player!")
	attack_timer.start(1.0)  # Set attack cooldown

func _on_attack_timer_timeout() -> void:
	is_attacking = false

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		print("Player detected!")

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		print("Player lost!")
		animated_sprite.play("idle")
