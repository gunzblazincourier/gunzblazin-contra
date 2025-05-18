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

## Time for which 'Game Over' text is displayed, after which it transitions to
## game over screen
@onready var game_over_timer: Timer = $GameOverTimer

## UI for lives
@onready var lives: AnimatedSprite2D = $Lives


## Locks player position to center of camera view when player reaches center
func _process(_delta: float) -> void:
	print(game_over_timer.time_left)
	if Global.lives >= 3:
		lives.play("lives_3")
	elif Global.lives == 2:
		lives.play("lives_2")
	elif Global.lives == 1:
		lives.play("lives_1")
	elif Global.lives == 0:
		lives.play("lives_0")
	else:
		lives.play("game_over")
		if game_over_timer.is_stopped():
			game_over_timer.start()
	
	Global.camera_center_position = camera_2d.get_screen_center_position()
	if player.global_position.x > camera_2d.get_screen_center_position().x:
		camera_2d.global_position = player.global_position


## Keeps left boundary position to the left border during camera movement
func _physics_process(_delta: float) -> void:
	left_boundary.position.x = camera_2d.get_screen_center_position().x - 88
	lives.position.x = camera_2d.get_screen_center_position().x - 90
	Global.left_boundary_position = left_boundary.position


## Waves and stars animation by toggling visibility of the respective
## TileMapLayer each time LevelAnimationTimer timeouts
func _on_timer_timeout() -> void:
	if waves_and_stars.visible == true:
		waves_and_stars.visible = false
	else:
		waves_and_stars.visible = true


func _on_game_over_timer_timeout() -> void:
	Global.background_music.stop()
	var er: Error = get_tree().change_scene_to_file("res://Title/game_over.tscn")
	print(er)
	print("BEGIN")
