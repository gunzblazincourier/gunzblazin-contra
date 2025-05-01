extends Node

var player_global_position: Vector2
var player_sprite_direction: float
var camera_center_position: Vector2


func _ready() -> void:
	player_global_position = Vector2.ZERO
	player_sprite_direction = 1
	camera_center_position = Vector2(-91, -16)
