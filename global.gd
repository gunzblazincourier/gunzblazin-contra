extends Node
## Global script
##
## Contains all global variables

## Default amount of lives provided to player upon starting game or
## continuing from game over
const DEFAULT_LIVES: int = 2

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

## Player's lives (0 lives means last life; -1 is game over)
var lives: int

## Left boundary's position
var left_boundary_position: Vector2

## Player score
var score: int

## High score
var high_score: int

## Background music for levels
@onready var background_music: AudioStreamPlayer2D = $"/root/BackgroundMusic"


func _ready() -> void:
	player_global_position = Vector2.ZERO
	player_sprite_direction = 1
	camera_center_position = Vector2(-91, -16)
	weapon = Weapons.R
	lives = 0
	left_boundary_position = Vector2.ZERO
	score = 0
	high_score = 20000
