extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const ROLL_SPEED = 150
const ROLL_DURATION = 0.4
const ATTACK_DURATION = 0.4
const NORMAL_DECELERATION = 800.0
const SLIPPERY_DECELERATION = 150.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump: AudioStreamPlayer2D = $Jump
@onready var player: CharacterBody2D = $"." 
@onready var hurt: AudioStreamPlayer2D = $Hurt
@onready var attack_hitbox: Area2D = $Attack_Hitbox
@onready var attack: AudioStreamPlayer2D = $Attack
@onready var tile_map: TileMap = %TileMap
@onready var collision_shape: CollisionShape2D = $Attack_Hitbox/CollisionShape2D
@onready var game_manager: Node = %GameManager
@onready var timer: Timer = $Timer

var is_rolling = false
var roll_timer = 0.0
var is_dead = false
var is_attacking = false
var attack_timer = 0.0
var is_on_slippery_tile = false 
var speed_factor = 1.0
var jump_factor = 1.0
var can_revive = false
var can_roll = false
var can_attack = false
var can_double_jump = JumpState.can_double_jump
var jump_count = 0

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	if is_on_floor() and can_double_jump:
		jump_count = 0
	
	# Detect level and give abilities accordingly
	level_detector()
	
	# Detect slippery tiles
	detect_slippery_tile()

	# Detect muddy tiles
	detect_muddy_tile()
	
	# Rolling logic with gravity
	if is_rolling:
		roll_timer -= delta
		if not is_on_floor():
			velocity += get_gravity() * delta
		if roll_timer <= 0:
			stop_roll()
		else:
			move_and_slide()
			return

	# Attacking logic
	if is_attacking:
		attack_timer -= delta
		if not is_on_floor():
			velocity += get_gravity() * delta
		if attack_timer <= 0:
			stop_attack()
		else:
			move_and_slide()
			return

	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta * jump_factor

	# Get the input direction
	var direction := Input.get_axis("move_left", "move_right")

	# Rolling input
	if Input.is_action_just_pressed("roll") and is_on_floor() and can_roll:
		start_roll(direction)
		return

	# Jump input
	if not can_double_jump:
		if Input.is_action_just_pressed("jump") and not is_rolling and is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump.play()
	else:
		if Input.is_action_just_pressed("jump") and not is_rolling and jump_count < 2:
			velocity.y = JUMP_VELOCITY
			jump.play()
			jump_count += 1

	# Attack input
	if Input.is_action_just_pressed("attack") and can_attack:
		start_attack()
		return

	# Sprite flip and hitbox adjustment
	if direction > 0:
		animated_sprite_2d.flip_h = false
		attack_hitbox.scale = Vector2(1.0, 1.0)
	elif direction < 0:
		animated_sprite_2d.flip_h = true
		attack_hitbox.scale = Vector2(-1.0, 1.0)

	# Apply deceleration based on surface type
	if direction == 0:
		if is_on_slippery_tile:
			velocity.x = move_toward(velocity.x, 0, SLIPPERY_DECELERATION * delta)
		else:
			velocity.x = direction * SPEED * speed_factor
	else:
		if (velocity.x > 0 and direction < 0) or (velocity.x < 0 and direction > 0):
			if is_on_slippery_tile:
				velocity.x = move_toward(velocity.x, 0, SLIPPERY_DECELERATION * delta)
			else:
				velocity.x = direction * SPEED * speed_factor
		else:
			velocity.x = direction * SPEED * speed_factor # Apply horizontal movement

	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("jump")

	# Move and slide
	move_and_slide()

func start_roll(direction: float) -> void:
	if direction != 0:
		is_rolling = true
		roll_timer = ROLL_DURATION
		velocity.x = direction * ROLL_SPEED * speed_factor
		animated_sprite_2d.play("roll")
		print("Rolling!")
		player.set_collision_layer_value(2, false)
		player.set_collision_layer_value(3, true)

func stop_roll() -> void:
	is_rolling = false
	velocity.x = 0
	animated_sprite_2d.play("idle")
	player.set_collision_layer_value(2, true)
	player.set_collision_layer_value(3, false)
	print("Roll ended.")

func start_attack() -> void:
	if is_attacking:
		return
	is_attacking = true
	attack_timer = ATTACK_DURATION
	attack_hitbox.monitoring = true
	animated_sprite_2d.play("attack")
	attack.play()
	print("Attacking!")

func stop_attack() -> void:
	is_attacking = false
	attack_hitbox.monitoring = false
	animated_sprite_2d.play("idle")
	print("Attack ended!")

#Logic for the player dies
func player_dies() -> void:
	if is_dead:
		return

	is_dead = true
	print("Death")
	Input.action_release("move_left")
	Input.action_release("move_right")
	Input.action_release("jump")
	Input.action_release("roll")
	animated_sprite_2d.play("hurt")
	hurt.play()
	await hurt.finished
	Engine.time_scale = 0.5
	timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	if can_revive:
		get_tree().reload_current_scene()
	else:
		game_manager.fanum_tax()
		game_manager.beta_male()

#Detects if an enemy is in the player's attack hitbox and calls the enemy dying function
func _on_attack_hitbox_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Enemy"):
		parent.death()

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Boss"):
		body.boss_hit()
		#body.boss_dies()

# Detect if the player is on a slippery tile
func detect_slippery_tile() -> void:
	if not tile_map:  # Ensure the TileMap exists
		is_on_slippery_tile = false
		return

	var player_globalpos = global_position
	#var mouse_pos = get_global_mouse_position()
	#print(mouse_pos)
	var tile_data = get_tile_data(player_globalpos)
	if tile_data:
		var custom_data = tile_data.get_custom_data("is_slippery")
		if custom_data == true and is_on_floor():
			#print("Slippery ")
			is_on_slippery_tile = true
		else: is_on_slippery_tile = false
			#print(tile_coords)

#Detect if the player is on a muddy tile
func detect_muddy_tile() -> void:
	var player_globalpos = global_position
	var tile_data = get_tile_data(player_globalpos)
	if tile_data:
		var custom_data = tile_data.get_custom_data("is_muddy")
		if custom_data == true:
			speed_factor = 0.4
			jump_factor = 2.0
		elif is_on_floor() and custom_data == false: 
			speed_factor = 1.0
			jump_factor = 1.0

#Gets the tile data from the global player position
func get_tile_data(player_globalpos: Vector2) -> TileData:
	var feet_offset = collision_shape.shape.extents.y
	var feet_pos = player_globalpos + Vector2(0, feet_offset)
	var tile_localpos = tile_map.to_local(feet_pos)
	
	var tile_coords = tile_map.local_to_map(tile_localpos)
	tile_coords += Vector2i(0, 1)
	#print(tile_coords)
	var tile_data = tile_map.get_cell_tile_data(1, tile_coords)
	return tile_data

func revive_activator() -> void:
	can_revive = true

func level_detector() -> void:
	var scene_name = get_tree().current_scene.name
	scene_name = scene_name.substr(0, scene_name.length() - 1)
	if scene_name == "Level_1" or scene_name == "Level_2" or scene_name == "Level_3":
		JumpState.can_double_jump = false
		can_double_jump = JumpState.can_double_jump
	if scene_name == "Level_2":
		can_roll = true
	if scene_name == "Level_3" or scene_name == "Level_4":
		can_roll = true
		can_attack = true

func double_jump_activator() -> void:
	JumpState.can_double_jump = true
	can_double_jump = JumpState.can_double_jump
	
