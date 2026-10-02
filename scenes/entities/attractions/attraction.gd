class_name Attraction
extends StaticBody2D

@onready var interactable_component: InteractableArea2D = $InteractableComponent
@onready var outlined_sprite_2d: OutlinedSprite2D = $OutlinedSprite2D


func _init() -> void:
	add_to_group("attractions")


func _ready() -> void:
	interactable_component.focus_gained.connect(outlined_sprite_2d.set_outline.bind(true))
	interactable_component.focus_lost.connect(outlined_sprite_2d.set_outline.bind(false))
