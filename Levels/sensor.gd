extends Area2D
## Boxes which open and close. When opened, it can be shot to give a weapon
## pickup
##
## Handles its animation, destruction and spawning of the pickup

## Whether sensor has been destoryed
var destroyed: bool

## Animated sprite for the sensor, containing the default animation and the
## explosion
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

## Collision shape for the srea, here the inside of the sensor
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

## Sound for when sensor is destroyed
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

## Pickup embedded in the sensor
@onready var pickup: Area2D = $Pickup


func _ready() -> void:
	destroyed = false


func _process(_delta: float) -> void:
	if destroyed == true:
		animated_sprite_2d.play("explode")
		audio_stream_player_2d.play()
		
		#animated_sprite_2d.visible = false
		collision_shape_2d.disabled = true
		pickup.process_mode = Node.PROCESS_MODE_INHERIT
		pickup.visible = true
		#var pickup_path: PackedScene = load("res://Bullet/pickup.tscn")
		#var pickup: Area2D = pickup_path.instantiate()
		#owner.add_child(pickup)
		#pickup.position = global_position
		destroyed = false


## Default animation starts when FULLY in the camera
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	animated_sprite_2d.play("default")


## Removes sensor once off-screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


## Sensor is destroyed after shot by player
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet") and animated_sprite_2d.frame > 4 and \
			animated_sprite_2d.frame < 14:
		destroyed = true
		Global.score += 500


## Removes sensor after explosion (based on the sound instead of animation since
## sound is longer)
func _on_audio_stream_player_2d_finished() -> void:
	#queue_free()
	pass
