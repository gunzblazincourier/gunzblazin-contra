extends Node

var player_global_position: Vector2
var player_sprite_direction: float


func _ready() -> void:
	player_global_position = Vector2.ZERO
	player_sprite_direction = 1
