extends Control

const MAIN: PackedScene = preload("res://scenes/main/main.tscn")

@onready var level_label: Label = $MarginContainer/VB/LevelLabel
@onready var attempts_label: Label = $MarginContainer/VB/AttemptsLabel
@onready var vb_2: VBoxContainer = $MarginContainer/VB2
@onready var game_over_sound: AudioStreamPlayer = $GameOverSound

func _ready() -> void:
	level_label.text = "Level %s" % ScoreManager.get_level_selected()
	update_attempts(0)
	SignalManager.on_score_updated.connect(update_attempts)
	SignalManager.on_level_completed.connect(on_level_completed)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		get_tree().change_scene_to_packed(MAIN)

func update_attempts(attempts: int) -> void:
	attempts_label.text = "Tries: %s" % attempts

func on_level_completed() -> void:
	vb_2.show()
	game_over_sound.play()
	
