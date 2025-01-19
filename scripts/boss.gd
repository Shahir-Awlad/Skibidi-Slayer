extends CharacterBody2D

const SPEED = 90.0
const ATTACK_RANGE = 60.0
const GRAVITY = 500.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_hitbox_1: Area2D = $"Attack Hitbox_1"
@onready var attack_hitbox_2: Area2D = $"Attack Hitbox_2"
@onready var attack_hitbox_3: Area2D = $"Attack Hitbox_3"
@onready var agro_zone: Area2D = $"Agro Zone"
@onready var timer: Timer = $Timer
@onready var game_manager: Node = %GameManager
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var tile_map: TileMap = %TileMap
@onready var dialogue: AudioStreamPlayer2D = $Dialogue
@onready var dialogue_2: AudioStreamPlayer2D = $Dialogue2

var player: CharacterBody2D = null
var is_attacking = false
var player_is_dead = false
var health = 8
var sound_played = false
var is_dead = false

func _physics_process(delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO  # Stop all movement
		move_and_slide()  # Process physics to handle collisions, etc.
		return

	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else: 
		velocity.y = 0

	if player:
		var horizontal_dist = abs(global_position.x - player.global_position.x)
		var vertical_dist = abs(global_position.y - player.global_position.y)

		if horizontal_dist <= ATTACK_RANGE and vertical_dist <= 50.0 and not is_attacking and not player_is_dead:
			start_attack(vertical_dist)
		elif horizontal_dist > ATTACK_RANGE and not is_attacking and not player_is_dead:
			move_towards_player(horizontal_dist)

	move_and_slide()

func move_towards_player(dist: float) -> void:
	var direction = (player.global_position - global_position).normalized()
	velocity.x = direction.x * SPEED

	if direction.x < 0: 
		animated_sprite_2d.flip_h = true
		attack_hitbox_1.position = Vector2(-25.0, attack_hitbox_1.position.y) 
		attack_hitbox_2.position = Vector2(25.0, attack_hitbox_1.position.y) 
	else:
		animated_sprite_2d.flip_h = false
		attack_hitbox_1.position = Vector2(25.0, attack_hitbox_1.position.y)
		attack_hitbox_2.position = Vector2(-25.0, attack_hitbox_1.position.y)

	animated_sprite_2d.play("run")

func start_attack(vertical_dist) -> void:
	if is_dead or is_attacking:
		return  # Prevent attacking if dead or already attacking

	is_attacking = true
	velocity.x = 0
	animated_sprite_2d.play("idle")

	
	if vertical_dist > 40:
		animated_sprite_2d.play("attack_4")
	else:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var att_type = rng.randi_range(0, 9)
		if att_type < 5:
			animated_sprite_2d.play("attack_1")
		elif att_type < 8:
			animated_sprite_2d.play("attack_2")
		else:
			animated_sprite_2d.play("attack_3")

	if not is_dead:
		await animated_sprite_2d.animation_finished
	is_attacking = false

func _on_agro_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		if not sound_played:
			sound_played = true
			dialogue.play()

func _on_agro_zone_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		animated_sprite_2d.play("idle")

func _on_attack_hitbox_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.player_dies()
		player_is_dead = true

func _on_attack_hitbox_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.player_dies()
		player_is_dead = true

func _on_attack_hitbox_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.player_dies()
		player_is_dead = true

func _on_animated_sprite_2d_frame_changed() -> void:
	if is_dead:
		return  # Do not process frame changes if the boss is dead
	if animated_sprite_2d == null:
		print("animated_sprite_2d is null")
		return

	if animated_sprite_2d.animation == "attack_1":
		if animated_sprite_2d.frame == 8:
			attack_hitbox_1.monitoring = true
		elif animated_sprite_2d.frame == 10:
			attack_hitbox_1.monitoring = false
	elif animated_sprite_2d.animation == "attack_2":
		if animated_sprite_2d.frame == 8:
			attack_hitbox_1.monitoring = true
			attack_hitbox_2.monitoring = true
		elif animated_sprite_2d.frame == 11:
			attack_hitbox_1.monitoring = false
			attack_hitbox_2.monitoring = false
	elif animated_sprite_2d.animation == "attack_3":
		if animated_sprite_2d.frame == 8:
			attack_hitbox_1.monitoring = true
			attack_hitbox_3.monitoring = true
		elif animated_sprite_2d.frame == 11:
			attack_hitbox_1.monitoring = false
			attack_hitbox_3.monitoring = false
	elif animated_sprite_2d.animation == "attack_4":
		if animated_sprite_2d.frame == 1:
			attack_hitbox_1.monitoring = true
			attack_hitbox_3.monitoring = true
		elif animated_sprite_2d.frame == 4:
			attack_hitbox_1.monitoring = false
			attack_hitbox_3.monitoring = false

func boss_hit() -> void:
	if is_dead:
		return  # Prevent further logic if already dead

	health -= 1
	print("Health: ", health)

	if health == 0:
		boss_dies()

func boss_dies() -> void:
	if is_dead:
		return  # Prevent multiple executions

	is_dead = true
	dialogue.stop()
	dialogue_2.play()

	# Stop ongoing animations and logic
	animated_sprite_2d.stop()
	is_attacking = false
	velocity = Vector2.ZERO
	attack_hitbox_1.monitoring = false
	attack_hitbox_2.monitoring = false
	attack_hitbox_3.monitoring = false

	# Play death animation
	animated_sprite_2d.play("death")
	await animated_sprite_2d.animation_finished

	# Transition to credits
	await get_tree().create_timer(1.5).timeout
	Transition.transition()
	await Transition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
	queue_free()
