extends Area2D
## Weapon pickups
##
## Controls its speed, trajectory and the action of 'picking' by the player

## Fixed horizontal pickup speed
const PICKUP_SPEED_X: int = 60

## Custom gravity
const GRAVITY: int = 350

## Decides which pickup sprite is displayed and which weapon player receives
@export var pickup_id: Global.Weapons = Global.Weapons.M

## Non-constant vertical speed
var pickup_speed_y: float

## One AnimatedSprite has different weapon pickups
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

## RayCast to detect landing
@onready var ray_cast_2d: RayCast2D = $RayCast2D

## Pickup sound
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


## Display respective sprite based on pickup ID, and initialize vertical speed
func _ready() -> void:
	if pickup_id == Global.Weapons.R:
		animated_sprite_2d.animation = 'R'
	elif pickup_id == Global.Weapons.M:
		animated_sprite_2d.animation = 'M'
	elif pickup_id == Global.Weapons.S:
		animated_sprite_2d.animation = 'S'
	elif pickup_id == Global.Weapons.L:
		animated_sprite_2d.animation = 'L'
	elif pickup_id == Global.Weapons.F:
		animated_sprite_2d.animation = 'F'
	pickup_speed_y = -175


## Pickup travels in an arc with constant horizontal speed
func _physics_process(delta: float) -> void:
	if not ray_cast_2d.is_colliding():
		position.x += PICKUP_SPEED_X * delta
		position.y += pickup_speed_y * delta
		pickup_speed_y += GRAVITY * delta


## Play audio and disable it when player picks it up and receives the weapon
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		Global.weapon = pickup_id
		audio_stream_player_2d.play()
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)
		visible = false
		Global.score += 1000

## Remove the pickup from level after pickup sound finishes playing
func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
