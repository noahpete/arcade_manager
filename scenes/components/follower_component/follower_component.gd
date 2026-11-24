class_name FollowerComponent
extends Node2D
## Moves this node's parent so that it follows [target], but
## only once the target leaves a dead zone around the parent.

@export var show_dead_zone: bool = false
@export var target: Node2D
@export var offset: Vector2 = Vector2.ZERO
@export var dead_zone_size: Vector2 = Vector2.ZERO
@export_range(0.0, 2.0, 0.01, "or_greater") var smoothing: float = 0.4

@onready var _parent: Node2D = get_parent() as Node2D


func _ready() -> void:
	assert(_parent != null, "Follower's parent must be a Node2D.")
	assert(target != null, "Follower needs a target assigned.")
	assert(dead_zone_size.x >= 0.0 and dead_zone_size.y >= 0.0, "dead_zone_size can't be negative.")

	_parent.global_position = target.global_position + offset
	queue_redraw()


func _process(delta: float) -> void:
	if not is_instance_valid(target):
		return

	var to_target: Vector2 = target.global_position + offset - _parent.global_position
	var half_zone: Vector2 = dead_zone_size / 2.0

	var overshoot: Vector2 = to_target - to_target.clamp(-half_zone, half_zone)
	var goal: Vector2 = _parent.global_position + overshoot

	if is_zero_approx(smoothing):
		_parent.global_position = goal
		return

	var weight: float = 1.0 - exp(-delta / smoothing)
	_parent.global_position = _parent.global_position.lerp(goal, weight)


func _draw() -> void:
	if show_dead_zone:
		draw_rect(Rect2(-dead_zone_size / 2.0 - offset, dead_zone_size), Color.RED, false)
