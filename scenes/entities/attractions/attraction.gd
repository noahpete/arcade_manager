class_name Attraction
extends StaticBody2D

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	interactable_component.player_entered.connect(_on_player_entered)
	interactable_component.player_exited.connect(_on_player_exited)


func _on_player_entered(_player: Player) -> void:
	sprite_2d.material.set("shader_parameter/outline_color", Vector4.ONE)


func _on_player_exited(_player: Player) -> void:
	sprite_2d.material.set("shader_parameter/outline_color", Vector4.ZERO)
