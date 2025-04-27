extends Area2D

const BULLET_SPEED: int = 300
@onready var rotation_stop_timer: Timer = $RotationStopTimer


#func _ready() -> void:
	#rotation = PI


# Travels in constant direction
func _physics_process(delta: float) -> void:
	position += transform.x * BULLET_SPEED * delta
	if rotation_stop_timer.is_stopped():
		rotate(0.1)
	else:
		rotation = PI
	#print(fmod(rotation_degrees, 360))
	
	#if rotation == 2*PI:
		#rotation = 0
	
	#var reset_rotation: float = fmod(rotation, 360)
	#if reset_rotation > -PI and reset_rotation < -PI/2:
		#rotate(0.2)
		#print("tg")
	#else:
		#rotate(0.1)


# Removes bullet if it enters specific hitboxes (eg an enemy's)
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		queue_free()
	#print(area)


func _on_body_entered(_body: Node2D) -> void:
	rotation_stop_timer.start()


func _on_rotation_stop_timer_timeout() -> void:
	rotation = -PI/2
