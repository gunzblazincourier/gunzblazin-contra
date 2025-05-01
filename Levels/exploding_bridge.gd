extends StaticBody2D
## Iconic bridge in Level 1 that explodes
##
## Makes the lights on it work, as well as it's destruction

## Starting point of the bridge
@export var starting_camera_position: float

## Whether explosion of the bridge has begun
var explosion_started: bool

## AnimationPlayer of the scene
@onready var animation_player: AnimationPlayer = $AnimationPlayer


## Plays 'default animation' of the intact stationary bridge
func _ready() -> void:
	animation_player.play("default")
	explosion_started = false


## Makes bridge explode when player arrives
func _process(_delta: float) -> void:
	if explosion_started == false:
		if Global.camera_center_position.x > starting_camera_position:
			animation_player.play("explosion")
			explosion_started = true
