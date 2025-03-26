extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree

enum states {IDLE, RUN, JUMP}
var current_state: states

var last_facing_direction: float
#var is_jumping: bool

const RUN_SPEED: int = 100
const JUMP_SPEED: int = -300
const GRAVITY: int = 666


func _ready() -> void:
	#Engine.time_scale = 0.2
	animation_tree.active = true
	
	current_state = states.IDLE
	last_facing_direction = 1
	#is_jumping = false


func _process(_delta: float) -> void:
	var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
	var state_machine_state: StringName = state_machine.get_current_node()
	
	match state_machine_state:
		"Idle":
			current_state = states.IDLE
		"Run":
			current_state = states.RUN
		"Jump":
			current_state = states.JUMP
	
	var look_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	var run_direction: float = Input.get_axis("left", "right")
	
	if run_direction != 0:
		last_facing_direction = run_direction
	
	animation_tree.set("parameters/Idle/blend_position", last_facing_direction)
	animation_tree.set("parameters/Run/blend_position", look_direction)
	animation_tree.set("parameters/Jump/blend_position", last_facing_direction)
	#print(look_direction)
	

func _physics_process(delta: float) -> void:
	var run_direction: float = Input.get_axis("left", "right")
	
	#var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
	#var state_machine_state: StringName = state_machine.get_current_node()
	#
	#match state_machine_state:
		#"Idle":
			#current_state = states.IDLE
		#"Run":
			#current_state = states.RUN
		#"Jump":
			#current_state = states.JUMP
	
	#if not is_on_floor():
		#velocity.y += GRAVITY * delta
	#else:
		#is_jumping = false
	
	match current_state:
		states.IDLE:
			velocity.x = run_direction * RUN_SPEED
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_SPEED
		states.RUN:
			velocity.x = run_direction * RUN_SPEED
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_SPEED
		states.JUMP:
			if run_direction != 0:
				velocity.x = run_direction * RUN_SPEED
			velocity.y += GRAVITY * delta
	
	## Jump code
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#is_jumping = true
		#velocity.y = JUMP_SPEED
	#
	## Idle if no run_direction, else player runs
	#if run_direction == 0:
		#if is_jumping == false:
			#velocity.x = 0
	#else:
		#velocity.x = run_direction * RUN_SPEED
	
	print(velocity.x)
	var mas: bool = move_and_slide()
	print(mas)
