extends Area2D
## Lasergun laser
##
## Handles speed and trajectory

## Fixed bullet speed
const BULLET_SPEED: int = 400


## Bullet travels in linear direction, without changing rotation or direction
func _physics_process(delta: float) -> void:
	position += transform.x * BULLET_SPEED * delta


# Cannot remove laser since only one instance is made to respawn laser
# instead of making another one, so it is just disabled until visible again
## Disables laser once outside screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("gone")
	monitoring = false
	monitorable = false


## Reenables laser when in view
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	print("back")
	monitoring = true
	monitorable = true
