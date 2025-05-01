extends Area2D
## Soldier that remains stationary and shooting at the player at fixed
## intervals
##
## Handles tracking the player and shooting at it, and death of enemy

# Vertical speed is required to change to simulate gravity, but horizontal
# speed can remain constant
const GRAVITY: int = 555			## Custom gravity for the enemy
const DEATH_SPEED_X: int = 70		## Horizontal speed during death
var death_speed_y: float			## Vertical speed during death
var is_dead: bool					## Whether soldier got hit
var is_exploding: bool				## Whether soldier is explosing post-death

## Enemy animations
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

## Collision Body
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

## Basically rate of fire
@onready var timer: Timer = $Timer

## Muzzle of gun
@onready var muzzle: Marker2D = $Muzzle

## Death explosion sound
@onready var death_explosion_sfx: AudioStreamPlayer2D = $DeathExplosionSFX


func _ready() -> void:
	death_speed_y = -150
	is_dead = false
	is_exploding = false


## Handles death explosion
func _process(_delta: float) -> void:
	if is_dead == true:
		animated_sprite_2d.play("death")
		collision_shape_2d.disabled = true
		timer.stop()
	
	if is_exploding == true:
		animated_sprite_2d.play("explode")
		death_explosion_sfx.play()
		is_exploding = false


## Handles movement during death
func _physics_process(delta: float) -> void:
	if is_dead == true:
		# Decides which direction would the soldier travel when hit by player
		if animated_sprite_2d.flip_h == true:
			position.x += DEATH_SPEED_X * delta
		else:
			position.x += DEATH_SPEED_X * delta
		
		# Vertical movement with gravity
		position.y += death_speed_y * delta
		death_speed_y += GRAVITY * delta
		
		if death_speed_y > 0:
			is_exploding = true
			is_dead = false


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


## Enemy dies when bullet hits it
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		is_dead = true


## Remove soldier when explosion sound is finished playing
func _on_death_explosion_sfx_finished() -> void:
	queue_free()
