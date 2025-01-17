extends AnimatableBody2D

const SPEED = 300.0
const SHAKE_SPEED = 40.0  # Lower value = slower shaking
const SHAKE_AMPLITUDE = .2  # Controls how far it shakes horizontally

@onready var area_2d: Area2D = $Area2D
@onready var timer: Timer = $Timer
@onready var sprite_2d: Sprite2D = $Sprite2D

var is_falling = false
var time = 0.0  # Use a float for finer control

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	if not is_falling:
		time += delta * SHAKE_SPEED  # Increment time more slowly
		sprite_2d.position.x += sin(time) * SHAKE_AMPLITUDE  # Shake horizontally
	else:
		position.y += SPEED * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	set_process(true)
	timer.start()

func _on_timer_timeout() -> void:
	is_falling = true

func reset() -> void:
	time = 0.0
	is_falling = false
	set_process(false)
	timer.stop()
