extends TextureButton

const HOVER_SCALE: Vector2 = Vector2(1.1, 1.1)
const DEFAULT_SCALE: Vector2 = Vector2(1.0, 1.0)

@export var level_num: int = 1

@onready var level_label: Label = $MC/VBoxContainer/LevelLabel
@onready var score_label: Label = $MC/VBoxContainer/ScoreLabel

var _level_scene: PackedScene

func _ready() -> void:
	level_label.text = str(level_num)
	var best_score = ScoreManager.get_best_score_for_level(str(level_num))
	score_label.text = str(best_score)
	_level_scene = load("res://scenes/level/level_%s.tscn" % level_num)

func _on_pressed() -> void:
	SceneSwitcherManager.set_current_level(level_num)
	SceneSwitcherManager.load_level(level_num)

func _on_mouse_entered() -> void:
	scale = HOVER_SCALE

func _on_mouse_exited() -> void:
	scale = DEFAULT_SCALE
