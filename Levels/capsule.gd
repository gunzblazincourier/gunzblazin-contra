extends Area2D
## Flies across screen when player reaches desired position. Contains weapon pickup
##
## Handles flight, destruction and weapon pickup spawn

## Capsule moves when player reaches this position
@export var starting_camera_position: float

## Initial position of capsule
var initial_position: Vector2

## Whether capsule has been destoryed
var is_destroyed: bool

## Toggle to make capsule move or stop
var should_move: bool

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
	is_destroyed = false
	should_move = true


func _process(_delta: float) -> void:
	if is_destroyed == true:
		animated_sprite_2d.play("explode")
		audio_stream_player_2d.play()
		collision_shape_2d.disabled = true
		pickup.process_mode = Node.PROCESS_MODE_INHERIT
		pickup.visible = true
		is_destroyed = false


func _physics_process(delta: float) -> void:
	if Global.camera_center_position.x > starting_camera_position and \
			should_move == true:
		visible = true
		#process_mode = Node.PROCESS_MODE_INHERIT
		node_2d.rotate(5 * delta)
		global_position.y = initial_position.y + (sin(node_2d.rotation) * 25)
		global_position.x += 93 * delta

## Capsule is is_destroyed after shot by player
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		is_destroyed = true
		should_move = false
		Global.score += 500


## Remove capsule from game when outside camera view
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
