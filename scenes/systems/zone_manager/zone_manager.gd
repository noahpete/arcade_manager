class_name ZoneManager
extends TileMapLayer

signal zone_changed(new_zone: StringName, old_zone: StringName)

const NO_ZONE: StringName = &"none"

@export var _player: Player

var _current_zone: StringName = NO_ZONE
var _last_cell: Vector2i = Vector2i(INT64_MAX, INT64_MAX)


func _process(_delta: float) -> void:
	var cell: Vector2i = local_to_map(to_local(_player.global_position))
	if cell == _last_cell:
		return
	refresh(cell)


func get_zone_at(cell: Vector2i) -> StringName:
	var tile_data: TileData = get_cell_tile_data(cell)
	if tile_data == null:
		return NO_ZONE
	return StringName(tile_data.get_custom_data("zone"))


func refresh(new_cell: Vector2i) -> void:
	var new_zone: StringName = get_zone_at(new_cell)
	var old_zone: StringName = _current_zone
	if new_zone == _current_zone:
		return
	_current_zone = new_zone
	_last_cell = new_cell
	zone_changed.emit(new_zone, old_zone)
