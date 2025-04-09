# NOTE: Implementation of actual jumping (not the "death jump") pending
# due to pending level design with ledges

extends Area2D

@onready var animation_tree: AnimationTree = $AnimationTree

enum states {RUN, JUMP, DEATH, EXPLODE}
var current_state: states

const SPEED: int = 70
const GRAVITY: int = 7

# Enum for left and right direction, and exported variable to set direction from GUI
enum directions {LEFT = -1, RIGHT = 1}
@export var run_direction: directions = directions.RIGHT
var death: bool
var explode: bool

# NOTE: Further code will be added for the actual jump along with the "death jump"
var jump_speed: int = -123


# Decides to flip running soldier sprite based on direction
func _ready() -> void:
	animation_tree.active = true
	current_state = states.RUN
	death = false
	explode = false

# Plays appropriate animation for jumping and death (running is on autoplay)
func _process(_delta: float) -> void:
	animation_tree.set("parameters/conditions/death", death)
	animation_tree.set("parameters/conditions/explode", explode)
	animation_tree.set("parameters/Run/blend_position", run_direction)
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
	
	#if Input.is_action_just_pressed("1"):
		#run_direction = 1
	#elif Input.is_action_just_pressed("2"):
		#run_direction = -1
	
	# Disables collision when enemy is hit as to avoid bullets hitting a dead enemy
	#if is_dead == true:
		#collision_shape_2d.disabled = true
		
		# Plays the "death jump" animation until reaches peak height, after which it explodes
		#if jump_speed < 0:
			#animated_sprite_2d.play("death")
		#else:
			#animated_sprite_2d.play("explode")


# Runs by default. Upon death, jumps in opposite direction until explosion
func _physics_process(delta: float) -> void:
	if jump_speed > 0:
		explode = true
		death = false
	
	match current_state:
		states.RUN:
			position.x += run_direction * SPEED * delta
		states.DEATH:
			position.x -= run_direction * SPEED * delta
			position.y += jump_speed * delta
			jump_speed += GRAVITY
	
	
	#if jump_speed < 0:
		#if is_dead:
			#position.x -= run_direction * SPEED * delta
			#position.y += jump_speed * delta
			#jump_speed += GRAVITY
		#else:
			#position.x += run_direction * SPEED * delta


# If hit by bullet, jumps backward amd explodes
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		death = true
