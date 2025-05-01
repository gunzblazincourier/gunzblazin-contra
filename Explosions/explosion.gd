extends Node2D

@export var play: bool
var exploded: bool
@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play = false
	visible = false
	exploded = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if exploded == false:
		if play == true:
			animation_player.play("explode")
			exploded = true
