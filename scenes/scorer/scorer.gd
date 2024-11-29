extends Node

var _num_attempts: int = 0
var _cups_hit: int = 0
var _total_cups: int = 0
var _level_num: int = 1

func _ready() -> void:
	_total_cups = get_tree().get_nodes_in_group("cup").size()
	_level_num = ScoreManager.get_level_selected()
	SignalManager.on_attempt_made.connect(on_attempt_made)
	SignalManager.on_cup_destroyed.connect(on_cup_destroyed)
	
func on_attempt_made() -> void:
	_num_attempts += 1
	SignalManager.on_score_updated.emit(_num_attempts)
	
func on_cup_destroyed() -> void:
	_cups_hit += 1
	if _cups_hit == _total_cups:
		SignalManager.on_level_completed.emit()
		ScoreManager.set_score_for_level(_num_attempts, str(_level_num))
