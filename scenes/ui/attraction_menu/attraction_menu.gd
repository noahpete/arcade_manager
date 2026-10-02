class_name AttractionMenu
extends VBoxContainer

const MENU_MOVE_DURATION: float = 0.2
const OPEN_POSITION: Vector2 = Vector2.ZERO

@export var attractions: Array[AttractionData] = []

var _is_open: bool = false


func _ready() -> void:
	Events.attraction_menu_toggle_requested.connect(toggle)
	Events.attraction_menu_open_requested.connect(open)
	Events.attraction_menu_close_requested.connect(close)

	_populate(attractions)
	position.x = -get_combined_minimum_size().x


func toggle() -> void:
	if _is_open:
		close()
	else:
		open()


func open() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "position", OPEN_POSITION, MENU_MOVE_DURATION) \
			.set_ease(Tween.EASE_IN_OUT) \
			.set_trans(Tween.TRANS_CUBIC)
	_is_open = true


func close() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "position:x", -size.x, MENU_MOVE_DURATION) \
			.set_ease(Tween.EASE_IN_OUT) \
			.set_trans(Tween.TRANS_CUBIC)
	_is_open = false


func _populate(list: Array[AttractionData]) -> void:
	for child in get_children():
		child.queue_free()

	for data in list:
		var option: AttractionMenuOption = AttractionMenuOption.create(data)
		option.selected.connect(_on_option_selected)
		add_child(option)


func _on_option_selected(data: AttractionData) -> void:
	print("Attraction: ", data.title)
