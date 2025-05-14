extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animated_sprite_2d_2: AnimatedSprite2D = $AnimatedSprite2D2
@onready var death_explosion_sfx: AudioStreamPlayer2D = $DeathExplosionSFX
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var muzzle: Marker2D = $Muzzle
@onready var shoot_timer: Timer = $ShootTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.visible = false
	animated_sprite_2d_2.visible = false
	collision_shape_2d.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var current_frame: int = animated_sprite_2d_2.get_frame()
	var current_progress: float = animated_sprite_2d_2.get_frame_progress()
	
	if animated_sprite_2d.animation == "rise":
		if animated_sprite_2d.frame == 0:
			animated_sprite_2d_2.animation = "rise_0"
			animated_sprite_2d_2.set_frame_and_progress(current_frame, current_progress)
		elif animated_sprite_2d.frame == 1:
			animated_sprite_2d_2.animation = "rise_1"
			animated_sprite_2d_2.set_frame_and_progress(current_frame, current_progress)
		elif animated_sprite_2d.frame == 2:
			animated_sprite_2d_2.animation = "shoot_0"
			animated_sprite_2d_2.set_frame_and_progress(current_frame, current_progress)
	elif animated_sprite_2d.animation == "shoot":
		if animated_sprite_2d.frame == 0:
			animated_sprite_2d_2.animation = "shoot_0"
			animated_sprite_2d_2.set_frame_and_progress(current_frame, current_progress)
		elif animated_sprite_2d.frame == 1:
			animated_sprite_2d_2.animation = "shoot_1"
			animated_sprite_2d_2.set_frame_and_progress(current_frame, current_progress)
		elif animated_sprite_2d.frame == 2:
			animated_sprite_2d_2.animation = "shoot_2"
			animated_sprite_2d_2.set_frame_and_progress(current_frame, current_progress)
	
	print(animated_sprite_2d_2.animation)
	#print(animated_sprite_2d.frame)
	## Angle between the player and turret's center relative to x-axis
	var angle_with_player: float = global_position.angle_to_point(Global.player_global_position)
	#print(angle_with_player)
	
	## Minumum angle of the sightcone
	var angle_min: float
	
	## Maximum angle of the sightcone
	var angle_max: float
	
	#if animated_sprite_2d.animation == "shoot":
	if animated_sprite_2d.animation == "shoot":
		if (angle_with_player < 0 and angle_with_player < -5*(PI/12)) or \
				angle_with_player > 0 and angle_with_player > 10*(PI/12):
			#print("yes")
			if animated_sprite_2d.frame == 0:
				#print("1")
				muzzle.position = Vector2(-15, 0)
				muzzle.rotation = PI
				angle_max = -11*(PI/12)
				angle_min = 10*(PI/12)
			elif animated_sprite_2d.frame == 1:
				print("2")
				muzzle.position = Vector2(-14, -7)
				muzzle.rotation = -5*(PI/6)
				angle_max = -9*(PI/12)
				angle_min = -11*(PI/12)
			elif animated_sprite_2d.frame == 2:
				#print("3")
				muzzle.position = Vector2(-8, -13)
				muzzle.rotation = -4*(PI/6)
				angle_max = -5*(PI/12)
				angle_min = -9*(PI/12)
		
		# Changes angle range from signed ([-180, 180]) to unsigned ([0, 360])
			if angle_with_player < 0:
				angle_with_player += 360
			if angle_max < 0:
				angle_max += 360
			if angle_min < 0:
				angle_min += 360
		#else:
			#print("yt")
			#animated_sprite_2d.pause()
		
			## Spawn bullet and pause tracking when timer's running, otherwise
			## track until player is in sightcone
			if shoot_timer.is_stopped():
				if angle_with_player < angle_min:
					print("a")
					animated_sprite_2d.play_backwards("shoot")
				elif angle_with_player > angle_max:
					print("b")
					animated_sprite_2d.play("shoot")
				else:
					shoot_timer.start()
					var bullet_path: PackedScene = load("res://Bullet/bullet_ts.tscn")
					var bullet: Area2D = bullet_path.instantiate()
					owner.add_child(bullet)
					bullet.position = muzzle.global_position
					bullet.rotation = muzzle.global_rotation
					animated_sprite_2d.pause()
		else:
			#print("yt")
			animated_sprite_2d.pause()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	animated_sprite_2d.visible = true
	animated_sprite_2d_2.visible = true
	#print("tret")
	animated_sprite_2d.play("rise")


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		animated_sprite_2d_2.visible = false
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)
		animated_sprite_2d.play("explode")
		death_explosion_sfx.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	#print("yes")
	if animated_sprite_2d.animation == "rise":
		if animated_sprite_2d.frame == 2:
			animated_sprite_2d.play("shoot")
			collision_shape_2d.disabled = false
		elif animated_sprite_2d.frame == 0:
			queue_free()


func _on_death_explosion_sfx_finished() -> void:
	queue_free()


func _on_visible_on_screen_notifier_2d_2_screen_exited() -> void:
	animated_sprite_2d.play_backwards("rise")
