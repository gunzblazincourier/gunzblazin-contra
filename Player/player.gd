extends CharacterBody2D
## Protagonist of Contra (named Bill)
##
## Handles player states, movement, and collision and hitbox detection

## All states of the player
enum States {IDLE, LOOK_UP, CROUCH, RUN, JUMP, JUMP_UP, JUMP_DOWN, FALL, \
		FALL_UP, SHOOT_IDLE, SHOOT_LOOK_UP, SHOOT_CROUCH, SHOOT_RUN, \
		SHOOT_JUMP, SHOOT_JUMP_UP, SHOOT_JUMP_DOWN, SHOOT_FALL, SHOOT_FALL_UP, \
		DEATH}

const RUN_SPEED: int = 69				## Fixed run speed
const JUMP_SPEED: int = -250			## Fixed jump speed
const DEATH_JUMP_SPEED: int = -175		## Jump speed specifically DEATH state
const GRAVITY: int = 555				## Custom gravity for the player

var state: States					## Current state from the 'States' enum
var sprite_direction: float			## Current sprite direction
var death_direction: float			## Current death direction
var is_jump_pressed: bool			## Checks whether player has pressed 'Jump'
var is_above_water: bool			## Whether player is above water

# Declared and defined in beginning instead of while shooting (see in _process())
# in order to allow previously fired laser to despawn when new is fired
## Path to Lasergun bullet (Type L)
var bullet_l_path: PackedScene
## Instance of Lasergun bullet (Type L)
var bullet_l: Area2D

## Animation tree
@onready var animation_tree: AnimationTree = $AnimationTree

## CollisionShape to detect collision
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Sound plays from player scene instead of respective bullet scenes since
# SFX abruptly stop when bullet queue_frees
## Plays the Regulargun firing sound effect
@onready var regulargun_sfx: AudioStreamPlayer2D = $RegulargunSFX
## Plays the Machinegun firing sound effect
@onready var machinegun_sfx: AudioStreamPlayer2D = $MachinegunSFX
## Plays the Spreadgun firing sound effect
@onready var spreadgun_sfx: AudioStreamPlayer2D = $SpreadgunSFX

## Plays the Lasergun firing sound effect
@onready var lasergun_sfx: AudioStreamPlayer2D = $LasergunSFX

## RayCast that extends downward beyond game world to detect surface under player
@onready var ray_cast_2d: RayCast2D = $RayCast2D

## Controls duration of corresponding SHOOT state
@onready var shoot_timer: Timer = $ShootTimer

## Decides how long player collision is disabled while falling through floors
@onready var fall_through_timer: Timer = $FallThroughTimer

## Movement prevented while falling until timer timeouts
@onready var fall_movement_timer: Timer = $FallMovementTimer

## Controls rate of fire of Machinegun
@onready var machinegun_interval_timer: Timer = $MachinegunIntervalTimer

## How long the player is invincible when it spawns
@onready var invincibility_timer: Timer = $InvincibilityTimer

# Flashing intensity is less than original game since low wait time leads to
# inconsistent behaviour between framerates
## Flashing intensity during invincibility phase
@onready var flashing_timer: Timer = $FlashingTimer

## Gun muzzle
@onready var muzzle: Marker2D = $Muzzle

## Hitbox area of player
@onready var hitbox: Area2D = $Hitbox
@onready var death_timer: Timer = $DeathTimer


func _ready() -> void:
	# Slows down/speed up the game
	#Engine.time_scale = 0.5
	
	# Initialization of variables declared at beginning
	animation_tree.set("parameters/conditions/death", false)
	animation_tree.active = true
	state = States.JUMP
	sprite_direction = 1.0
	death_direction = -1.0
	is_jump_pressed = true
	is_above_water = false
	bullet_l_path = load("res://Bullet/bullet_l.tscn")
	bullet_l = bullet_l_path.instantiate()


func _process(_delta: float) -> void:
	#print(ray_cast_2d.is_colliding())
	## 'Vanish' player when he runs out of lives
	if Global.lives < 0:
		visible = false
		process_mode = Node.PROCESS_MODE_DISABLED
		hitbox.set_deferred("monitorable", false)
		hitbox.set_deferred("monitoring", false)
	
	## Arrow key(s) currently pressed
	var look_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	## Direction that player is running
	var run_direction: float = Input.get_axis("left", "right")
	
	# Conditional sprite direction assignment
	if run_direction != 0 and fall_movement_timer.is_stopped():
		sprite_direction = run_direction
	
	Global.player_sprite_direction = sprite_direction
	
	# Deciding whether 'Jump' was pressed
	if is_jump_pressed == true:
		if is_on_floor():
			is_jump_pressed = false
	else:
		if velocity.y < 0:
			is_jump_pressed = true
	
	# Variables for AnimationTree advance conditions
	var idle: bool = is_on_floor() and look_direction == Vector2(0, 0)
	var look_up: bool = is_on_floor() and look_direction == Vector2(0, -1)
	var crouch: bool = is_on_floor() and look_direction == Vector2(0, 1)
	var run: bool = is_on_floor() and look_direction.x != 0
	var jump: bool = not is_on_floor() and is_jump_pressed and \
			look_direction != Vector2(0, -1) and look_direction != Vector2(0, 1) and death_timer.is_stopped()
	var jump_up: bool = not is_on_floor() and is_jump_pressed and \
			look_direction == Vector2(0, -1) and death_timer.is_stopped()
	var jump_down: bool = not is_on_floor() and is_jump_pressed and \
			look_direction == Vector2(0, 1) and death_timer.is_stopped()
	var fall: bool = not is_on_floor() and not is_jump_pressed and \
			look_direction != Vector2(0, -1) and death_timer.is_stopped()
	var fall_up: bool = not is_on_floor() and not is_jump_pressed and \
			look_direction == Vector2(0, -1) and death_timer.is_stopped()
	
	# Assigning values to AnimationTree variables using respective script variables
	animation_tree.set("parameters/conditions/idle", idle)
	animation_tree.set("parameters/conditions/look_up", look_up)
	animation_tree.set("parameters/conditions/crouch", crouch)
	animation_tree.set("parameters/conditions/run", run)
	animation_tree.set("parameters/conditions/jump", jump)
	animation_tree.set("parameters/conditions/jump_up", jump_up)
	animation_tree.set("parameters/conditions/jump_down", jump_down)
	animation_tree.set("parameters/conditions/fall", fall)
	animation_tree.set("parameters/conditions/fall_up", fall_up)
	
	# Deciding simple blend positions
	animation_tree.set("parameters/Idle/blend_position", sprite_direction)
	animation_tree.set("parameters/LookUp/blend_position", sprite_direction)
	animation_tree.set("parameters/Crouch/blend_position", sprite_direction)
	animation_tree.set("parameters/Run/blend_position", look_direction)
	animation_tree.set("parameters/JumpUp/blend_position", sprite_direction)
	animation_tree.set("parameters/JumpDown/blend_position", sprite_direction)
	animation_tree.set("parameters/FallUp/blend_position", sprite_direction)
	animation_tree.set("parameters/ShootIdle/blend_position", sprite_direction)
	animation_tree.set("parameters/ShootLookUp/blend_position", sprite_direction)
	animation_tree.set("parameters/ShootCrouch/blend_position", sprite_direction)
	animation_tree.set("parameters/ShootRun/blend_position", look_direction)
	animation_tree.set("parameters/ShootJumpUp/blend_position", sprite_direction)
	animation_tree.set("parameters/ShootJumpDown/blend_position", sprite_direction)
	animation_tree.set("parameters/ShootFallUp/blend_position", sprite_direction)
	
	# Dynamic blend positions
	if look_direction == Vector2.ZERO:
		animation_tree.set("parameters/Jump/blend_position", Vector2(sprite_direction, 0))
		animation_tree.set("parameters/ShootJump/blend_position", Vector2(sprite_direction, 0))
		animation_tree.set("parameters/Fall/blend_position", Vector2(sprite_direction, 0))
		animation_tree.set("parameters/ShootFall/blend_position", Vector2(sprite_direction, 0))
	else:
		animation_tree.set("parameters/Jump/blend_position", look_direction)
		animation_tree.set("parameters/ShootJump/blend_position", look_direction)
		if look_direction == Vector2(0, 1) or not fall_movement_timer.is_stopped():
			animation_tree.set("parameters/Fall/blend_position", Vector2(sprite_direction, 0))
			animation_tree.set("parameters/ShootFall/blend_position", Vector2(sprite_direction, 0))
		else:
			animation_tree.set("parameters/Fall/blend_position", look_direction)
			animation_tree.set("parameters/ShootFall/blend_position", look_direction)
	
	# Gets AnimationNodeStateMachine from AnimationTree
	var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
	
	# Current state in AnimationNodeStateMachine
	var state_machine_state: StringName = state_machine.get_current_node()
	
	# Matching current state in script to that in AnimationTree
	match state_machine_state:
		"Idle":
			state = States.IDLE
		"LookUp":
			state = States.LOOK_UP
		"Crouch":
			state = States.CROUCH
		"Run":
			state = States.RUN
		"Jump":
			state = States.JUMP
		"JumpUp":
			state = States.JUMP_UP
		"JumpDown":
			state = States.JUMP_DOWN
		"Fall":
			state = States.FALL
		"FallUp":
			state = States.FALL_UP
		"ShootIdle":
			state = States.SHOOT_IDLE
		"ShootLookUp":
			state = States.SHOOT_LOOK_UP
		"ShootCrouch":
			state = States.SHOOT_CROUCH
		"ShootRun":
			state = States.SHOOT_RUN
		"ShootJump":
			state = States.SHOOT_JUMP
		"ShootJumpUp":
			state = States.SHOOT_JUMP_UP
		"ShootJumpDown":
			state = States.SHOOT_JUMP_DOWN
		"ShootFall":
			state = States.SHOOT_FALL
		"ShootFallUp":
			state = States.SHOOT_FALL_UP
		"Death":
			state = States.DEATH
	#print(state)
	#print(animation_tree.get("parameters/Jump/blend_position"))
	#print(run_direction)
	
	# Weapon behaviour
	match state:
		States.DEATH:
			pass
		_:
			match Global.weapon:
				Global.Weapons.R:
					if Input.is_action_just_pressed("shoot"):
						shoot_timer.start()
						regulargun_sfx.play()
						var bullet_r_path: PackedScene = load("res://Bullet/bullet_r.tscn")
						var bullet_r: Area2D = bullet_r_path.instantiate()
						spawn_bullet(bullet_r)
				
				Global.Weapons.S:
					if Input.is_action_just_pressed("shoot"):
						shoot_timer.start()
						spreadgun_sfx.play()
						var bullet_s_path: PackedScene = load("res://Bullet/bullet_s.tscn")
						var bullet_s1: Area2D = bullet_s_path.instantiate()
						var bullet_s2: Area2D = bullet_s_path.instantiate()
						var bullet_s3: Area2D = bullet_s_path.instantiate()
						var bullet_s4: Area2D = bullet_s_path.instantiate()
						var bullet_s5: Area2D = bullet_s_path.instantiate()
						
						spawn_bullet(bullet_s1)
						spawn_bullet(bullet_s2)
						spawn_bullet(bullet_s3)
						spawn_bullet(bullet_s4)
						spawn_bullet(bullet_s5)
						
						bullet_s2.rotate(0.26)
						bullet_s3.rotate(6.02)
						bullet_s4.rotate(0.52)
						bullet_s5.rotate(5.76)
				
				Global.Weapons.L:
					if Input.is_action_just_pressed("shoot"):
						shoot_timer.start()
						lasergun_sfx.play()
						spawn_bullet(bullet_l)
				
				Global.Weapons.M:
					# NOTE: 'pressed' instead of 'just_pressed'
					if Input.is_action_pressed("shoot"):
						shoot_timer.start()
						if machinegun_interval_timer.is_stopped():
							machinegun_sfx.play()
						if machinegun_interval_timer.is_stopped():
							var bullet_m_path: PackedScene = load("res://Bullet/bullet_m.tscn")
							var bullet_m: Area2D = bullet_m_path.instantiate()
							spawn_bullet(bullet_m)
							machinegun_interval_timer.start()
				
				Global.Weapons.F:
					if Input.is_action_just_pressed("shoot"):
						shoot_timer.start()
						var bullet_f_path: PackedScene = load("res://Bullet/bullet_f.tscn")
						var bullet_f: Area2D = bullet_f_path.instantiate()
						
						spawn_bullet(bullet_f)
						#bullet_f.rotate(sprite_direction * 1.75*PI)
						#bullet_f.rotate(sprite_direction * -PI/2)
						bullet_f.rotate(sprite_direction * -PI/3)


func _physics_process(delta: float) -> void:
	## Direction that player is running
	var run_direction: float = Input.get_axis("left", "right")
	
	Global.player_global_position = global_position
	
	match state:
		States.IDLE, States.LOOK_UP, States.SHOOT_IDLE, States.SHOOT_LOOK_UP:
			velocity.x = move_toward(velocity.x, 0, RUN_SPEED)
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_SPEED
		States.RUN, States.SHOOT_RUN:
			velocity.x = run_direction * RUN_SPEED
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_SPEED
		States.CROUCH, States.SHOOT_CROUCH:
			velocity.x = run_direction * RUN_SPEED
			if ray_cast_2d.is_colliding() and Input.is_action_just_pressed("jump"):
				collision_shape_2d.disabled = true
				fall_through_timer.start()
		States.JUMP, States.JUMP_UP, States.JUMP_DOWN, States.SHOOT_JUMP, \
				States.SHOOT_JUMP_UP, States.SHOOT_JUMP_DOWN:
			if run_direction != 0:
				velocity.x = run_direction * RUN_SPEED
			velocity.y += GRAVITY * delta
		States.FALL, States.FALL_UP, States.SHOOT_FALL, States.SHOOT_FALL_UP:
			if velocity.y < 10:
				fall_movement_timer.start()
			if fall_movement_timer.is_stopped():
				if run_direction != 0:
					velocity.x = run_direction * RUN_SPEED
			velocity.y += GRAVITY * delta
		States.DEATH:
			velocity.y += GRAVITY * delta
			if not is_on_floor():
				velocity.x = death_direction * RUN_SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, RUN_SPEED)
	
	# Godot function for player movement
	var mas: bool = move_and_slide()
	
	# To prevent 'return value discarded' error
	if mas:
		pass


## Death when player collides with enemy or killbox
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") or area.is_in_group("killbox") or \
			area.is_in_group("enemy_bullet"):
		animation_tree.set("parameters/conditions/death", true)
		death_timer.start()
		animation_tree.set("parameters/Death/blend_position", sprite_direction)
		velocity.y = DEATH_JUMP_SPEED
		death_direction = sprite_direction * -1


## Collision reenabled
func _on_fall_through_timer_timeout() -> void:
	collision_shape_2d.disabled = false


## Child added to scene tree, position and rotation set to muzzle's
func spawn_bullet(bullet: Area2D) -> void:
	owner.add_child(bullet)
	bullet.position = muzzle.global_position
	bullet.rotation = muzzle.global_rotation


## Player won't be invincible after time's over
func _on_invincibility_timer_timeout() -> void:
	hitbox.set_deferred("monitorable", true)
	hitbox.set_deferred("monitoring", true)
	visible = true
	flashing_timer.stop()


## Repeatedly toggles visibility of player to create invincibility flashing
func _on_flashing_timer_timeout() -> void:
	if visible == true:
		visible = false
	else:
		visible = true


func _on_death_timer_timeout() -> void:
	death_direction = 0
	animation_tree.set("parameters/conditions/death", false)
	is_jump_pressed = true
	global_position.x = Global.left_boundary_position.x + 14
	global_position.y = -110
	hitbox.set_deferred("monitorable", false)
	hitbox.set_deferred("monitoring", false)
	invincibility_timer.start()
	flashing_timer.start()
	Global.lives -= 1
