extends Area2D

const BULLET_SPEED: int = 450
var has_angle_reached: bool = false
var rotation_value: float
@onready var rotation_stop_timer: Timer = $RotationStopTimer
@onready var queue_free_timer: Timer = $QueueFreeTimer


func _ready() -> void:
	queue_free_timer.start()
	rotation_value = 0.1 * Global.player_sprite_direction
	#if transform.x.x == 1.75*PI:
		#rotation_value = 0.1
	#else:
		#rotation_value = -0.1


# Travels in constant direction
func _physics_process(delta: float) -> void:
	#var rotation_reset: float = fmod(rotation, 2*PI)
	#print(rotation_degrees)
	#print(has_angle_reached)
	position += transform.x * BULLET_SPEED * delta
	#position.x += BULLET_SPEED * delta
	rotate(rotation_value)
	print(transform.x)
	#if has_angle_reached == false and rotation_reset > PI/2:
		#print("true")
		#has_angle_reached = true
		#rotate(5)
		#rotation_stop_timer.start()
	#else:
		#rotate(0.1)
	
	#if rotation_reset > 0 and rotation_reset < 1:
		#rotation = 0
		#has_angle_reached = false


func _on_queue_free_timer_timeout() -> void:
	queue_free()
