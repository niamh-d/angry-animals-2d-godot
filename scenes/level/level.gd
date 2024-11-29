extends Node2D

const ANIMAL: PackedScene = preload("res://scenes/animal/animal.tscn")
@onready var animal_start: Marker2D = $AnimalStart

const MAIN = preload("res://scenes/main/main.tscn")

func _ready() -> void:
	SignalManager.on_animal_died.connect(add_animal)
	add_animal()

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_packed(MAIN)		
	
func add_animal() -> void:
	var pos: Vector2 = animal_start.position
	var animal: RigidBody2D = ANIMAL.instantiate()
	animal.position = pos
	add_child(animal)
