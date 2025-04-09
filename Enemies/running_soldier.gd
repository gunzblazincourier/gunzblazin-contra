# NOTE: Implementation of actual jumping (not the "death jump") pending
# due to pending level design with ledges

extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

const SPEED: int = 70
const GRAVITY: int = 7

# Enum for left and right direction, and exported variable to set direction from GUI
enum directions {LEFT = -1, RIGHT = 1}
@export var run_direction: directions = directions.RIGHT
var is_dead: bool = false

# NOTE: Further code will be added for the actual jump along with the "death jump"
var jump_speed: int = -123


# Decides to flip running soldier sprite based on direction
func _ready() -> void:
	if run_direction == 1:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true


# Plays appropriate animation for jumping and death (running is on autoplay)
func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("1"):
		#run_direction = 1
	#elif Input.is_action_just_pressed("2"):
		#run_direction = -1
	
	# Disables collision when enemy is hit as to avoid bullets hitting a dead enemy
	if is_dead == true:
		collision_shape_2d.disabled = true
		
		# Plays the "death jump" animation until reaches peak height, after which it explodes
		if jump_speed < 0:
			animated_sprite_2d.play("death")
		else:
			animated_sprite_2d.play("explode")


# Runs by default. Upon death, jumps in opposite direction until explosion
func _physics_process(delta: float) -> void:
	if jump_speed < 0:
		if is_dead:
			position.x -= run_direction * SPEED * delta
			position.y += jump_speed * delta
			jump_speed += GRAVITY
		else:
			position.x += run_direction * SPEED * delta


# If hit by bullet, jumps backward amd explodes
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		is_dead = true
