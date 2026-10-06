class_name Player
extends CharacterBody2D

const MAX_MOVE_SPEED: float = 60.0
const BLEND_SPEED: float = 8.0

@onready var _animation_tree: AnimationTree = $AnimationTree
@onready var _visuals: Node2D = $Visuals


func _physics_process(delta: float) -> void:
	var movement_vector: Vector2 = Input.get_vector("left", "right", "up", "down")

	_update_visuals(delta, movement_vector)

	velocity = movement_vector * MAX_MOVE_SPEED
	move_and_slide()


func _update_visuals(delta: float, movement_vector: Vector2) -> void:
	var target_blend: float = 1.0 if movement_vector.length() > 0.0 else 0.0
	var current_blend: float = _animation_tree["parameters/movement/blend_position"]
	_animation_tree["parameters/movement/blend_position"] = move_toward(
		current_blend,
		target_blend,
		BLEND_SPEED * delta,
	)

	if not movement_vector.x == 0.0:
		_visuals.scale.x = 1 if movement_vector.x >= 0 else -1
