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

## Player's lives
var lives: int

## Left boundary's position
var left_boundary_position: Vector2

## Score
var score: int


func _ready() -> void:
	player_global_position = Vector2.ZERO
	player_sprite_direction = 1
	camera_center_position = Vector2(-91, -16)
	weapon = Weapons.R
	lives = 0
	left_boundary_position = Vector2.ZERO
	score = 0


#func _process(_delta: float) -> void:
	#print(score)
