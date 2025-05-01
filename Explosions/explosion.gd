extends Node2D
## An explosion graphic
##
## Handles animation

## Decides whether animation plays or not
@export var play: bool

## Whether explosion animation has begun
var exploded: bool

## Plays the explosion animation
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	play = false
	visible = false
	exploded = false

## Plays animation once when the exported variable is set to 'true'
func _process(_delta: float) -> void:
	if exploded == false:
		if play == true:
			animation_player.play("explode")
			exploded = true
