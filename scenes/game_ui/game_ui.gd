extends Control

@onready var level_label: Label = $MarginContainer/VB/LevelLabel
@onready var attempts_label: Label = $MarginContainer/VB/AttemptsLabel
@onready var vb_2: VBoxContainer = $MarginContainer/VB2
@onready var game_over_sound: AudioStreamPlayer = $GameOverSound

func _ready() -> void:
	level_label.text = "Level %s" % SceneSwitcherManager.get_current_level()
	update_attempts(0)
	SignalManager.on_num_tries_updated.connect(update_attempts)
	SignalManager.on_level_completed.connect(on_level_completed)
	
func _process(delta: float) -> void:
	listen_for_keypresses()

func update_attempts(attempts: int) -> void:
	attempts_label.text = "Tries: %s" % attempts

func on_level_completed() -> void:
	vb_2.show()
	game_over_sound.play()
	
func listen_for_keypresses() -> void:
	if Input.is_action_just_pressed("next"):
		SceneSwitcherManager.load_next_level()
	if Input.is_action_just_pressed("menu"):
		SceneSwitcherManager.load_main_scene()
	if Input.is_action_just_pressed("reset"):
		SceneSwitcherManager.reload_level()
