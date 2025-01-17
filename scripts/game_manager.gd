extends Node

var score = 0
@onready var score_label: Label = $Score_Label

func skibidi():
	score += 1
	score_label.text = "You Have Collected " + str(score) + " Virginity Points"

func fanum_tax():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var level_type = rng.randi_range(0, 8)
	if level_type <= 2:
		get_tree().change_scene_to_file("res://scenes/level_1A.tscn")
	elif level_type > 2 and level_type <= 5:
		get_tree().change_scene_to_file("res://scenes/level_1B.tscn")
	elif level_type > 5 and level_type <= 8:
		get_tree().change_scene_to_file("res://scenes/level_1C.tscn")

func linganguli():
	get_tree().change_scene_to_file("res://scenes/level_2A.tscn")
