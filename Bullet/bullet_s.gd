extends Area2D
## Spreadgun bullet
##
## Handles speed, trajectory and removal from scene

## Fixed bullet speed
var bullet_speed: int


## Increase bullet speed after getting R
func _ready() -> void:
	if Global.increase_rof == false:
		bullet_speed = 250
	else:
		bullet_speed = 350


## Bullet travels in linear direction, without changing rotation or direction
func _physics_process(delta: float) -> void:
	position += transform.x * bullet_speed * delta


## Removes bullet if it enters specific hitboxes (eg an enemy's)
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") or area.is_in_group("object"):
		queue_free()


## Removes bullet once outside screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
