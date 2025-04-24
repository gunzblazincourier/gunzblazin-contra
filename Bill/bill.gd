# NOTE: Flamegun (F) incomplete

extends CharacterBody2D

enum states {IDLE, LOOK_UP, CROUCH, RUN, JUMP, JUMP_UP, JUMP_DOWN, FALL, \
		FALL_UP, FALL_DOWN, SHOOT_IDLE, SHOOT_LOOK_UP, SHOOT_CROUCH, SHOOT_RUN, \
		SHOOT_JUMP, SHOOT_JUMP_UP, SHOOT_JUMP_DOWN, SHOOT_FALL, SHOOT_FALL_UP, \
		SHOOT_FALL_DOWN, DEATH}
enum bullet_id {R, M, S, F, L}

const RUN_SPEED: int = 69
const JUMP_SPEED: int = -250
const DEATH_JUMP_SPEED: int = -175
const GRAVITY: int = 555

var current_state: states
var current_bullet_id: bullet_id
var sprite_direction: float
var death_direction: float
var jump_pressed: bool

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var shoot_timer: Timer = $ShootTimer
@onready var muzzle: Marker2D = $Muzzle
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var fall_through_timer: Timer = $FallThroughTimer


func _ready() -> void:
	# Slows down/speed up the game
	#Engine.time_scale = 0.5
	#Global.player_global_position = global_position
	
	animation_tree.set("parameters/conditions/death", false)
	animation_tree.active = true
	current_state = states.JUMP
	sprite_direction = 1.0
	death_direction = -1.0
	jump_pressed = true
	current_bullet_id = bullet_id.R


func _process(_delta: float) -> void:
	var look_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	var run_direction: float = Input.get_axis("left", "right")
	
	if run_direction != 0:
		sprite_direction = run_direction
	
	if jump_pressed == true:
		if is_on_floor():
			jump_pressed = false
	else:
		if velocity.y < 0:
			jump_pressed = true
	
	var idle: bool = is_on_floor() and look_direction == Vector2(0, 0)
	var look_up: bool = is_on_floor() and look_direction == Vector2(0, -1)
	var crouch: bool = is_on_floor() and look_direction == Vector2(0, 1)
	var run: bool = is_on_floor() and look_direction.x != 0
	var jump: bool = not is_on_floor() and jump_pressed and look_direction != Vector2(0, -1) and \
			look_direction != Vector2(0, 1)
	var jump_up: bool = not is_on_floor() and jump_pressed and look_direction == Vector2(0, -1)
	var jump_down: bool = not is_on_floor() and jump_pressed and look_direction == Vector2(0, 1)
	var fall: bool = not is_on_floor() and not jump_pressed and look_direction != Vector2(0, -1) and \
			look_direction != Vector2(0, 1)
	var fall_up: bool = not is_on_floor() and not jump_pressed and look_direction == Vector2(0, -1)
	var fall_down: bool = not is_on_floor() and not jump_pressed and look_direction == Vector2(0, 1)
	
	animation_tree.set("parameters/conditions/idle", idle)
	animation_tree.set("parameters/conditions/look_up", look_up)
	animation_tree.set("parameters/conditions/crouch", crouch)
	animation_tree.set("parameters/conditions/run", run)
	animation_tree.set("parameters/conditions/jump", jump)
	animation_tree.set("parameters/conditions/jump_up", jump_up)
	animation_tree.set("parameters/conditions/jump_down", jump_down)
	animation_tree.set("parameters/conditions/fall", fall)
	animation_tree.set("parameters/conditions/fall_up", fall_up)
	animation_tree.set("parameters/conditions/fall_down", fall_down)
	
	animation_tree.set("parameters/Idle/blend_position", sprite_direction)
	animation_tree.set("parameters/LookUp/blend_position", sprite_direction)
	animation_tree.set("parameters/Crouch/blend_position", sprite_direction)
	animation_tree.set("parameters/Run/blend_position", look_direction)
	animation_tree.set("parameters/JumpUp/blend_position", sprite_direction)
	animation_tree.set("parameters/JumpDown/blend_position", sprite_direction)
	animation_tree.set("parameters/FallUp/blend_position", sprite_direction)
	animation_tree.set("parameters/FallDown/blend_position", sprite_direction)
	animation_tree.set("parameters/ShootIdle/blend_position", sprite_direction)
	animation_tree.set("parameters/ShootLookUp/blend_position", sprite_direction)
	animation_tree.set("parameters/ShootCrouch/blend_position", sprite_direction)
	animation_tree.set("parameters/ShootRun/blend_position", look_direction)
	animation_tree.set("parameters/ShootJumpUp/blend_position", sprite_direction)
	animation_tree.set("parameters/ShootJumpDown/blend_position", sprite_direction)
	animation_tree.set("parameters/ShootFallUp/blend_position", sprite_direction)
	animation_tree.set("parameters/ShootFallDown/blend_position", sprite_direction)
	
	if look_direction == Vector2.ZERO:
		animation_tree.set("parameters/Jump/blend_position", Vector2(sprite_direction, 0))
		animation_tree.set("parameters/ShootJump/blend_position", Vector2(sprite_direction, 0))
		animation_tree.set("parameters/Fall/blend_position", Vector2(sprite_direction, 0))
		animation_tree.set("parameters/ShootFall/blend_position", Vector2(sprite_direction, 0))
	else:
		animation_tree.set("parameters/Jump/blend_position", look_direction)
		animation_tree.set("parameters/ShootJump/blend_position", look_direction)
		animation_tree.set("parameters/Fall/blend_position", look_direction)
		animation_tree.set("parameters/ShootFall/blend_position", look_direction)
	
	# Basically gets AnimationNodeStateMachine from AnimationTree
	var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
	
	# Current state in AnimationNodeStateMachine
	var state_machine_state: StringName = state_machine.get_current_node()
	
	match state_machine_state:
		"Idle":
			current_state = states.IDLE
		"LookUp":
			current_state = states.LOOK_UP
		"Crouch":
			current_state = states.CROUCH
		"Run":
			current_state = states.RUN
		"Jump":
			current_state = states.JUMP
		"JumpUp":
			current_state = states.JUMP_UP
		"JumpDown":
			current_state = states.JUMP_DOWN
		"Fall":
			current_state = states.FALL
		"FallUp":
			current_state = states.FALL_UP
		"FallDown":
			current_state = states.FALL_DOWN
		"ShootIdle":
			current_state = states.SHOOT_IDLE
		"ShootLookUp":
			current_state = states.SHOOT_LOOK_UP
		"ShootCrouch":
			current_state = states.SHOOT_CROUCH
		"ShootRun":
			current_state = states.SHOOT_RUN
		"ShootJump":
			current_state = states.SHOOT_JUMP
		"ShootJumpUp":
			current_state = states.SHOOT_JUMP_UP
		"ShootJumpDown":
			current_state = states.SHOOT_JUMP_DOWN
		"ShootFall":
			current_state = states.SHOOT_FALL
		"ShootFallUp":
			current_state = states.SHOOT_FALL_UP
		"ShootFallDown":
			current_state = states.SHOOT_FALL_DOWN
		"Death":
			current_state = states.DEATH
	
	if Input.is_action_just_pressed("1"):
		current_bullet_id = bullet_id.R
	elif Input.is_action_just_pressed("2"):
		current_bullet_id = bullet_id.S
	elif Input.is_action_just_pressed("3"):
		current_bullet_id = bullet_id.L
	
	match current_state:
		states.DEATH:
			pass
		_:
			match current_bullet_id:
				bullet_id.R:
					if Input.is_action_just_pressed("shoot"):
						shoot_timer.start()
						var bullet_r_path: PackedScene = load("res://Bullet/bullet_r.tscn")
						var bullet_r: Area2D = bullet_r_path.instantiate()
						
						owner.add_child(bullet_r)
						bullet_r.position = muzzle.global_position
						bullet_r.rotation = muzzle.global_rotation
				
				bullet_id.S:
					if Input.is_action_just_pressed("shoot"):
						shoot_timer.start()
						var bullet_s_path: PackedScene = load("res://Bullet/bullet_s.tscn")
						var bullet_s1: Area2D = bullet_s_path.instantiate()
						var bullet_s2: Area2D = bullet_s_path.instantiate()
						var bullet_s3: Area2D = bullet_s_path.instantiate()
						var bullet_s4: Area2D = bullet_s_path.instantiate()
						var bullet_s5: Area2D = bullet_s_path.instantiate()
						
						owner.add_child(bullet_s1)
						bullet_s1.position = muzzle.global_position
						bullet_s1.rotation = muzzle.global_rotation
						owner.add_child(bullet_s2)
						bullet_s2.position = muzzle.global_position
						bullet_s2.rotation = muzzle.global_rotation
						owner.add_child(bullet_s3)
						bullet_s3.position = muzzle.global_position
						bullet_s3.rotation = muzzle.global_rotation
						owner.add_child(bullet_s4)
						bullet_s4.position = muzzle.global_position
						bullet_s4.rotation = muzzle.global_rotation
						owner.add_child(bullet_s5)
						bullet_s5.position = muzzle.global_position
						bullet_s5.rotation = muzzle.global_rotation
						
						bullet_s2.rotate(0.26)
						bullet_s3.rotate(6.02)
						bullet_s4.rotate(0.52)
						bullet_s5.rotate(5.76)
				
				bullet_id.L:
					if Input.is_action_just_pressed("shoot"):
						shoot_timer.start()
						var bullet_l_path: PackedScene = load("res://Bullet/bullet_l.tscn")
						var bullet_l: Area2D = bullet_l_path.instantiate()
						
						owner.add_child(bullet_l)
						bullet_l.position = muzzle.global_position
						bullet_l.rotation = muzzle.global_rotation
	#print(state_machine_state)


func _physics_process(delta: float) -> void:
	Global.player_global_position = global_position
	var run_direction: float = Input.get_axis("left", "right")
	
	match current_state:
		states.IDLE, states.LOOK_UP, states.SHOOT_IDLE, states.SHOOT_LOOK_UP:
			velocity.x = move_toward(velocity.x, 0, RUN_SPEED)
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_SPEED
		states.RUN, states.SHOOT_RUN:
			velocity.x = run_direction * RUN_SPEED
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_SPEED
		states.CROUCH, states.SHOOT_CROUCH:
			velocity.x = run_direction * RUN_SPEED
			if Input.is_action_just_pressed("jump"):
				collision_shape_2d.disabled = true
				fall_through_timer.start()
		states.JUMP, states.JUMP_UP, states.JUMP_DOWN, states.SHOOT_JUMP, \
				states.SHOOT_JUMP_UP, states.SHOOT_JUMP_DOWN, states.FALL, \
				states.FALL_UP, states.FALL_DOWN, states.SHOOT_FALL, \
				states.SHOOT_FALL_UP, states.SHOOT_FALL_DOWN:
			if run_direction != 0:
				velocity.x = run_direction * RUN_SPEED
			velocity.y += GRAVITY * delta
		states.DEATH:
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


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		#print("dead")
		animation_tree.set("parameters/conditions/death", true)
		animation_tree.set("parameters/Death/blend_position", sprite_direction)
		velocity.y = DEATH_JUMP_SPEED
		death_direction = sprite_direction * -1


func _on_fall_through_timer_timeout() -> void:
	collision_shape_2d.disabled = false

func spawn_bullet(bullet: Area2D) -> void:
	owner.add_child(bullet)
	bullet.position = muzzle.global_position
	bullet.rotation = muzzle.global_rotation
