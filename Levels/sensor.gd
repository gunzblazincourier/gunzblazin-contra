extends Area2D
## Boxes which open and close. When opened, it can be shot to give a weapon
## pickup
##
## Handles its animation, destruction and spawning of the pickup

## Animated sprite for the sensor, containing the default animation and the
## explosion
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	pass


## Default animation starts when FULLY in the camera
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	animated_sprite_2d.play("default")
