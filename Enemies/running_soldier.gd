extends Area2D

signal send_player_global_position(player_global_position: Vector2)

enum states {RUN, JUMP, DEATH, EXPLODE}
enum directions {LEFT = -1, RIGHT = 1}

const SPEED: int = 70
const GRAVITY: int = 7

@export var run_direction: directions = directions.RIGHT
var current_state: states
var jump: bool
var run_or_jump: int
var death: bool
var explode: bool
var jump_speed: int
var jump_type_selected: bool

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var ray_cast_2d: RayCast2D = $RayCast2D


func _ready() -> void:
	animation_tree.active = true
	current_state = states.RUN
	jump = false
	run_or_jump = 0
	death = false
	explode = false
	jump_speed = -123
	jump_type_selected = false

func _process(_delta: float) -> void:
	send_player_global_position.emit(global_position)
	
	if ray_cast_2d.is_colliding():
		jump = false
	else:
		if jump == false:
			if randi() % 2:
				jump = true
			else:
				if run_direction == directions.LEFT:
					run_direction = directions.RIGHT
				else:
					run_direction = directions.LEFT
	
	var run: bool = ray_cast_2d.is_colliding()
	#var jump: bool = !ray_cast_2d.is_colliding()
	
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
	#print(state_machine_state)


func _physics_process(delta: float) -> void:
	match current_state:
		states.RUN:
			jump_speed = -123
			jump_type_selected = false
			position.x += run_direction * SPEED * delta
		states.JUMP:
			if jump_type_selected == false:
				var jump_type: int = randi() % 3
				print(jump_type)
				if jump_type == 0:
					jump_speed = 0
				elif jump_type == 2:
					jump_speed = -200
				jump_type_selected = true
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
