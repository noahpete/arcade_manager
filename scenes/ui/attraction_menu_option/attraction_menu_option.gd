class_name AttractionMenuOption
extends HBoxContainer

const SCENE: PackedScene = preload("uid://bg6v0g54cdhmw")

signal selected(data: AttractionData)

@onready var icon: TextureRect = $Icon
@onready var title: Label = $Details/Title

var data: AttractionData


static func create(attraction_data: AttractionData) -> AttractionMenuOption:
	var option: AttractionMenuOption = SCENE.instantiate()
	option.data = attraction_data
	return option


func _ready() -> void:
	_apply()


func _gui_input(event):
	match event.get_class():
		"InputEventMouseButton":
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				selected.emit(data)


func _apply() -> void:
	if not data:
		return
	icon.texture = data.icon
	title.text = data.title
