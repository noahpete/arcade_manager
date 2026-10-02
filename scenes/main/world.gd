class_name World
extends Node2D

@onready var floor_layer: TileMapLayer = $TileMap/Floor
@onready var y_sort_root: Node2D = $YSortRoot

var occupied: Dictionary[Vector2i, Node2D] = { }


func world_to_cell(world_pos: Vector2) -> Vector2i:
	return floor_layer.local_to_map(floor_layer.to_local(world_pos))


func cell_to_world(cell: Vector2i) -> Vector2:
	return floor_layer.to_global(floor_layer.map_to_local(cell))


func can_place_prop(cell: Vector2i) -> bool:
	return floor_layer.get_cell_source_id(cell) != -1 and not occupied.has(cell)


func place_prop(prop: StaticBody2D, cell: Vector2i) -> void:
	if not can_place_prop(cell):
		return
	y_sort_root.add_child(prop)
	prop.global_position = cell_to_world(cell)
	occupied[cell] = prop
	prop.tree_exited.connect(
		func():
			occupied.erase(cell),
	)
