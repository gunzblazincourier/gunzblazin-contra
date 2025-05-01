extends Area2D
## Soldier that remains stationary and shooting at the player at fixed
## intervals
##
## Handles tracking the player and shooting at it, and death of enemy

## Enemy animations
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

## Basically rate of fire
@onready var timer: Timer = $Timer

## Muzzle of gun
@onready var muzzle: Marker2D = $Muzzle

## Soldier aims and fire at the player each time the repeating timer timeouts
func _on_timer_timeout() -> void:
	## Angle between the soldier and player relative to X-axis
	var angle_with_player: float = global_position.angle_to_point(Global.player_global_position)
	
	# Above angle decides animation
	if angle_with_player < -PI/4 and angle_with_player > -3*(PI/4):
		animated_sprite_2d.play("shoot_up")
	elif angle_with_player > PI/4 and angle_with_player < 3*(PI*4):
		animated_sprite_2d.play("shoot_down")
	else:
		animated_sprite_2d.play("shoot_straight")
	
	# Soldier faces left or right based on the angle with player
	if angle_with_player > -PI/2 and angle_with_player < PI/2:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true
	
	# Initializes muzzle position and rotation based on animation
	# Rotation value is clamped between two angles
	if animated_sprite_2d.animation == "shoot_up":
		if animated_sprite_2d.flip_h == false:
			muzzle.position = Vector2(9, -21)
			muzzle.rotation = clamp(angle_with_player, -PI/2, -PI/8)
		else:
			muzzle.position = Vector2(-9, -21)
			muzzle.rotation = clamp(angle_with_player, -7*(PI/8), -PI/2)
	elif animated_sprite_2d.animation == "shoot_down":
		if animated_sprite_2d.flip_h == false:
			muzzle.position = Vector2(14, 2)
			muzzle.rotation = clamp(angle_with_player, PI/8, PI/2)
		else:
			muzzle.position = Vector2(-14, 2)
			muzzle.rotation = clamp(angle_with_player, PI/2, 7*(PI/8))
	else:
		if animated_sprite_2d.flip_h == false:
			muzzle.position = Vector2(14, -11)
			muzzle.rotation = 0
		else:
			muzzle.position = Vector2(-14, -11)
			muzzle.rotation = PI
	
	# Spawn bullet
	var bullet_path: PackedScene = load("res://Bullet/bullet_ts.tscn")
	var bullet: Area2D = bullet_path.instantiate()
	owner.add_child(bullet)
	bullet.position = muzzle.global_position
	bullet.rotation = muzzle.global_rotation
