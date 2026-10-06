class_name InteractableArea2D
extends Area2D

signal interacted()
signal focus_gained()
signal focus_lost()

static var _overlapping: Array[InteractableArea2D] = []
static var _focused: InteractableArea2D = null
static var _last_refresh_frame: int = -1

var _current_player: Node2D = null


func _ready() -> void:
	set_process(false)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _exit_tree() -> void:
	if self in _overlapping:
		_leave()


func _process(_delta: float) -> void:
	var frame: int = Engine.get_process_frames()
	if frame == _last_refresh_frame:
		return
	_last_refresh_frame = frame
	_refresh_focus(_current_player)


func _unhandled_input(event: InputEvent) -> void:
	if _focused == self and event.is_action_pressed("interact"):
		interact()
		get_viewport().set_input_as_handled()


func interact() -> void:
	interacted.emit()


static func _refresh_focus(player: Node2D) -> void:
	var nearest: InteractableArea2D = null
	var nearest_distance: float = INF
	for component: InteractableArea2D in _overlapping:
		var distance: float = component.global_position.distance_squared_to(player.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest = component
	if nearest == _focused:
		return
	if _focused:
		_focused.focus_lost.emit()
	_focused = nearest
	if _focused:
		_focused.focus_gained.emit()


func _leave() -> void:
	set_process(false)
	_overlapping.erase(self)
	if _focused == self:
		_focused = null
		focus_lost.emit()
	if _current_player:
		_refresh_focus(_current_player)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		_current_player = body
		_overlapping.append(self)
		set_process(true)
		_refresh_focus(body)


func _on_body_exited(body: Node2D) -> void:
	if body == _current_player:
		_leave()
		_current_player = null
