class_name Main
extends Node

const GRID_DIVISIONS: float = 2.0
const GRID_MOUSE_OFFSET: Vector2 = Vector2(0.0, 10.0)
const ATTRACTION_COLLISION_LAYER: int = 1 << 4 # Layer 5 (value 16)
const FADE_ANIMATION_DURATION: float = 0.2
const FADE_WALL_OPACITY: float = 0.2

var state_machine: StateMachine = StateMachine.new()
var current_state: String:
	get:
		return state_machine.current_state
	set(value):
		state_machine.change_state(Callable.create(self, value))

var _grid_size: int
var _attraction_preview: Attraction

@onready var _player: Player = %Player
@onready var _ground: TileMapLayer = %Ground
@onready var _structures: TileMapLayer = %Structures
@onready var _props_root: Node2D = %Props
@onready var _zone_manager: ZoneManager = %ZoneManager


func _init() -> void:
	state_machine.add_states(_state_free, _state_free_input, _enter_state_free, Callable())
	state_machine.add_states(_state_layout, _state_layout_input, _enter_state_layout, Callable())


func _ready() -> void:
	Events.attraction_menu_option_selected.connect(_on_attraction_menu_option_selected)
	_zone_manager.zone_changed.connect(_on_zone_changed)

	state_machine.set_initial_state(_state_free)

	_grid_size = int(_ground.tile_set.tile_size.x / GRID_DIVISIONS)


func _process(delta: float) -> void:
	state_machine.process(delta)


func _unhandled_input(event: InputEvent) -> void:
	state_machine.unhandled_input(event)


func _state_free(_delta: float) -> void:
	pass


func _state_free_input(_event: InputEvent) -> void:
	pass


func _enter_state_free() -> void:
	_player.set_physics_process(true)


func _state_layout(_delta: float) -> void:
	var world_position: Vector2 = _get_mouse_tile() * _grid_size
	_attraction_preview.global_position = world_position
	_attraction_preview.set_valid(_can_place_attraction(_attraction_preview, world_position))


func _enter_state_layout() -> void:
	_player.set_physics_process(false)


func _state_layout_input(event: InputEvent) -> void:
	if event.is_action_pressed("layout_accept"):
		_try_place_attraction(_attraction_preview.get_data(), _get_mouse_tile())
		get_viewport().set_input_as_handled()


func _create_preview(data: AttractionData) -> void:
	_attraction_preview = Attraction.create_attraction(data, true)
	_props_root.add_child(_attraction_preview)


func _destroy_preview() -> void:
	if _attraction_preview == null:
		return
	_attraction_preview.queue_free()


func _get_mouse_tile() -> Vector2i:
	var mouse_position: Vector2 = _ground.get_global_mouse_position()
	return _convert_world_position_to_tile(mouse_position + GRID_MOUSE_OFFSET)


func _convert_world_position_to_tile(world_position: Vector2) -> Vector2i:
	var tile_position: Vector2 = (world_position / _grid_size).floor()
	return Vector2i(tile_position.x as int, tile_position.y as int)


func _try_place_attraction(data: AttractionData, cell: Vector2i) -> void:
	var world_position: Vector2 = cell * _grid_size
	if not _can_place_attraction(_attraction_preview, world_position):
		return

	var attraction: Attraction = Attraction.create_attraction(data)
	attraction.global_position = world_position

	_props_root.add_child(attraction)

	_destroy_preview()

	current_state = "_state_free"


func _can_place_attraction(attraction: Attraction, world_position: Vector2) -> bool:
	var query: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	query.shape = attraction.get_collision_shape()
	query.transform = Transform2D(0.0, world_position + attraction.get_collision_offset())
	query.collision_mask = ATTRACTION_COLLISION_LAYER
	query.collide_with_bodies = true
	query.collide_with_areas = false

	var space_state: PhysicsDirectSpaceState2D = _props_root.get_world_2d().direct_space_state
	return space_state.intersect_shape(query, 1).is_empty()


func _fade_walls(alpha: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(_structures, "modulate:a", alpha, FADE_ANIMATION_DURATION)


func _on_attraction_menu_option_selected(data: AttractionData) -> void:
	_create_preview(data)

	current_state = "_state_layout"


func _on_zone_changed(new_zone: StringName, _old_zone: StringName = &"none") -> void:
	match new_zone:
		&"arcade":
			_fade_walls(FADE_WALL_OPACITY)
		&"none":
			_fade_walls(1.0)
