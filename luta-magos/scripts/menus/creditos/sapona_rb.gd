extends RigidBody2D

@export var follow_strength: float = 20.0   # how snappy the follow feels
@export var max_speed: float = 800.0        # clamp so it doesn't fling through thin walls
@export var release_damping: float = 1.0    # linear_damp to restore after release

var is_dragging: bool = false
var _original_damp: float

func _ready() -> void:
	_original_damp = linear_damp

func _input(event: InputEvent) -> void:
	# Check for mouse button press
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Try to pick up the body
				try_pick_up()
			else:
				# Release the body
				is_dragging = false

func try_pick_up() -> void:
	if get_global_mouse_position().distance_to(global_position) < 250:
		is_dragging = true

#func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#if event.pressed:
			#is_dragging = true
			#linear_damp = 10.0   # extra resistance while held, feels less floaty
#
#func _unhandled_input(event: InputEvent) -> void:
	## catch release even if mouse has moved off the shape
	#if is_dragging and event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			#is_dragging = false
			#linear_damp = _original_damp

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if is_dragging:
		var to_mouse: Vector2 = get_global_mouse_position() - global_position
		var desired_velocity: Vector2 = to_mouse * follow_strength
		if desired_velocity.length() > max_speed:
			desired_velocity = desired_velocity.normalized() * max_speed
		state.linear_velocity = desired_velocity
		state.angular_velocity = 0.0
	# when not dragging, normal physics (gravity, collisions, etc.) just applies
