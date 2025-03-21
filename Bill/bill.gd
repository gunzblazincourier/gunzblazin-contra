# NOTE: Implementation of bullet limits pending (eg in case of Machinegun)
# NOTE: Player death is to be written next (currently death upon physical enemy contact)

extends CharacterBody2D

# Declaration of node paths
@onready var animated_sprite_2d_bill: AnimatedSprite2D = $AnimatedSprite2D_Bill
@onready var muzzle: Marker2D = $Muzzle
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var area_2d_collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var shoot_timer: Timer = $ShootTimer

# Initialization of bullet paths and declaration of bullets
var bullet_r_path: PackedScene = preload("res://Bullet/bullet_r.tscn")
var bullet_r: Area2D
var bullet_m_path: PackedScene = preload("res://Bullet/bullet_m.tscn")
var bullet_m: Area2D
var bullet_f_path: PackedScene = preload("res://Bullet/bullet_f.tscn")
var bullet_f: Area2D
var bullet_l_path: PackedScene = preload("res://Bullet/bullet_l.tscn")
var bullet_l: Area2D
var bullet_s_path: PackedScene = preload("res://Bullet/bullet_s.tscn")
var bullet_s1: Area2D
var bullet_s2: Area2D
var bullet_s3: Area2D
var bullet_s4: Area2D
var bullet_s5: Area2D

# Declaration of constants
const RUN_SPEED: int = 100
const JUMP_SPEED: int = -300
const GRAVITY: int = 666

# Other variables
var bullet_id: String
var is_jumping: bool = false


func _process(_delta: float) -> void:
	var look_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	var run_direction: float = Input.get_axis("left", "right")
	
	# Emnables animations such as of running and shooting to continue to stay on same frame
	# number while switching animations
	var current_frame: int = animated_sprite_2d_bill.get_frame()
	var current_progress: float = animated_sprite_2d_bill.get_frame_progress()
	
	# Conditions for playing animations for jumping and falling respectively
	if not is_on_floor() and shoot_timer.is_stopped():
		if is_jumping == true:
			animated_sprite_2d_bill.play("jump")
		else:
			animated_sprite_2d_bill.play("fall")
			
	# Animation is selected based on look_direction like idle and run
	else:
		# Idle
		if look_direction.x == 0 and look_direction.y == 0:
			animated_sprite_2d_bill.play("default")
		# Run
		elif look_direction.x != 0 and look_direction.y == 0 and shoot_timer.is_stopped():
			animated_sprite_2d_bill.play("run")
			animated_sprite_2d_bill.set_frame_and_progress(current_frame, current_progress)
		# Look Up Right
		elif look_direction.x != 0 and (look_direction.y < 0 and look_direction.y > -1):
			animated_sprite_2d_bill.play("look_up_right")
			animated_sprite_2d_bill.set_frame_and_progress(current_frame, current_progress)
		# Look Up
		elif look_direction.x == 0 and look_direction.y == -1:
			animated_sprite_2d_bill.play("look_up")
		# Look Down Right
		elif look_direction.x != 0 and (look_direction.y > 0 and look_direction.y < 1):
			animated_sprite_2d_bill.play("look_down_right")
			animated_sprite_2d_bill.set_frame_and_progress(current_frame, current_progress)
		# Crouch
		elif look_direction.x == 0 and look_direction.y == 1:
			animated_sprite_2d_bill.play("crouch")

	# Decides if sprite faces left or right
	if run_direction > 0:
		animated_sprite_2d_bill.flip_h = false
	elif run_direction < 0:
		animated_sprite_2d_bill.flip_h = true

	# Chooses appropriate collision shape size and position based on animation
	# Specific collision shape position and size for jumping and crouching
	if animated_sprite_2d_bill.animation == "jump":
		#collision_shape_2d.shape.size.x = 18
		#collision_shape_2d.shape.size.y = 22
		collision_shape_2d.position.x = 0
		collision_shape_2d.position.y = 8
		#area_2d_collision_shape_2d.shape.size.x = 18
		#area_2d_collision_shape_2d.shape.size.y = 22
		area_2d_collision_shape_2d.position.x = 0
		area_2d_collision_shape_2d.position.y = 8
	elif animated_sprite_2d_bill.animation == "crouch":
		#collision_shape_2d.shape.size.x = 30
		#collision_shape_2d.shape.size.y = 15
		collision_shape_2d.position.x = 0
		collision_shape_2d.position.y = 18
		#area_2d_collision_shape_2d.shape.size.x = 30
		#area_2d_collision_shape_2d.shape.size.y = 15
		area_2d_collision_shape_2d.position.x = 0
		area_2d_collision_shape_2d.position.y = 18

	# Collision shape same for all other animations since difference only for
	# left and right variation
	else:
		if animated_sprite_2d_bill.flip_h == false:
			#collision_shape_2d.shape.size.x = 17
			#collision_shape_2d.shape.size.y = 35
			collision_shape_2d.position.x = 2
			collision_shape_2d.position.y = 8.5
			#area_2d_collision_shape_2d.shape.size.x = 17
			#area_2d_collision_shape_2d.shape.size.y = 35
			area_2d_collision_shape_2d.position.x = 2
			area_2d_collision_shape_2d.position.y = 8.5
		else:
			#collision_shape_2d.shape.size.x = 17
			#collision_shape_2d.shape.size.y = 35
			collision_shape_2d.position.x = -3
			collision_shape_2d.position.y = 8.5
			#area_2d_collision_shape_2d.shape.size.x = 17
			#area_2d_collision_shape_2d.shape.size.y = 35
			area_2d_collision_shape_2d.position.x = -3
			area_2d_collision_shape_2d.position.y = 8.5

	# Muzzle position and rotation based on look_direction
	if look_direction.x == 0 and look_direction.y == 0:
		if animated_sprite_2d_bill.flip_h == false:
			muzzle.position.x = 13
			muzzle.position.y = 3
			muzzle.rotation_degrees = 0
		else:
			muzzle.position.x = -13
			muzzle.position.y = 3
			muzzle.rotation_degrees = 180
	elif look_direction.x == 1 and look_direction.y == 0:
		muzzle.position.x = 13
		muzzle.position.y = 3
		muzzle.rotation_degrees = 0
	elif look_direction.x == -1 and look_direction.y == 0:
		muzzle.position.x = -13
		muzzle.position.y = 3
		muzzle.rotation_degrees = 180
	elif look_direction.x > 0 and look_direction.y < 0:
		muzzle.position.x = 6
		muzzle.position.y = -5
		muzzle.rotation_degrees = 333
	elif look_direction.x == 0 and look_direction.y == -1:
		if animated_sprite_2d_bill.flip_h == false:
			muzzle.position.x = 5
			muzzle.position.y = -10
			muzzle.rotation_degrees = 270
		else:
			muzzle.position.x = -5
			muzzle.position.y = -10
			muzzle.rotation_degrees = 270
	elif look_direction.x < 0 and look_direction.y < 0:
		muzzle.position.x = -6
		muzzle.position.y = -5
		muzzle.rotation_degrees = 207
	elif look_direction.x > 0 and look_direction.y > 0:
		muzzle.position.x = 7
		muzzle.position.y = 7
		muzzle.rotation_degrees = 27
	elif look_direction.x == 0 and look_direction.y == 1:
		if is_on_floor():
			if animated_sprite_2d_bill.flip_h == false:
				muzzle.position.x = 12
				muzzle.position.y = 17
				muzzle.rotation_degrees = 0
			else:
				muzzle.position.x = -12
				muzzle.position.y = 17
				muzzle.rotation_degrees = 180
		else:
			muzzle.position.x = 5
			muzzle.position.y = 15
			muzzle.rotation_degrees = 90
	elif look_direction.x < 0 and look_direction.y > 0:
		muzzle.position.x = -7
		muzzle.position.y = 7
		muzzle.rotation_degrees = 153

	# Bullet ID assigned based on number pressed
	if Input.is_action_just_pressed('1'):
		bullet_id = 'R'
	elif Input.is_action_just_pressed('2'):
		bullet_id = 'M'
	elif Input.is_action_just_pressed('3'):
		bullet_id = 'F'
	elif Input.is_action_just_pressed('4'):
		bullet_id = 'L'
	elif Input.is_action_just_pressed('5'):
		bullet_id = 'S'

	# Instantiating all bullets
	bullet_r = bullet_r_path.instantiate()
	bullet_m = bullet_m_path.instantiate()
	bullet_f = bullet_f_path.instantiate()
	bullet_l = bullet_l_path.instantiate()
	bullet_s1 = bullet_s_path.instantiate()
	bullet_s2 = bullet_s_path.instantiate()
	bullet_s3 = bullet_s_path.instantiate()
	bullet_s4 = bullet_s_path.instantiate()
	bullet_s5 = bullet_s_path.instantiate()

	# Performs action depending on which weapon player has (bullet ID)
	# For Regular (R)
	if bullet_id == 'R':
		if Input.is_action_just_pressed("shoot"):
			start_or_stop_shoot_timer(look_direction, run_direction)
			play_shoot_animation(current_frame, current_progress)
			spawn_bullet(bullet_r)
			
	# For Machinegun (M)
	elif bullet_id == 'M':
		# 'Pressed' instead of 'Just_pressed' for Machinegun
		if Input.is_action_pressed("shoot"):
			start_or_stop_shoot_timer(look_direction, run_direction)
			play_shoot_animation(current_frame, current_progress)
			spawn_bullet(bullet_m)

	# For Flame Gun (F) (NOTE: INCOMPLETE)
	elif bullet_id == 'F':
		if Input.is_action_just_pressed("shoot"):
			start_or_stop_shoot_timer(look_direction, run_direction)
			play_shoot_animation(current_frame, current_progress)
			spawn_bullet(bullet_f)

	# For Laser (L)
	elif bullet_id == 'L':
		if Input.is_action_just_pressed("shoot"):
			start_or_stop_shoot_timer(look_direction, run_direction)
			play_shoot_animation(current_frame, current_progress)
			spawn_bullet(bullet_l)

	# For Spreadgun (S)
	elif bullet_id == 'S':
		if Input.is_action_just_pressed("shoot"):
			start_or_stop_shoot_timer(look_direction, run_direction)
			play_shoot_animation(current_frame, current_progress)
			
			spawn_bullet(bullet_s1)
			spawn_bullet(bullet_s2)
			spawn_bullet(bullet_s3)
			spawn_bullet(bullet_s4)
			spawn_bullet(bullet_s5)
			
			# Offsets rotation to fire in spread pattern
			bullet_s2.rotate(0.26)
			bullet_s3.rotate(6.02)
			bullet_s4.rotate(0.52)
			bullet_s5.rotate(5.76)


func _physics_process(delta: float) -> void:
	#var look_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	var run_direction: float = Input.get_axis("left", "right")
	
	# Applies gravity if in air, otherwise sets is_jumping to false
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		is_jumping = false
	
	# Jump code
	if Input.is_action_just_pressed("jump") and is_on_floor():
		is_jumping = true
		velocity.y = JUMP_SPEED
	
	# Idle if no run_direction, else player runs
	if run_direction == 0:
		if is_jumping == false:
			velocity.x = 0
	else:
		velocity.x = run_direction * RUN_SPEED
		
	# Godot function for player movement
	# "convenient way to implement sliding movement without writing much code." (Godot 4.4 Docs)
	#print(-velocity.x)
	var mas: bool = move_and_slide()
	print(mas)

# Starts shoot_timer if player shoots, else stops
func start_or_stop_shoot_timer(look_direction: Vector2, run_direction: float) -> void:
	if is_on_floor() and look_direction.y == 0 and run_direction != 0:
		shoot_timer.start()
	else:
		shoot_timer.stop()


# Plays shoot animation in current frame while player is shooting
func play_shoot_animation(current_frame: int, current_progress: float) -> void:
	if not shoot_timer.is_stopped():
		animated_sprite_2d_bill.play("shoot")
		animated_sprite_2d_bill.set_frame_and_progress(current_frame, current_progress)


# Adds bullet to scene tree and sets bullet position, rotation and scale
func spawn_bullet(bullet: Area2D) -> void:
	owner.add_child(bullet)
	bullet.position = muzzle.global_position
	bullet.rotation = muzzle.global_rotation
	bullet.scale.x = 1
	bullet.scale.y = 1
