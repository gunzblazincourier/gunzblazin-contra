extends Node
## Global script
##
## Contains all global variables

## Global position of player
var player_global_position: Vector2

## Direction that player is currently facing
var player_sprite_direction: float

## Center position of camera (screen)
var camera_center_position: Vector2

## All weapon types in the game
enum Weapons {R, M, S, F, L}

## Current weapon of the player
var weapon: Weapons


func _ready() -> void:
	player_global_position = Vector2.ZERO
	player_sprite_direction = 1
	camera_center_position = Vector2(-91, -16)
	weapon = Weapons.R
