extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree

var last_facing_direction: float
#var run_direction: float = Input.get_axis("left", "right")

func _process(_delta: float) -> void:
	#var look_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	var run_direction: float = Input.get_axis("left", "right")
	#var last_facing_direction: float
	
	if run_direction != 0:
		last_facing_direction = run_direction
	else:
		print("AAAAAAAAA")
	
	var idle: bool
	var look_up: bool
	var crouch: bool
	
	animation_tree.set("parameters/conditions/idle", idle)
	animation_tree.set("parameters/conditions/crouch", crouch)
	animation_tree.set("parameters/conditions/look_up", look_up)
	
	animation_tree.set("parameters/Idle/blend_position", last_facing_direction)
	animation_tree.set("parameters/Idle/blend_position", last_facing_direction)
	animation_tree.set("parameters/Idle/blend_position", last_facing_direction)
	print(last_facing_direction)


func _physics_process(_delta: float) -> void:
	var mas: bool = move_and_slide()
	print(mas)
