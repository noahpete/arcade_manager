class_name Main
extends Node

const FADE_ANIMATION_DURATION: float = 0.2
const FADE_WALL_OPACITY: float = 0.2

@onready var _player: Player = %Player
@onready var _structures: TileMapLayer = %Structures


func _ready() -> void:
	Events.attraction_menu_option_selected.connect(_on_attraction_menu_option_selected)
	Events.attraction_layout_finished.connect(_on_attraction_layout_finished)
	Events.zone_changed.connect(_on_zone_changed)


func _fade_walls(alpha: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(_structures, "modulate:a", alpha, FADE_ANIMATION_DURATION)


func _on_attraction_menu_option_selected(_data: AttractionData) -> void:
	_player.set_physics_process(false)


func _on_attraction_layout_finished() -> void:
	_player.set_physics_process(true)


func _on_zone_changed(new_zone: StringName, _old_zone: StringName = &"none") -> void:
	match new_zone:
		&"arcade":
			_fade_walls(FADE_WALL_OPACITY)
		&"none":
			_fade_walls(1.0)
