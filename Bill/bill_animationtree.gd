extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree

var last_facing_direction: float
var is_jumping: bool = false


func _ready() -> void:
	animation_tree.active = true

func _process(_delta: float) -> void:
	var look_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	var run_direction: float = Input.get_axis("left", "right")
	
	if run_direction != 0:
		last_facing_direction = run_direction
	#else:
		#print("AAAAAAAAA")
	#print(last_facing_direction)
	
	animation_tree.set("parameters/Idle/blend_position", last_facing_direction)
	animation_tree.set("parameters/Run/blend_position", look_direction)
	animation_tree.set("parameters/Jump/blend_position", last_facing_direction)
	#print(look_direction)
	

func _physics_process(delta: float) -> void:
	#var look_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	var run_direction: float = Input.get_axis("left", "right")
	
	if not is_on_floor():
		velocity.y += 666 * delta
	else:
		is_jumping = false
	
	# Jump code
	if Input.is_action_just_pressed("jump") and is_on_floor():
		is_jumping = true
		velocity.y = -300
	
	# Idle if no run_direction, else player runs
	if run_direction == 0:
		if is_jumping == false:
			velocity.x = 0
	else:
		velocity.x = run_direction * 100
	
	var mas: bool = move_and_slide()
	print(mas)
