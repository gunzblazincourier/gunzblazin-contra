extends Area2D

const BULLET_SPEED: int = 330
var dir: float
var has_angle_reached: bool = false
var rotation_value: float
@onready var rotation_stop_timer: Timer = $RotationStopTimer
@onready var queue_free_timer: Timer = $QueueFreeTimer
@onready var timer: Timer = $Timer
@onready var timer_2: Timer = $Timer2


func _ready() -> void:
	#Engine.time_scale = 0.5
	dir = Global.player_sprite_direction
	queue_free_timer.start()
	rotation_stop_timer.start()
	print("1")
	#if timer.is_stopped():
		#rotation_value = 0.08 * Global.player_sprite_direction
	#else:
		
	#if transform.x.x == 1.75*PI:
		#rotation_value = 0.1
	#else:
		#rotation_value = -0.1
	
	#if not timer.is_stopped():
		#rotate()


# Travels in constant direction
func _physics_process(delta: float) -> void:
	#print(queue_free_timer.time_left)
	#var rotation_reset: float = fmod(rotation, 2*PI)
	#print(rotation_degrees)
	#print(has_angle_reached)
	position += transform.x * BULLET_SPEED * delta
	#position.x += BULLET_SPEED * delta
	if timer.is_stopped():
		rotate(0.08 * dir)
	else:
		rotate(0.3 * dir)
	#print(transform.x)
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
	#queue_free()
	pass


func _on_body_entered(_body: Node2D) -> void:
	print(queue_free_timer.time_left)


func _on_rotation_stop_timer_timeout() -> void:
	timer.start()
	print("2")

func _on_timer_timeout() -> void:
	#rotation = dir * 1.5*PI
	timer_2.start()
	print("3")

func _on_timer_2_timeout() -> void:
	#rotation = dir * -PI/3
	rotation_stop_timer.start()
	print("4")
