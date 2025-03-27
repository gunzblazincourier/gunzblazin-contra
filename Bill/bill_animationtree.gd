extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree

enum states {IDLE, LOOK_UP, CROUCH, RUN, JUMP}
var current_state: states

# Direction that sprite is currently facing; needed for blend position of states like IDLE
var sprite_direction: float

const RUN_SPEED: int = 100
const JUMP_SPEED: int = -300
const GRAVITY: int = 666


func _ready() -> void:
	# Slows down/speed up the game
	#Engine.time_scale = 0.2
	
	animation_tree.active = true
	current_state = states.JUMP
	sprite_direction = 1


func _process(_delta: float) -> void:
	var look_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	var run_direction: float = Input.get_axis("left", "right")
	
	# To avoid setting sprite direction to 0, since sprite can only face left or right
	if run_direction != 0:
		sprite_direction = run_direction
	
	# Will set the advance condition value of respective states
	# Set after storing in variable instead of setting directly because of long statements
	var idle: bool = is_on_floor() and look_direction.x == 0 and look_direction.y == 0
	var look_up: bool = is_on_floor() and look_direction.x == 0 and look_direction.y == -1
	var crouch: bool = is_on_floor() and look_direction.x == 0 and look_direction.y == 1
	
	# Sets advance condition true or false for each state
	animation_tree.set("parameters/conditions/idle", idle)
	animation_tree.set("parameters/conditions/look_up", look_up)
	animation_tree.set("parameters/conditions/crouch", crouch)
	
	# Sets blend position (direction) for each state so appropriate animation can be displayed
	animation_tree.set("parameters/Idle/blend_position", sprite_direction)
	animation_tree.set("parameters/LookUp/blend_position", sprite_direction)
	animation_tree.set("parameters/Crouch/blend_position", sprite_direction)
	animation_tree.set("parameters/Run/blend_position", look_direction)
	animation_tree.set("parameters/Jump/blend_position", sprite_direction)
	
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
		states.IDLE, states.RUN, states.LOOK_UP:
			# If run_direction is 0 then velocity.x is 0, so player is IDLE
			velocity.x = run_direction * RUN_SPEED
			# Transition to JUMP
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_SPEED
		# Same as above but without jump code (player cannot jump while crouched)
		states.CROUCH:
			# If run_direction is 0 then velocity.x is 0, so player is IDLE
			velocity.x = run_direction * RUN_SPEED
		# Documentation for JUMP in comments just above match statement
		states.JUMP:
			if run_direction != 0:
				velocity.x = run_direction * RUN_SPEED
			velocity.y += GRAVITY * delta
	
	# Godot function for player movement
	# "convenient way to implement sliding movement without writing much code." (Godot 4.4 Docs)
	var mas: bool = move_and_slide()
	
	# To prevent 'return value discarded' error
	if mas:
		pass
