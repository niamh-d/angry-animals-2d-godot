extends Node

const DEFAULT_SCORE: int = 100

var _level_selected: int = 1
var _level_scores: Dictionary = {}

func _ready() -> void:
	pass # Replace with function body.

func set_level_selected(ls: int) -> void:
	_level_selected = ls

func get_level_selected() -> int:
	return _level_selected

func check_and_add(level: String) -> void:
	if !_level_scores.has(level):
		_level_scores[level] = DEFAULT_SCORE 

func set_score_for_level(score: int, level: String) -> void:
	check_and_add(level)
	if _level_scores[level] > score:
		_level_scores[level] = score

func get_best_score_for_level(level: String) -> int:
		check_and_add(level)
		return _level_scores[level]
	
