extends Area2D

enum states {RUN, JUMP, DEATH, EXPLODE}
enum directions {LEFT = -1, RIGHT = 1}

const SPEED: int = 70
const GRAVITY: int = 7

@export var run_direction: directions = directions.RIGHT
var current_state: states
var death: bool
var explode: bool
var jump_speed: int

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var ray_cast_2d: RayCast2D = $RayCast2D


func _ready() -> void:
	animation_tree.active = true
	current_state = states.RUN
	death = false
	explode = false
	jump_speed = -123

func _process(_delta: float) -> void:
	var run: bool = ray_cast_2d.is_colliding()
	var jump: bool = !ray_cast_2d.is_colliding()
	
	animation_tree.set("parameters/conditions/run", run)
	animation_tree.set("parameters/conditions/jump", jump)
	animation_tree.set("parameters/conditions/death", death)
	animation_tree.set("parameters/conditions/explode", explode)
	animation_tree.set("parameters/Run/blend_position", run_direction)
	animation_tree.set("parameters/Jump/blend_position", run_direction)
	animation_tree.set("parameters/Death/blend_position", run_direction)
	animation_tree.set("parameters/Explode/blend_position", 0.0)
	
	# Basically gets AnimationNodeStateMachine from AnimationTree
	var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
	
	# Current state in AnimationNodeStateMachine
	var state_machine_state: StringName = state_machine.get_current_node()
	
	match state_machine_state:
		"Run":
			current_state = states.RUN
		"Jump":
			current_state = states.JUMP
		"Death":
			current_state = states.DEATH
		"Explode":
			current_state = states.EXPLODE
	print(state_machine_state)


func _physics_process(delta: float) -> void:	
	match current_state:
		states.RUN:
			position.x += run_direction * SPEED * delta
		states.JUMP:
			position.x += run_direction * SPEED * delta
			position.y += jump_speed * delta
			jump_speed += GRAVITY
		states.DEATH:
			position.x -= run_direction * SPEED * delta
			position.y += jump_speed * delta
			jump_speed += GRAVITY
			if jump_speed > 0:
				explode = true
				death = false


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		death = true
