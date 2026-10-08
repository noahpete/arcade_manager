class_name Grid
extends RefCounted

var cell_size: int


func _init(tile_size: int, divisions: float = 1.0) -> void:
	cell_size = int(tile_size / divisions)


func world_to_cell(world_position: Vector2) -> Vector2i:
	return Vector2i((world_position / cell_size).floor())


func cell_to_world(cell: Vector2i) -> Vector2:
	return Vector2(cell * cell_size)
