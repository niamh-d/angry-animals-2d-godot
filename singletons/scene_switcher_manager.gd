extends Node

const NUM_LEVELS: int = 3

var _current_level: int = 1

const MAIN_SCENE: PackedScene = preload("res://scenes/main/main.tscn")

func set_current_level(level_num: int) -> void:
	_current_level = level_num

func get_current_level() -> int:
	return _current_level

func load_main_scene() -> void:
	get_tree().change_scene_to_packed(MAIN_SCENE)
	
func reload_level() -> void:
	load_level(_current_level)

func load_level(level_num: int) -> void:
	var level = load("res://scenes/level/level_%s.tscn" % str(level_num))
	get_tree().change_scene_to_packed(level)

func load_next_level() -> void:
	if(_current_level == NUM_LEVELS):
		load_main_scene()
	else:
		_current_level += 1
		load_level(_current_level)
	
