class_name Attraction
extends StaticBody2D

const ATTRACTION_COLLISION_LAYER: int = 1 << 4 # Layer 5 (value 16)
const PREVIEW_VALID_COLOR: Color = Color(1.0, 1.0, 1.0, 0.5)
const PREVIEW_INVALID_COLOR: Color = Color(1.0, 0.3, 0.3, 0.5)

var _data: AttractionData
var _is_preview: bool = false

@onready var interactable_area_2d: InteractableArea2D = $InteractableArea2D
@onready var outlined_sprite_2d: OutlinedSprite2D = $OutlinedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


static func create_attraction(data: AttractionData, is_preview: bool = false) -> Attraction:
	var attraction: Attraction = null
	match data.id:
		"cabinet":
			attraction = Cabinet.create()
		"pinball":
			attraction = Pinball.create()
		_:
			push_error("Unknown Attraction id")
	attraction._data = data
	attraction._is_preview = is_preview
	if not is_preview:
		attraction.add_to_group("attractions")
	return attraction


func _ready() -> void:
	interactable_area_2d.focus_gained.connect(outlined_sprite_2d.set_outline.bind(true))
	interactable_area_2d.focus_lost.connect(outlined_sprite_2d.set_outline.bind(false))

	if _is_preview:
		_enable_preview()


func get_data() -> AttractionData:
	return _data


func is_valid_at(world_position: Vector2) -> bool:
	var query: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	query.shape = collision_shape_2d.shape
	query.transform = Transform2D(0.0, world_position + collision_shape_2d.position)
	query.collision_mask = ATTRACTION_COLLISION_LAYER
	query.collide_with_bodies = true
	query.collide_with_areas = false

	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	return space_state.intersect_shape(query, 1).is_empty()


func process_preview(world_position: Vector2) -> void:
	global_position = world_position
	_fade_by_validity(is_valid_at(world_position))


func _fade_by_validity(is_valid: bool) -> void:
	modulate = PREVIEW_VALID_COLOR if is_valid else PREVIEW_INVALID_COLOR


func _enable_preview() -> void:
	collision_layer = 0
	collision_mask = 0
	interactable_area_2d.monitorable = false
	interactable_area_2d.monitoring = false
	interactable_area_2d.process_mode = Node.PROCESS_MODE_DISABLED
	_fade_by_validity(true)
