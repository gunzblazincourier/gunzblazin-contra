extends Area2D
## TurretSoldier bullet
##
## Handles speed and trajectory

## Fixed bullet speed
const BULLET_SPEED: int = 100


## Bullet travels in linear direction, without changing rotation or direction
func _physics_process(delta: float) -> void:
	position += transform.x * BULLET_SPEED * delta


## Removes bullet once it hits player
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		queue_free()


## Removes bullet once outside screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
