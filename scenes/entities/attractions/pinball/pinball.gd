class_name Pinball
extends Attraction

const SCENE: PackedScene = preload("uid://cg4dh5fjx8iv3")


static func create() -> Pinball:
	var pinball: Pinball = SCENE.instantiate()
	return pinball


func _ready() -> void:
	super()
