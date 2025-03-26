extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree

enum states {IDLE, RUN, JUMP}
var current_state: states

var sprite_direction: float

const RUN_SPEED: int = 100
const JUMP_SPEED: int = -300
const GRAVITY: int = 666


func _ready() -> void:
	#Engine.time_scale = 0.2
	animation_tree.active = true
	
	current_state = states.JUMP
	sprite_direction = 1


func _process(_delta: float) -> void:
	var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
	var state_machine_state: StringName = state_machine.get_current_node()
	print(state_machine_state)
	
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
		sprite_direction = run_direction
	
	animation_tree.set("parameters/Idle/blend_position", sprite_direction)
	animation_tree.set("parameters/Run/blend_position", look_direction)
	animation_tree.set("parameters/Jump/blend_position", sprite_direction)
	

func _physics_process(delta: float) -> void:
	var run_direction: float = Input.get_axis("left", "right")
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
	
	var mas: bool = move_and_slide()
	if mas:
		pass
