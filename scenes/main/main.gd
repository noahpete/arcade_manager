class_name Main
extends Node

var state_machine: StateMachine = StateMachine.new()
var current_state: String:
	get:
		return state_machine.current_state
	set(value):
		state_machine.change_state(Callable.create(self, value))

var _grid_size: int

@onready var player: Player = %Player
@onready var grid_tile_map_layer: TileMapLayer = %Floor
@onready var y_sort_root: Node2D = $World/YSortRoot


func _init() -> void:
	state_machine.add_states(_state_free, _enter_state_free, Callable())
	state_machine.add_states(_state_layout, _enter_state_layout, Callable())


func _ready() -> void:
	Events.attraction_menu_option_selected.connect(_on_attraction_menu_option_selected)
	Events.attraction_place_requeseted.connect(_on_attraction_place_requested)
	state_machine.set_initial_state(_state_free)
	_grid_size = grid_tile_map_layer.tile_set.tile_size.x


func _process(delta: float) -> void:
	state_machine.update(delta)


func _state_free(_delta: float) -> void:
	pass


func _enter_state_free() -> void:
	player.set_physics_process(true)


func _state_layout(_delta: float) -> void:
	pass


func _enter_state_layout() -> void:
	player.set_physics_process(false)


func _on_attraction_menu_option_selected(data: AttractionData) -> void:
	current_state = "_state_layout"


func _on_attraction_place_requested(data: AttractionData, cell: Vector2i) -> void:
	# TODO: check if can place
	var can_place: bool = true
	if not can_place:
		return

	current_state = "_state_free"

	var attraction: Attraction = Attraction.create_attraction(data)
	attraction.global_position = cell * _grid_size
	y_sort_root.add_child(attraction)
