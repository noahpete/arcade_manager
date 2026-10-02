class_name Counter
extends StaticBody2D

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	interactable_component.interacted.connect(_on_interacted)
	interactable_component.focus_gained.connect(_set_outlined.bind(true))
	interactable_component.focus_lost.connect(_on_focus_lost)


func _set_outlined(outlined: bool) -> void:
	var color: Vector4 = Vector4.ONE if outlined else Vector4.ZERO
	sprite_2d.material.set("shader_parameter/outline_color", color)


func _on_interacted() -> void:
	Events.attraction_menu_toggle_requested.emit()


func _on_focus_lost() -> void:
	_set_outlined(false)
	Events.attraction_menu_close_requested.emit()
