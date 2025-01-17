extends Node2D

const SPEED = 60
const GRAV = 980
const TERM_VELOCITY = 300

var dir = 1
var vertical_velocity = 0

@onready var timer: Timer = $Timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_sound: AudioStreamPlayer2D = $Death
@onready var coin: AudioStreamPlayer2D = $Coin
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var area_2d: Area2D = $Area2D
@onready var game_manager: Node = %GameManager

func _physics_process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		dir = -1
		animated_sprite_2d.flip_h = true
	
	if ray_cast_left.is_colliding():
		dir = 1
		animated_sprite_2d.flip_h = false
	
	position.x += dir * SPEED * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#print("Death")
		Engine.time_scale = 0.5
		body.player_dies()
		timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	game_manager.fanum_tax()

func death() -> void:
	print("Hit!")
	dir = 0
	ray_cast_right.enabled = false
	ray_cast_left.enabled = false
	area_2d.monitoring = false
	
	death_sound.play()
	coin.play()
	game_manager.skibidi()
	animated_sprite_2d.play("death")
	await animated_sprite_2d.animation_finished
	queue_free()
