extends RigidBody2D

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	pass

func die() -> void:
	SignalManager.on_animal_died.emit()
	queue_free()

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	die()
