extends Node

const PTS_PER_ATTEMPT = 100
const ATTEMPTS_MULT = 5

var _num_attempts: int = 0
var _cups_hit: int = 0
var _total_cups: int = 0
var _level_num: int = 1
var _max_attempts_for_scoring: int
var _total_scorable_pts: int

func _ready() -> void:
	_total_cups = get_tree().get_nodes_in_group("cup").size()
	_max_attempts_for_scoring = _total_cups * ATTEMPTS_MULT
	_total_scorable_pts = _max_attempts_for_scoring * PTS_PER_ATTEMPT
	_level_num = SceneSwitcherManager.get_current_level()
	SignalManager.on_attempt_made.connect(on_attempt_made)
	SignalManager.on_cup_destroyed.connect(on_cup_destroyed)
	
func on_attempt_made() -> void:
	_num_attempts += 1
	SignalManager.on_num_tries_updated.emit(_num_attempts)

func calculate_score_for_level() -> int:
	var pts = _total_scorable_pts - (PTS_PER_ATTEMPT * _num_attempts)
	return pts if pts > 0 else 0
	
func on_cup_destroyed() -> void:
	_cups_hit += 1
	if _cups_hit == _total_cups:
		SignalManager.on_level_completed.emit()
		ScoreManager.set_score_for_level(calculate_score_for_level(), str(_level_num))
