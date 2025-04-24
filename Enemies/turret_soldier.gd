extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var marker_2d: Marker2D = $Marker2D


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
	#var angle_with_mouse: float = global_position.angle_to_point(get_global_mouse_position())
	var angle_with_mouse: float = marker_2d.global_position.angle_to_point(Global.player_global_position)
	print(angle_with_mouse)
	
	#if angle_with_mouse < -0.79 and angle_with_mouse > -2.36:
		#animated_sprite_2d.play("shoot_up")
	#elif angle_with_mouse > 0.79 and angle_with_mouse < 2.36:
		#animated_sprite_2d.play("shoot_down")
	#else:
		#animated_sprite_2d.play("shoot_straight")
	#
	#if angle_with_mouse > -1.57 and angle_with_mouse < 1.57:
		#animated_sprite_2d.flip_h = false
	#else:
		#animated_sprite_2d.flip_h = true
	
	if angle_with_mouse < -PI/4 and angle_with_mouse > -3*PI/4:
		animated_sprite_2d.play("shoot_up")
		marker_2d.position = Vector2(9, -21)
	elif angle_with_mouse > PI/4 and angle_with_mouse < 3*PI*4:
		animated_sprite_2d.play("shoot_down")
		marker_2d.position = Vector2(14, 2)
	else:
		animated_sprite_2d.play("shoot_straight")
		marker_2d.position = Vector2(14, -11)
	
	if angle_with_mouse > -PI/2 and angle_with_mouse < PI/2:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true
	
	if animated_sprite_2d.animation == "shoot_up":
		if animated_sprite_2d.flip_h == false:
			marker_2d.position = Vector2(9, -21)
		else:
			marker_2d.position = Vector2(-9, -21)
	elif animated_sprite_2d.animation == "shoot_down":
		if animated_sprite_2d.flip_h == false:
			marker_2d.position = Vector2(14, 2)
		else:
			marker_2d.position = Vector2(-14, 2)
	else:
		if animated_sprite_2d.flip_h == false:
			marker_2d.position = Vector2(14, -11)
		else:
			marker_2d.position = Vector2(-14, -11)
	
	timer.start()
