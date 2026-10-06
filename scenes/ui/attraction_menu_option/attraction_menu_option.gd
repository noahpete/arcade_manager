class_name AttractionMenuOption
extends HBoxContainer

const SCENE: PackedScene = preload("uid://bg6v0g54cdhmw")

signal selected(data: AttractionData)

var _data: AttractionData

@onready var _icon: TextureRect = $Icon
@onready var _title: Label = $Details/Title


static func create(data: AttractionData) -> AttractionMenuOption:
	var option: AttractionMenuOption = SCENE.instantiate()
	option._data = data
	return option


func _ready() -> void:
	if _data:
		_icon.texture = _data.texture
		_title.text = _data.title


func _gui_input(event):
	match event.get_class():
		"InputEventMouseButton":
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				selected.emit(_data)
				accept_event()
