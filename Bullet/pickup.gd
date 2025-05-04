extends Area2D
## Weapon pickups
##
## Controls its speed, trajectory and the action of 'picking' by the player

## Fixed horizontal pickup speed
const PICKUP_SPEED_X: int = 70

## Custom gravity
const GRAVITY: int = 555

## Non-constant vertical speed
var pickup_speed_y: float

## RayCast to detect landing
@onready var ray_cast_2d: RayCast2D = $RayCast2D


func _ready() -> void:
	pickup_speed_y = -150


## Pickup travels in an arc with constant horizontal speed
func _physics_process(delta: float) -> void:
	position.x += PICKUP_SPEED_X * delta
	position.y += pickup_speed_y * delta
	pickup_speed_y += GRAVITY * delta
