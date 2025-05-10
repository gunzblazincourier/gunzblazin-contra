extends Area2D
## The enemy which just runs across the screen, occasionaly jumping off a ledge
##
## Make it run, jump, die and explode

## All states of the enemy
enum States {RUN, JUMP, DEATH, EXPLODE}

## Left and right directions stored in enum
enum Directions {LEFT = -1, RIGHT = 1}

const SPEED: int = 70		## Fixed running speed
const GRAVITY: int = 555	## Custom gravity for the enemy

## Travel direction
@export var run_direction: Directions = Directions.RIGHT

var state: States				## Current state
var death: bool					## Assigned to advance condition for DEATH
var explode: bool				## Assigned to advance condition for EXPLODE

# jump_speed is not constant since it has to be changed during JUMP and DEATH
# Also same variable for all jump speeds to prevent confusion with different
# variables for each jump scenario
## One variable for all jump speeds for the running soldier
var jump_speed: float

## Decided if the player turns, jumps normally or perform a long jump
var jump_type: int

## Whether enemy has decided its 'jump_type
var is_jump_type_final: bool

## AnimationTree for the enemy
@onready var animation_tree: AnimationTree = $AnimationTree

## Detects if enemy is on the ground
@onready var ray_cast_2d: RayCast2D = $RayCast2D


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	animation_tree.active = true
	state = States.RUN
	death = false
	explode = false
	jump_speed = -150
	jump_type = 0
	is_jump_type_final = false


func _process(_delta: float) -> void:
	# Makes enemy turn when enemy decided to turn
	if is_jump_type_final == true and jump_type == 0:
		if run_direction == Directions.LEFT:
			run_direction = Directions.RIGHT
		else:
			run_direction = Directions.LEFT
	
	## Assigned to advance condition for RUN
	var run: bool = ray_cast_2d.is_colliding()
	
	## Assigned to advance condition for JUMP
	var jump: bool = not run
	
	# Assigning values to AnimationTree variables using respective script variables
	animation_tree.set("parameters/conditions/run", run)
	animation_tree.set("parameters/conditions/jump", jump)
	animation_tree.set("parameters/conditions/death", death)
	animation_tree.set("parameters/conditions/explode", explode)
	
	# Deciding blend positions
	animation_tree.set("parameters/Run/blend_position", run_direction)
	animation_tree.set("parameters/Jump/blend_position", run_direction)
	animation_tree.set("parameters/Death/blend_position", run_direction)
	animation_tree.set("parameters/Explode/blend_position", 0.0)
	
	# Basically gets AnimationNodeStateMachine from AnimationTree
	var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
	
	# Current state in AnimationNodeStateMachine
	var state_machine_state: StringName = state_machine.get_current_node()
	
	# Matching current state in script to that in AnimationTree
	match state_machine_state:
		"Run":
			state = States.RUN
		"Jump":
			state = States.JUMP
		"Death":
			state = States.DEATH
		"Explode":
			state = States.EXPLODE


func _physics_process(delta: float) -> void:
	match state:
		States.RUN:
			# The jump speed and is_jump_type_final are set to default values
			# after transition to RUN
			jump_speed = -150
			is_jump_type_final = false
			position.x += run_direction * SPEED * delta
		States.JUMP:
			if is_jump_type_final == false:
				# Chooses 0, 1 or 2 randomly
				# 0: Turn
				# 1: Normal jump
				# 2: Long jump
				jump_type = randi() % 3
				if jump_type == 0:
					jump_speed = 0
				elif jump_type == 2:
					jump_speed = -200
				is_jump_type_final = true
			position.x += run_direction * SPEED * delta
			position.y += jump_speed * delta
			jump_speed += GRAVITY * delta
		States.DEATH:
			position.x -= run_direction * SPEED * delta
			position.y += jump_speed * delta
			jump_speed += GRAVITY * delta
			
			# Enemy explodes sometime after getting knocked back by player's
			# bullet (which is when enemy reaches peak jump height during DEATH)
			if jump_speed > 0:
				explode = true
				death = false


## Enemy dies when bullet hits it
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		death = true


## Removes enemy once outside screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


## Enables enemy (or "spawns") when camera reaches the position
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	#print("enemy")
	process_mode = Node.PROCESS_MODE_INHERIT
