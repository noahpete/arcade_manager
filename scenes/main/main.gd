class_name Main
extends Node

const GRID_DIVISIONS: float = 2.0

var state_machine: StateMachine = StateMachine.new()
var current_state: String:
	get:
		return state_machine.current_state
	set(value):
		state_machine.change_state(Callable.create(self, value))

var _grid_size: int
var _attraction_preview: Attraction

@onready var _player: Player = %Player
@onready var _tile_map_layer: TileMapLayer = %Ground
@onready var _props: Node2D = %Props


func _init() -> void:
	state_machine.add_states(_state_free, _enter_state_free, Callable())
	state_machine.add_states(_state_layout, _enter_state_layout, Callable())


func _ready() -> void:
	Events.attraction_menu_option_selected.connect(_on_attraction_menu_option_selected)

	state_machine.set_initial_state(_state_free)

	_grid_size = int(_tile_map_layer.tile_set.tile_size.x / GRID_DIVISIONS)


func _process(delta: float) -> void:
	state_machine.update(delta)


func _unhandled_input(event: InputEvent) -> void:
	if current_state != "_state_layout":
		return
	if event.is_action_pressed("layout_accept"):
		_try_place_attraction(_attraction_preview.get_data(), _get_mouse_tile())
		get_viewport().set_input_as_handled()


func _state_free(_delta: float) -> void:
	pass


func _enter_state_free() -> void:
	_player.set_physics_process(true)


func _state_layout(_delta: float) -> void:
	_attraction_preview.global_position = _get_mouse_tile() * _grid_size


func _enter_state_layout() -> void:
	_player.set_physics_process(false)


func _create_preview(data: AttractionData) -> void:
	_attraction_preview = Attraction.create_attraction(data, true)
	_props.add_child(_attraction_preview)


func _destroy_preview() -> void:
	if _attraction_preview == null:
		return
	_attraction_preview.queue_free()


func _get_mouse_tile() -> Vector2i:
	var mouse_position: Vector2 = _tile_map_layer.get_global_mouse_position()
	return _convert_world_position_to_tile(mouse_position)


func _convert_world_position_to_tile(world_position: Vector2) -> Vector2i:
	var tile_position: Vector2 = (world_position / _grid_size).floor()
	return Vector2i(tile_position.x as int, tile_position.y as int)


func _on_attraction_menu_option_selected(data: AttractionData) -> void:
	_create_preview(data)

	current_state = "_state_layout"


func _try_place_attraction(data: AttractionData, cell: Vector2i) -> void:
	# TODO: check if can place
	var can_place: bool = true
	if not can_place:
		return

	var attraction: Attraction = Attraction.create_attraction(data)
	attraction.global_position = cell * _grid_size
	_props.add_child(attraction)

	_destroy_preview()

	current_state = "_state_free"
