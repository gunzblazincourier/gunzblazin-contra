extends Node

@onready var player: CharacterBody2D = $Player
@onready var camera_2d: Camera2D = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#pass
	print(player.global_position.x > camera_2d.get_screen_center_position().x)
	if player.global_position.x > camera_2d.get_screen_center_position().x:
		camera_2d.global_position = player.global_position

#func _physics_process(_delta: float) -> void:
	#camera_2d.global_position = player.global_position
