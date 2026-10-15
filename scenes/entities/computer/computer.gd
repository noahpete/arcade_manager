class_name Computer
extends Node2D

@onready var interactable_area_2d: InteractableArea2D = $InteractableArea2D
@onready var outlined_sprite_2d: OutlinedSprite2D = $OutlinedSprite2D


func _ready() -> void:
	interactable_area_2d.interacted.connect(_on_interacted)
	interactable_area_2d.focus_gained.connect(_on_focus_gained)
	interactable_area_2d.focus_lost.connect(_on_focus_lost)


func _on_interacted() -> void:
	Events.attraction_menu_toggle_requested.emit()


func _on_focus_gained() -> void:
	outlined_sprite_2d.set_outline(true)


func _on_focus_lost() -> void:
	outlined_sprite_2d.set_outline(false)
	Events.attraction_menu_close_requested.emit()
