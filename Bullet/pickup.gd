extends Area2D
## Weapon pickups
##
## Controls its speed, trajectory and the action of 'picking' by the player

## Fixed horizontal pickup speed
const PICKUP_SPEED_X: int = 70

## Custom gravity
const GRAVITY: int = 350

## Non-constant vertical speed
var pickup_speed_y: float

## RayCast to detect landing
@onready var ray_cast_2d: RayCast2D = $RayCast2D

## Pickup sound
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	pickup_speed_y = -175


## Pickup travels in an arc with constant horizontal speed
func _physics_process(delta: float) -> void:
	if not ray_cast_2d.is_colliding():
		position.x += PICKUP_SPEED_X * delta
		position.y += pickup_speed_y * delta
		pickup_speed_y += GRAVITY * delta


## Play audio and disable it when player picks it up
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		audio_stream_player_2d.play()
		monitorable = false
		monitoring = false
		visible = false

## Remove the pickup from level after pickup sound finishes playing
func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
