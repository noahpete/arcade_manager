class_name Cabinet
extends Attraction

const SCENE: PackedScene = preload("uid://dhn2d2dn07kuc")


static func create() -> Cabinet:
	var cabinet: Cabinet = SCENE.instantiate()
	return cabinet


func _ready() -> void:
	super()
