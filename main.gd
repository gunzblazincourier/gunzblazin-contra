extends Node
## Main scene of the entire game (currently the 1st level)
##
## Controls player position relative to camera, and toggles visibility of
## different nodes based on a timer

## Tiles for waves and stars animation
@onready var waves_and_stars: TileMapLayer = $WavesAndStars

## Protagonist of Contra (named Bill)
@onready var player: CharacterBody2D = $Player

## Level camera
@onready var camera_2d: Camera2D = $Camera2D

## Prevents player from going back
@onready var left_boundary: StaticBody2D = $LeftBoundary

## Controls speed of animation of waves and stars
@onready var level_animation_timer: Timer = $LevelAnimationTimer


## Locks player position to center of camera view when player reaches center
func _process(_delta: float) -> void:
	if player.global_position.x > camera_2d.get_screen_center_position().x:
		camera_2d.global_position = player.global_position


## Keeps left boundary position to the left border during camera movement
func _physics_process(_delta: float) -> void:
	left_boundary.position.x = camera_2d.get_screen_center_position().x - 88


## Waves and stars animation by toggling visibility of the respective
## TileMapLayer each time LevelAnimationTimer timeouts
func _on_timer_timeout() -> void:
	if waves_and_stars.visible == true:
		waves_and_stars.visible = false
	else:
		waves_and_stars.visible = true
