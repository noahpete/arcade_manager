class_name OutlinedSprite2D
extends Sprite2D


func set_outline(enabled: bool) -> void:
	material.set("shader_parameter/enabled", enabled)
