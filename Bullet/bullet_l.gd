# NOTE: Pending implementation of removing previously-fired laser upon shooting again

extends Area2D

@onready var sprite_visible_timer: Timer = $SpriteVisibleTimer
@onready var sprite_2d_2: Sprite2D = $Sprite2D2
@onready var collision_shape_2d_2: CollisionShape2D = $CollisionShape2D2

const BULLET_SPEED: int = 400


# Timer starts when laser is fired
func _ready() -> void:
	sprite_visible_timer.start()


# Travels in constant direction
func _physics_process(delta: float) -> void:
	position += transform.x * BULLET_SPEED * delta


# Back part of laser becomes visible and collision of the part is activated on timer timeout
func _on_sprite_visible_timer_timeout() -> void:
	sprite_2d_2.visible = true
	collision_shape_2d_2.disabled = false
	collision_shape_2d_2.visible = true
