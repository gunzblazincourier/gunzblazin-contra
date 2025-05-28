extends Area2D
## Flies across screen when player reaches desired position. Contains weapon pickup
##
## Handles flight, destruction and weapon pickup spawn

## Capsule moves when player reaches this position
@export var starting_camera_position: float

## Initial position of capsule
var initial_position: Vector2

## Whether capsule has been destoryed
var destroyed: bool

## Animated sprite for the capsule, containing the default animation and the
## explosion
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

## Collision shape
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

## Explosion sound
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

## Pickup carried by capsule
@onready var pickup: Area2D = $Pickup

## Basic 2D node which is rotated to make capsule move as sine wave
@onready var node_2d: Node2D = $Node2D


func _ready() -> void:
	initial_position = global_position
	destroyed = false


func _process(_delta: float) -> void:
	if destroyed == true:
		animated_sprite_2d.play("explode")
		audio_stream_player_2d.play()
		collision_shape_2d.disabled = true
		pickup.process_mode = Node.PROCESS_MODE_INHERIT
		pickup.visible = true
		destroyed = false


func _physics_process(delta: float) -> void:
	if Global.camera_center_position.x > starting_camera_position and \
			destroyed == false:
		node_2d.rotate(6 * delta)
		global_position.y = initial_position.y + (sin(node_2d.rotation) * 20)
		global_position.x += 69 * delta

## Capsule is destroyed after shot by player
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		destroyed = true
		Global.score += 500
