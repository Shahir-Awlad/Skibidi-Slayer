extends Control

@onready var game_manager: Node = %GameManager
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var optionsMenu = preload("res://scenes/pause_menu.tscn")

func _ready() -> void:
	animation_player.play("RESET")

func _process(delta: float) -> void:
	useESC()

func resume() -> void:
	get_tree().paused = false
	animation_player.play_backwards("blur")

func pause() -> void:
	get_tree().paused = true
	animation_player.play("blur")

func useESC() -> void:
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()

func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	resume()
	game_manager.fanum_tax()

func _on_button_pressed() -> void:
	get_tree().quit()
