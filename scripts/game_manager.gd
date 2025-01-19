extends Node

var score: int = JumpState.coins
@onready var score_label: Label = %Score_Label


func skibidi() -> void:
	JumpState.coins += 1
	score = JumpState.coins

func hustling() -> int:
	score = JumpState.coins
	return score

func sadgers() -> void:
	JumpState.coins -= 50
	score -= JumpState.coins

func beta_male() -> void:
	JumpState.coins = 0
	score = JumpState.coins

func fanum_tax() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var level_type = rng.randi_range(0, 8)
	Transition.transition()
	await Transition.on_transition_finished
	if level_type <= 2:
		get_tree().change_scene_to_file("res://scenes/level_1A.tscn")
	elif level_type > 2 and level_type <= 5:
		get_tree().change_scene_to_file("res://scenes/level_1B.tscn")
	elif level_type > 5 and level_type <= 8:
		get_tree().change_scene_to_file("res://scenes/level_1C.tscn")

func linganguli() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var level_type = rng.randi_range(0, 8)
	Transition.transition()
	await Transition.on_transition_finished
	if level_type <= 2:
		get_tree().change_scene_to_file("res://scenes/level_2A.tscn")
	elif level_type > 2 and level_type <= 5:
		get_tree().change_scene_to_file("res://scenes/level_2B.tscn")
	elif level_type > 5 and level_type <= 8:
		get_tree().change_scene_to_file("res://scenes/level_2C.tscn")

func hawktuah() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var level_type = rng.randi_range(0, 8)
	Transition.transition()
	await Transition.on_transition_finished
	if level_type <= 2:
		get_tree().change_scene_to_file("res://scenes/level_3A.tscn")
	elif level_type > 2 and level_type <= 5:
		get_tree().change_scene_to_file("res://scenes/level_3B.tscn")
	elif level_type > 5 and level_type <= 8:
		get_tree().change_scene_to_file("res://scenes/level_3C.tscn")
