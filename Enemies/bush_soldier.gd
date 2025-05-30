extends Area2D
## Soldier that hides in the bushes, and periodically pops out to take a
## shot at the player
##
## Handles popping out, shooting, hiding back again, repeat

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

## Pop-out on timeout
@onready var pop_out_timer: Timer = $PopOutTimer

## Pop-in on timeout
@onready var pop_in_timer: Timer = $PopInTimer

## Muzzle of gun
@onready var muzzle: Marker2D = $Muzzle

## Death explosion sound
@onready var death_explosion_sfx: AudioStreamPlayer2D = $DeathExplosionSFX


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	death_speed_y = -150
	is_dead = false
	is_exploding = false


## Handles death and following explosion
func _process(_delta: float) -> void:
	if is_dead == true:
		animated_sprite_2d.play("death")
		collision_shape_2d.disabled = true
		pop_out_timer.stop()
		pop_in_timer.stop()
	
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
			position.x -= DEATH_SPEED_X * delta
		
		# Vertical movement with gravity
		position.y += death_speed_y * delta
		death_speed_y += GRAVITY * delta
		
		if death_speed_y > 0:
			is_exploding = true
			is_dead = false


## Pop-out
func _on_pop_out_timer_timeout() -> void:
	animated_sprite_2d.play("shoot_straight")
	pop_in_timer.start()


## Pop-in
func _on_pop_in_timer_timeout() -> void:
	animated_sprite_2d.play_backwards("shoot_straight")
	pop_out_timer.start()


## Enemy dies when bullet hits it
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		is_dead = true
		Global.score += 500


## Remove soldier when explosion sound is finished playing
func _on_death_explosion_sfx_finished() -> void:
	queue_free()


## Removes enemy once outside screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


## Enables enemy (or "spawns") when camera reaches the position
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "shoot_straight" and animated_sprite_2d.frame == 2:
		## Angle between the soldier and player relative to X-axis
		var angle_with_player: float = global_position.angle_to_point(Global.player_global_position)
		
		# Soldier faces left or right based on the angle with player
		if angle_with_player > -PI/2 and angle_with_player < PI/2:
			animated_sprite_2d.flip_h = true
			muzzle.position = Vector2(13, 5)
			muzzle.rotation = 0
		else:
			animated_sprite_2d.flip_h = false
			muzzle.position = Vector2(-13, 5)
			muzzle.rotation = PI
		
		# Spawn bullet
		var bullet_path: PackedScene = load("res://Bullet/bullet_ts.tscn")
		var bullet: Area2D = bullet_path.instantiate()
		owner.add_child(bullet)
		bullet.position = muzzle.global_position
		bullet.rotation = muzzle.global_rotation
