extends Area2D
## Lasergun laser
##
## Handles speed and trajectory
# Laser is technically 4 bullets, hence it's split up accordingly

# Components of 1st laser
## Sprite
@onready var sprite_2d: Sprite2D = $Sprite2D

## Collision shape
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Components of 2nd laser
## Sprite
@onready var sprite_2d_2: Sprite2D = $Sprite2D2

## Collision shape
@onready var collision_shape_2d_2: CollisionShape2D = $CollisionShape2D2

# Components of 3rd laser
## Sprite
@onready var sprite_2d_3: Sprite2D = $Sprite2D3

## Collision shape
@onready var collision_shape_2d_3: CollisionShape2D = $CollisionShape2D3

# Components of last laser
## Sprite
@onready var sprite_2d_4: Sprite2D = $Sprite2D4

## Collision shape
@onready var collision_shape_2d_4: CollisionShape2D = $CollisionShape2D4

## Timer to spawn all 4 laser components one-by-one
@onready var timer: Timer = $Timer

## On-screen notifier of entire laser
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

## Fixed bullet speed
const BULLET_SPEED: int = 200


## Resets laser componenets' status whenever fired again
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		sprite_2d.visible = true
		collision_shape_2d.disabled = false
		sprite_2d_2.visible = false
		collision_shape_2d_2.disabled = true
		sprite_2d_3.visible = false
		collision_shape_2d_3.disabled = true
		sprite_2d_4.visible = false
		collision_shape_2d_4.disabled = true
		timer.start()


## Bullet travels in linear direction, without changing rotation or direction
func _physics_process(delta: float) -> void:
	position += transform.x * BULLET_SPEED * delta


# Cannot remove laser since only one instance is made to respawn laser
# instead of making another one, so it is just disabled until visible again
## Disables laser once outside screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	monitoring = false
	monitorable = false


## Reenables laser when in view
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	monitoring = true
	monitorable = true


func _on_timer_timeout() -> void:
	if sprite_2d_3.visible == true:
		sprite_2d_4.visible = true
		collision_shape_2d_4.disabled = false
		timer.stop()
	elif sprite_2d_2.visible == true:
		sprite_2d_3.visible = true
		collision_shape_2d_3.disabled = false
	elif sprite_2d.visible == true:
		sprite_2d_2.visible = true
		collision_shape_2d_2.disabled = false


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") or area.is_in_group("object"):
		if sprite_2d_4.visible == true:
			sprite_2d_4.visible = false
			collision_shape_2d_4.disabled = true
		elif sprite_2d_3.visible == true:
			sprite_2d_3.visible = false
			collision_shape_2d_3.disabled = true
		elif sprite_2d_2.visible == true:
			sprite_2d_2.visible = true
			collision_shape_2d_2.disabled = false
		elif sprite_2d.visible == true:
			sprite_2d.visible = true
			collision_shape_2d.disabled = false
