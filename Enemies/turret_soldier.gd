extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var marker_2d: Marker2D = $Marker2D


func _on_timer_timeout() -> void:
	var angle_with_mouse: float = global_position.angle_to_point(Global.player_global_position)
	print(angle_with_mouse)
	
	if angle_with_mouse < -PI/4 and angle_with_mouse > -3*(PI/4):
		animated_sprite_2d.play("shoot_up")
	elif angle_with_mouse > PI/4 and angle_with_mouse < 3*(PI*4):
		animated_sprite_2d.play("shoot_down")
	else:
		animated_sprite_2d.play("shoot_straight")
	
	if angle_with_mouse > -PI/2 and angle_with_mouse < PI/2:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true
	
	if animated_sprite_2d.animation == "shoot_up":
		if animated_sprite_2d.flip_h == false:
			marker_2d.position = Vector2(9, -21)
			marker_2d.rotation = clamp(angle_with_mouse, -PI/2, -PI/8)
		else:
			marker_2d.position = Vector2(-9, -21)
			marker_2d.rotation = clamp(angle_with_mouse, -7*(PI/8), -PI/2)
	elif animated_sprite_2d.animation == "shoot_down":
		if animated_sprite_2d.flip_h == false:
			marker_2d.position = Vector2(14, 2)
			marker_2d.rotation = clamp(angle_with_mouse, PI/8, PI/2)
		else:
			marker_2d.position = Vector2(-14, 2)
			marker_2d.rotation = clamp(angle_with_mouse, PI/2, 7*(PI/8))
	else:
		if animated_sprite_2d.flip_h == false:
			marker_2d.position = Vector2(14, -11)
			marker_2d.rotation = 0
		else:
			marker_2d.position = Vector2(-14, -11)
			marker_2d.rotation = PI
	
	var bullet_path: PackedScene = load("res://Bullet/bullet_ts.tscn")
	var bullet: Area2D = bullet_path.instantiate()
	owner.add_child(bullet)
	bullet.position = marker_2d.global_position
	bullet.rotation = marker_2d.global_rotation
	
	print(marker_2d.rotation)
	timer.start()
