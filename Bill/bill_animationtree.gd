# NOTE: Flamegun (F) incomplete

extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var shoot_timer: Timer = $ShootTimer
@onready var muzzle: Marker2D = $Muzzle

enum states {IDLE, LOOK_UP, CROUCH, RUN, JUMP, JUMP_UP, JUMP_DOWN, SHOOT_IDLE, \
		SHOOT_LOOK_UP, SHOOT_CROUCH, SHOOT_RUN, SHOOT_JUMP, SHOOT_JUMP_UP, \
		SHOOT_JUMP_DOWN, DEATH}
var current_state: states

enum bullet_id {R, M, S, F, L}
var current_bullet_id: bullet_id

# Direction that sprite is currently facing; needed for blend position of states
# like IDLE
var sprite_direction: float

# 
var death_direction: float

const RUN_SPEED: int = 69
const JUMP_SPEED: int = -321
const DEATH_JUMP_SPEED: int = -175
const GRAVITY: int = 666


func _ready() -> void:
	# Slows down/speed up the game
	#Engine.time_scale = 0.5
	
	animation_tree.set("parameters/conditions/death", false)
	animation_tree.active = true
	current_state = states.JUMP
	sprite_direction = 1.0
	death_direction = -1.0
	current_bullet_id = bullet_id.R


func _process(_delta: float) -> void:
	var look_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	var run_direction: float = Input.get_axis("left", "right")
	
	# To avoid setting sprite direction to 0, since sprite can only face left or right
	if run_direction != 0:
		sprite_direction = run_direction
	
	# Will set the advance condition value of respective states
	# Set after storing in variable instead of setting directly because of long statements
	var idle: bool = is_on_floor() and look_direction == Vector2(0, 0)
	var look_up: bool = is_on_floor() and look_direction == Vector2(0, -1)
	var crouch: bool = is_on_floor() and look_direction == Vector2(0, 1)
	var run: bool = is_on_floor() and look_direction.x != 0
	var jump: bool = not is_on_floor() and look_direction != Vector2(0, -1) and \
			look_direction != Vector2(0, 1)
	var jump_up: bool = not is_on_floor() and look_direction == Vector2(0, -1)
	var jump_down: bool = not is_on_floor() and look_direction == Vector2(0, 1)
	
	# Sets advance condition true or false for each state
	animation_tree.set("parameters/conditions/idle", idle)
	animation_tree.set("parameters/conditions/look_up", look_up)
	animation_tree.set("parameters/conditions/crouch", crouch)
	animation_tree.set("parameters/conditions/run", run)
	animation_tree.set("parameters/conditions/jump", jump)
	animation_tree.set("parameters/conditions/jump_up", jump_up)
	animation_tree.set("parameters/conditions/jump_down", jump_down)
	
	# Sets blend position (direction) for each state so appropriate animation can be displayed
	animation_tree.set("parameters/Idle/blend_position", sprite_direction)
	animation_tree.set("parameters/LookUp/blend_position", sprite_direction)
	animation_tree.set("parameters/Crouch/blend_position", sprite_direction)
	animation_tree.set("parameters/Run/blend_position", look_direction)
	animation_tree.set("parameters/JumpUp/blend_position", sprite_direction)
	animation_tree.set("parameters/JumpDown/blend_position", sprite_direction)
	animation_tree.set("parameters/ShootIdle/blend_position", sprite_direction)
	animation_tree.set("parameters/ShootLookUp/blend_position", sprite_direction)
	animation_tree.set("parameters/ShootCrouch/blend_position", sprite_direction)
	animation_tree.set("parameters/ShootRun/blend_position", look_direction)
	animation_tree.set("parameters/ShootJumpUp/blend_position", sprite_direction)
	animation_tree.set("parameters/ShootJumpDown/blend_position", sprite_direction)
	
	# Different blend spaces based on different situations
	if look_direction == Vector2.ZERO:
		animation_tree.set("parameters/Jump/blend_position", Vector2(sprite_direction, 0))
		animation_tree.set("parameters/ShootJump/blend_position", Vector2(sprite_direction, 0))
	else:
		animation_tree.set("parameters/Jump/blend_position", look_direction)
		animation_tree.set("parameters/ShootJump/blend_position", look_direction)
	
	# Basically gets AnimationNodeStateMachine from AnimationTree
	var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
	
	# Current state in AnimationNodeStateMachine
	var state_machine_state: StringName = state_machine.get_current_node()
	
	# Sets state in script as per state in StateMachine (AnimationNodeStateMachine)
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
		"Death":
			current_state = states.DEATH
	
	if Input.is_action_just_pressed("1"):
		current_bullet_id = bullet_id.R
	elif Input.is_action_just_pressed("2"):
		current_bullet_id = bullet_id.S
	elif Input.is_action_just_pressed("3"):
		current_bullet_id = bullet_id.L
	
	match(current_bullet_id):
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
				
				# Offsets rotation to fire in spread pattern
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
	print(state_machine_state)

func _physics_process(delta: float) -> void:
	var run_direction: float = Input.get_axis("left", "right")
	
	# Build the movement side of each state using composition principles by having relevant code
	# concerned only with that state.
	# Eg: For the JUMP state, we do not need code to begin the jump since we are
	# already jumping (that code is for states like IDLE and RUN to transition to JUMP).
	# It only has instructions for applying gravity on player, for horizontal movement
	# and to keep moving horizontally even when no directional key is pressed (last direction
	# is used)
	match current_state:
		states.IDLE, states.LOOK_UP, states.SHOOT_IDLE, states.SHOOT_LOOK_UP:
			velocity.x = move_toward(velocity.x, 0, RUN_SPEED)
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_SPEED
		states.RUN, states.SHOOT_RUN:
			velocity.x = run_direction * RUN_SPEED
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_SPEED
		# Same as above but without jump code (player cannot jump while crouched)
		states.CROUCH, states.SHOOT_CROUCH:
			velocity.x = run_direction * RUN_SPEED
		# Documentation in comments just above match statement
		states.JUMP, states.JUMP_UP, states.JUMP_DOWN, states.SHOOT_JUMP, states.SHOOT_JUMP_UP, \
				states.SHOOT_JUMP_DOWN:
			if run_direction != 0:
				velocity.x = run_direction * RUN_SPEED
			velocity.y += GRAVITY * delta
		states.DEATH:
			velocity.y += GRAVITY * delta
			if not is_on_floor():
				velocity.x = death_direction * RUN_SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, RUN_SPEED)
	
	print(velocity.x)
	# Godot function for player movement
	# "convenient way to implement sliding movement without writing much code." (Godot 4.4 Docs)
	var mas: bool = move_and_slide()
	
	# To prevent 'return value discarded' error
	if mas:
		pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		animation_tree.set("parameters/conditions/death", true)
		animation_tree.set("parameters/Death/blend_position", sprite_direction)
		velocity.y = DEATH_JUMP_SPEED
		death_direction = sprite_direction * -1
		#velocity.x = sprite_direction * RUN_SPEED
		print(velocity.x)
