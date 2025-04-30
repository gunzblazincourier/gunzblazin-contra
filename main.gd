extends Node

@onready var waves_and_stars: TileMapLayer = $WavesAndStars
@onready var player: CharacterBody2D = $Player
@onready var camera_2d: Camera2D = $Camera2D
@onready var left_boundary: StaticBody2D = $LeftBoundary
@onready var level_animation_timer: Timer = $LevelAnimationTimer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player.global_position.x > camera_2d.get_screen_center_position().x:
		camera_2d.global_position = player.global_position

func _physics_process(_delta: float) -> void:
	left_boundary.position.x = camera_2d.get_screen_center_position().x - 88


func _on_timer_timeout() -> void:
	if waves_and_stars.visible == true:
		waves_and_stars.visible = false
	else:
		waves_and_stars.visible = true
