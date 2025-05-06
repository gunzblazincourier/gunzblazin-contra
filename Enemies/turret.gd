extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var visible_on_screen_notifier_2d_2: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D2
@onready var muzzle: Marker2D = $Muzzle
@onready var shoot_timer: Timer = $ShootTimer


func _process(_delta: float) -> void:
	#print(animated_sprite_2d.animation)
	var angle_with_player: float = global_position.angle_to_point(Global.player_global_position)
	var angle_min: float
	var angle_max: float
	#var mirror: float
	if animated_sprite_2d.animation == "shoot":
		if animated_sprite_2d.frame == 0:
			#if angle_with_player < -11*(PI/12) and angle_with_player > 11*(PI/12):
				#animated_sprite_2d.stop()
			muzzle.position = Vector2(-14, 0)
			muzzle.rotation = PI
			angle_max = -11*(PI/12)
			angle_min = 11*(PI/12)
			#mirror = 0
		elif animated_sprite_2d.frame == 1:
			muzzle.position = Vector2(-13, 6)
			muzzle.rotation = 5*(PI/6)
			angle_max = 11*(PI/12)
			angle_min = 9*(PI/12)
			#mirror = -PI/6
		elif animated_sprite_2d.frame == 2:
			muzzle.position = Vector2(-7, 12)
			muzzle.rotation = 4*(PI/6)
			angle_max = 9*(PI/12)
			angle_min = 7*(PI/12)
			#mirror = -2*(PI/6)
		elif animated_sprite_2d.frame == 3:
			muzzle.position = Vector2(0, 13)
			muzzle.rotation = 3*(PI/6)
			angle_max = 7*(PI/12)
			angle_min = 5*(PI/12)
			#mirror = -3*(PI/6)
		elif animated_sprite_2d.frame == 4:
			muzzle.position = Vector2(7, 12)
			muzzle.rotation = 2*(PI/6)
			angle_max = 5*(PI/12)
			angle_min = 3*(PI/12)
			#mirror = -4*(PI/6)
		elif animated_sprite_2d.frame == 5:
			muzzle.position = Vector2(12, 7)
			muzzle.rotation = PI/6
			angle_max = 3*(PI/12)
			angle_min = 1*(PI/12)
			#mirror = -5*(PI/6)
		elif animated_sprite_2d.frame == 6:
			muzzle.position = Vector2(13, 0)
			muzzle.rotation = 0
			angle_max = 1*(PI/12)
			angle_min = -1*(PI/12)
			#mirror = PI
		elif animated_sprite_2d.frame == 7:
			muzzle.position = Vector2(12, -7)
			muzzle.rotation = -PI/6
			angle_max = -1*(PI/12)
			angle_min = -3*(PI/12)
			#mirror = PI/6
		elif animated_sprite_2d.frame == 8:
			muzzle.position = Vector2(7, -12)
			muzzle.rotation = -2*(PI/6)
			angle_max = -3*(PI/12)
			angle_min = -5*(PI/12)
			#mirror = 2*(PI/6)
		elif animated_sprite_2d.frame == 9:
			muzzle.position = Vector2(-1, -14)
			muzzle.rotation = -3*(PI/6)
			angle_max = -5*(PI/12)
			angle_min = -7*(PI/12)
			#mirror = 3*(PI/6)
		elif animated_sprite_2d.frame == 10:
			muzzle.position = Vector2(-8, -13)
			muzzle.rotation = -4*(PI/6)
			angle_max = -7*(PI/12)
			angle_min = -9*(PI/12)
			#mirror = 4*(PI/6)
		elif animated_sprite_2d.frame == 11:
			muzzle.position = Vector2(-12, -7)
			muzzle.rotation = -5*(PI/6)
			angle_max = -9*(PI/12)
			angle_min = -11*(PI/12)
			#mirror = 5*(PI/6)
		
		if angle_with_player < 0:
			angle_with_player += 360
		if angle_max < 0:
			angle_max += 360
		if angle_min < 0:
			angle_min += 360
		
		#print(mirror)
		if shoot_timer.is_stopped():
			#if animated_sprite_2d.frame != 0:
			if angle_with_player < angle_min:
				animated_sprite_2d.play("shoot")
			elif angle_with_player > angle_max:
				animated_sprite_2d.play_backwards("shoot")
			else:
				shoot_timer.start()
				var bullet_path: PackedScene = load("res://Bullet/bullet_ts.tscn")
				var bullet: Area2D = bullet_path.instantiate()
				owner.add_child(bullet)
				bullet.position = muzzle.global_position
				bullet.rotation = muzzle.global_rotation
				animated_sprite_2d.pause()
			#else:
				#if angle_with_player < angle_min and angle_with_player > 0:
					#animated_sprite_2d.play("shoot")
				#elif angle_with_player > angle_max and angle_with_player < 0:
					#animated_sprite_2d.play_backwards("shoot")
				#else:
					#shoot_timer.start()
					#var bullet_path: PackedScene = load("res://Bullet/bullet_ts.tscn")
					#var bullet: Area2D = bullet_path.instantiate()
					#owner.add_child(bullet)
					#bullet.position = muzzle.global_position
					#bullet.rotation = muzzle.global_rotation
					#animated_sprite_2d.pause()
		#print(angle_with_player)
		#print(angle_min)
		#print(angle_with_player < angle_min)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	animated_sprite_2d.play("activate")
	

func _on_visible_on_screen_notifier_2d_2_screen_exited() -> void:
	animated_sprite_2d.play("deactivate")


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "activate":
		animated_sprite_2d.play("shoot")
