extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
	#var angle_with_mouse: float = global_position.angle_to_point(get_global_mouse_position())
	#print(angle_with_mouse)
	#
	#if angle_with_mouse < -0.79 and angle_with_mouse > -2.36:
		#animated_sprite_2d.play("shoot_up")
	#elif angle_with_mouse > 0.79 and angle_with_mouse < 2.36:
		#animated_sprite_2d.play("shoot_down")
	#else:
		#animated_sprite_2d.play("shoot_straight")


func _on_timer_timeout() -> void:
	var angle_with_mouse: float = global_position.angle_to_point(get_global_mouse_position())
	print(angle_with_mouse)
	
	if angle_with_mouse < -0.79 and angle_with_mouse > -2.36:
		animated_sprite_2d.play("shoot_up")
	elif angle_with_mouse > 0.79 and angle_with_mouse < 2.36:
		animated_sprite_2d.play("shoot_down")
	else:
		animated_sprite_2d.play("shoot_straight")
	
	if angle_with_mouse > -1.57 and angle_with_mouse < 1.57:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true
	timer.start()
