class_name InteractableComponent
extends Area2D

signal interacted()
signal player_entered(player: Player)
signal player_exited(player: Player)

var current_player: Node2D = null


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _unhandled_input(event: InputEvent) -> void:
	if current_player and event.is_action_pressed("interact"):
		interact()
		get_viewport().set_input_as_handled()


func interact() -> void:
	interacted.emit()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered.emit(body)
		current_player = body


func _on_body_exited(body: Node2D) -> void:
	if body == current_player:
		player_exited.emit(body)
		current_player = null
