class_name AttractionMenu
extends VBoxContainer

@export var attractions: Array[AttractionData] = []


func _ready() -> void:
	populate(attractions)


func populate(list: Array[AttractionData]) -> void:
	for child in get_children():
		child.queue_free()

	for data in list:
		var option: AttractionMenuOption = AttractionMenuOption.create(data)
		option.selected.connect(_on_option_selected)
		add_child(option)


func _on_option_selected(data: AttractionData) -> void:
	print("Attraction: ", data.title)
