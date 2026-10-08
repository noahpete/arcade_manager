class_name AttractionManager
extends Node

const GRID_DIVISIONS: float = 2.0
const MOUSE_OFFSET: Vector2 = Vector2(0.0, 10.0)

@export var _ground: TileMapLayer
@export var _props_root: Node2D

var _grid: Grid
var _preview: Attraction


func _ready() -> void:
	Events.attraction_menu_option_selected.connect(_on_attraction_menu_option_selected)
	_grid = Grid.new(_ground.tile_set.tile_size.x, GRID_DIVISIONS)
	_set_active(false)


func _process(_delta: float) -> void:
	if _preview == null:
		return
	_preview.process_preview(_get_snapped_position())


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("layout_accept"):
		_try_place()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_cancel"):
		_end_layout()
		get_viewport().set_input_as_handled()


func _set_active(active: bool) -> void:
	set_process(active)
	set_process_unhandled_input(active)


func _convert_world_position_to_tile(world_position: Vector2) -> Vector2i:
	var tile_position: Vector2 = (world_position / _grid.cell_size).floor()
	return Vector2i(tile_position.x as int, tile_position.y as int)


func _get_mouse_tile() -> Vector2i:
	var mouse_position: Vector2 = _props_root.get_global_mouse_position()
	return _convert_world_position_to_tile(mouse_position + MOUSE_OFFSET)


func _get_snapped_position() -> Vector2:
	return Vector2(_get_mouse_tile()) * _grid.cell_size


func _create_preview(data: AttractionData) -> void:
	_preview = Attraction.create_attraction(data, true)
	_props_root.add_child(_preview)


func _try_place() -> void:
	if _preview == null:
		return

	var world_position: Vector2 = _get_snapped_position()
	if not _preview.is_valid_at(world_position):
		return

	var attraction: Attraction = Attraction.create_attraction(_preview.get_data())
	attraction.global_position = world_position
	_props_root.add_child(attraction)

	_end_layout()


func _end_layout() -> void:
	if _preview != null:
		_preview.queue_free()
		_preview = null
	_set_active(false)
	Events.attraction_layout_finished.emit()


func _on_attraction_menu_option_selected(data: AttractionData) -> void:
	if _preview != null:
		_preview.queue_free()
		_preview = null
	_create_preview(data)
	_set_active(true)
