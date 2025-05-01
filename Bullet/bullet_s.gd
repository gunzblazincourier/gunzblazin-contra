extends Area2D
## Spreadgun bullet
##
## Handles speed, trajectory and removal from scene

## Fixed bullet speed
const BULLET_SPEED: int = 400


## Bullet travels in linear direction, without changing rotation or direction
func _physics_process(delta: float) -> void:
	position += transform.x * BULLET_SPEED * delta


## Removes bullet if it enters specific hitboxes (eg an enemy's)
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		queue_free()
