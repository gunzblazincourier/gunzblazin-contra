extends StaticBody2D

@export var starting_camera_position: float
var explosion_started: bool
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("default")
	explosion_started = false


func _process(_delta: float) -> void:
	if explosion_started == false:
		if starting_camera_position == Global.camera_center_position.x:
			animation_player.play("explosion")
