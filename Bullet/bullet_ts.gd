extends Area2D
## TurretSoldier bullet
##
## Handles speed and trajectory

## Fixed bullet speed
const BULLET_SPEED: int = 300


## Bullet travels in linear direction, without changing rotation or direction
func _physics_process(delta: float) -> void:
	position += transform.x * BULLET_SPEED * delta
