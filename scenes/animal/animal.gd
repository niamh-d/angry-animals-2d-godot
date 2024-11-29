extends RigidBody2D

enum ANIMAL_STATE {READY, DRAG, RELEASE}

const DRAG_LIMIT_MAX: Vector2 = Vector2(0, 60)
const DRAG_LIMIT_MIN: Vector2 = Vector2(-60, 0)
const IMPULSE_MULT: float = 20.0
const IMPULSE_MAX: float = 1200.0

var _start: Vector2 = Vector2.ZERO
var _drag_start: Vector2 = Vector2.ZERO
var _dragged_vector: Vector2 = Vector2.ZERO
var _last_dragged_vector: Vector2 = Vector2.ZERO
var _state: ANIMAL_STATE
var _arrow_scale_x: float = 0.0

@onready var arrow: Sprite2D = $Arrow
@onready var stretch_sound: AudioStreamPlayer2D = $StretchSound
@onready var launch_sound: AudioStreamPlayer2D = $LaunchSound

func _ready() -> void:
	_arrow_scale_x = arrow.scale.x
	arrow.hide()
	_state = ANIMAL_STATE.READY
	_start = position

func _physics_process(delta: float) -> void:
	update(delta)

func get_impulse() -> Vector2:
	return _dragged_vector * -1 * IMPULSE_MULT

func set_drag() -> void:
		_drag_start = get_global_mouse_position()
		arrow.show()

func set_release() -> void:
		arrow.hide()
		freeze = false
		apply_central_impulse(get_impulse())
		launch_sound.play()

func set_new_state(new_state: ANIMAL_STATE) -> void:
	_state = new_state
	if _state == ANIMAL_STATE.RELEASE:
		set_release()
	elif _state == ANIMAL_STATE.DRAG:
		set_drag()

func detect_release() -> bool:
	if _state == ANIMAL_STATE.DRAG:
		if Input.is_action_just_released("drag"):
			set_new_state(ANIMAL_STATE.RELEASE)
			return true
	return false

func scale__and_rotate_arrow() -> void:
	var impulse_len: float = get_impulse().length()
	var perc = impulse_len / IMPULSE_MAX
	arrow.scale.x = (_arrow_scale_x * perc) + _arrow_scale_x
	arrow.rotation = (_start - position).angle()

func play_stretch_sound() -> void:
	if(_last_dragged_vector - _dragged_vector).length() > 0:
		if !stretch_sound.playing:
			stretch_sound.play()

func get_dragged_vector(gmp: Vector2) -> Vector2:
	return gmp - _drag_start
	
func drag_within_limits() -> void:
	_last_dragged_vector = _dragged_vector
	
	_dragged_vector.x = clampf(
		_dragged_vector.x,
		DRAG_LIMIT_MIN.x,
		DRAG_LIMIT_MAX.x
	)
	_dragged_vector.y = clampf(
		_dragged_vector.y,
		DRAG_LIMIT_MIN.y,
		DRAG_LIMIT_MAX.y
	)
	position = _start + _dragged_vector

func update_drag() -> void:
	if detect_release():
		return
		
	var global_mouse_pos: Vector2 = get_global_mouse_position()
	_dragged_vector = get_dragged_vector(global_mouse_pos)
	play_stretch_sound()
	drag_within_limits()
	scale__and_rotate_arrow()

func update(delta: float) -> void:
	match _state:
		ANIMAL_STATE.DRAG:
			update_drag()

func die() -> void:
	SignalManager.on_animal_died.emit()
	queue_free()

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	die()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if _state == ANIMAL_STATE.READY && event.is_action_pressed("drag"):
		set_new_state(ANIMAL_STATE.DRAG)
