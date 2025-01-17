extends CharacterBody2D

const SPEED = 90.0
const ATTACK_RANGE = 60.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_hitbox_1: Area2D = $"Attack Hitbox_1"
@onready var attack_hitbox_2: Area2D = $"Attack Hitbox_2"
@onready var attack_hitbox_3: Area2D = $"Attack Hitbox_3"
@onready var agro_zone: Area2D = $"Agro Zone"
@onready var timer: Timer = $Timer
@onready var game_manager: Node = %GameManager

var player: CharacterBody2D = null
var is_attacking = false
var player_is_dead = false
var health = 10

func _physics_process(delta: float) -> void:
	if player:
		# Calculate horizontal and vertical distances
		var horizontal_dist = abs(global_position.x - player.global_position.x)
		var vertical_dist = abs(global_position.y - player.global_position.y)

		# Debug distances
		#print("Horizontal Distance:", horizontal_dist)
		#print("Vertical Distance:", vertical_dist)

		# Check if the player is close horizontally and vertically
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
	if is_attacking:
		return  # Prevent starting a new attack while already attacking
	is_attacking = true
	velocity.x = 0
	if vertical_dist > 40:
		#print("UP")
		animated_sprite_2d.play("attack_4")
	else:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var att_type = rng.randi_range(0, 9)
		#print(att_type)
		if att_type < 5:
			animated_sprite_2d.play("attack_1")
		elif att_type < 8 and att_type >= 5:
			animated_sprite_2d.play("attack_2")
		elif att_type >= 8:
			animated_sprite_2d.play("attack_3")

	await animated_sprite_2d.animation_finished
	is_attacking = false

func _on_agro_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body

func _on_agro_zone_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		animated_sprite_2d.play("idle")

func _on_attack_hitbox_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("death")
		Engine.time_scale = 0.5
		body.player_dies()
		player_is_dead = true
		timer.start(1.0)

func _on_attack_hitbox_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("death")
		Engine.time_scale = 0.5
		body.player_dies()
		player_is_dead = true
		timer.start(1.0)

func _on_attack_hitbox_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("death")
		Engine.time_scale = 0.5
		body.player_dies()
		player_is_dead = true
		timer.start(1.0)

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	game_manager.fanum_tax()

func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite_2d == null:
		print("animated_sprite_2d is null")
		return

	if animated_sprite_2d.animation == "attack_1":
		if animated_sprite_2d.frame == 6:
			attack_hitbox_1.monitoring = true
			#print("Attack hitbox monitoring started!")
		elif animated_sprite_2d.frame == 8:
			attack_hitbox_1.monitoring = false
			#print("Attack hitbox monitoring stopped!")
	elif animated_sprite_2d.animation == "attack_2":
		if animated_sprite_2d.frame == 2:
			attack_hitbox_1.monitoring = true
			attack_hitbox_2.monitoring = true
			#print("Attack hitbox monitoring started!")
		elif animated_sprite_2d.frame == 4:
			attack_hitbox_1.monitoring = false
			attack_hitbox_2.monitoring = false
			#print("Attack hitbox monitoring stopped!")
	elif animated_sprite_2d.animation == "attack_3":
		if animated_sprite_2d.frame == 4:
			attack_hitbox_1.monitoring = true
			attack_hitbox_3.monitoring = true
			#print("Attack hitbox monitoring started!")
		elif animated_sprite_2d.frame == 7:
			attack_hitbox_1.monitoring = false
			attack_hitbox_3.monitoring = false
			#print("Attack hitbox monitoring stopped!")
	elif animated_sprite_2d.animation == "attack_4":
		if animated_sprite_2d.frame == 1:
			attack_hitbox_1.monitoring = true
			attack_hitbox_3.monitoring = true
			#print("Attack hitbox monitoring started!")
		elif animated_sprite_2d.frame == 4:
			attack_hitbox_1.monitoring = false
			attack_hitbox_3.monitoring = false
			#print("Attack hitbox monitoring stopped!")

func boss_hit() -> void:
	#animated_sprite_2d.play("damaged")
	#await animated_sprite_2d.animation_finished
	health -= 1
	print("Health: ", health)
	if health == 0:
		boss_dies()

func boss_dies() -> void:
	animated_sprite_2d.play("death")
	await animated_sprite_2d.animation_finished
	queue_free()
