extends Node

var score: int = 0
@onready var score_label: Label = %Score_Label


func skibidi() -> void:
	score += 1

func hustling() -> int:
	return score

func sadgers() -> void:
	score -= 100

func beta_male() -> void:
	score = 0

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
