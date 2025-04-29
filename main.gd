extends Node

@onready var player: CharacterBody2D = $Player
@onready var camera_2d: Camera2D = $Camera2D
@onready var static_body_2d: StaticBody2D = $StaticBody2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player.global_position.x > camera_2d.get_screen_center_position().x:
		camera_2d.global_position = player.global_position

func _physics_process(_delta: float) -> void:
	static_body_2d.position.x = camera_2d.get_screen_center_position().x - 88
