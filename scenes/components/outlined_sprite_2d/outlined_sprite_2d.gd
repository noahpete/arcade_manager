class_name OutlinedSprite2D
extends Sprite2D


func set_outline(outline: bool) -> void:
	var color: Vector4 = Vector4.ONE if outline else Vector4.ZERO
	material.set("shader_parameter/outline_color", color)
