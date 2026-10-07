class_name Attraction
extends StaticBody2D

var _data: AttractionData
var _is_preview: bool = false

@onready var interactable_area_2d: InteractableArea2D = $InteractableArea2D
@onready var outlined_sprite_2d: OutlinedSprite2D = $OutlinedSprite2D


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
		enable_preview()


func get_data() -> AttractionData:
	return _data


func enable_preview() -> void:
	collision_layer = 0
	collision_mask = 0
	interactable_area_2d.monitorable = false
	interactable_area_2d.monitoring = false
	interactable_area_2d.process_mode = Node.PROCESS_MODE_DISABLED
	modulate = Color(1.0, 1.0, 1.0, 0.5)
