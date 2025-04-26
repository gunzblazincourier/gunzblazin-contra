extends Area2D

const BULLET_SPEED: int = 400


# Travels in constant direction
func _physics_process(delta: float) -> void:
	position += transform.x * BULLET_SPEED * delta
