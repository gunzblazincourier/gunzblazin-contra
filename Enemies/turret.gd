extends Area2D
## Turret that actively tracks the player once activated and shoots when
## player is in its sight cone
##
## Handles tracking, shooting and various animations

## Contains all animations, including frames of turret positions
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

## Turret's end, where bullet is spawned
@onready var muzzle: Marker2D = $Muzzle

## Turret shoots and does not track player for this time
@onready var shoot_timer: Timer = $ShootTimer

## Turret explosion sound
@onready var death_explosion_sfx: AudioStreamPlayer2D = $DeathExplosionSFX
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


## Shoots when player is seen by turret, continues to track after a while and
## repeat
func _process(_delta: float) -> void:
	## Angle between the player and turret's center relative to x-axis
	var angle_with_player: float = global_position.angle_to_point(Global.player_global_position)
	
	## Minumum angle of the sightcone
	var angle_min: float
	
	## Maximum angle of the sightcone
	var angle_max: float
	
	# Assignment of the minumum and maximum sightcone angles for each frame
	if animated_sprite_2d.animation == "shoot":
		if animated_sprite_2d.frame == 0:
			muzzle.position = Vector2(-14, 0)
			muzzle.rotation = PI
			angle_max = -11*(PI/12)
			angle_min = 11*(PI/12)
		elif animated_sprite_2d.frame == 1:
			muzzle.position = Vector2(-13, 6)
			muzzle.rotation = 5*(PI/6)
			angle_max = 11*(PI/12)
			angle_min = 9*(PI/12)
		elif animated_sprite_2d.frame == 2:
			muzzle.position = Vector2(-7, 12)
			muzzle.rotation = 4*(PI/6)
			angle_max = 9*(PI/12)
			angle_min = 7*(PI/12)
		elif animated_sprite_2d.frame == 3:
			muzzle.position = Vector2(0, 13)
			muzzle.rotation = 3*(PI/6)
			angle_max = 7*(PI/12)
			angle_min = 5*(PI/12)
		elif animated_sprite_2d.frame == 4:
			muzzle.position = Vector2(7, 12)
			muzzle.rotation = 2*(PI/6)
			angle_max = 5*(PI/12)
			angle_min = 3*(PI/12)
		elif animated_sprite_2d.frame == 5:
			muzzle.position = Vector2(12, 7)
			muzzle.rotation = PI/6
			angle_max = 3*(PI/12)
			angle_min = 1*(PI/12)
		elif animated_sprite_2d.frame == 6:
			muzzle.position = Vector2(13, 0)
			muzzle.rotation = 0
			angle_max = 1*(PI/12)
			angle_min = -1*(PI/12)
		elif animated_sprite_2d.frame == 7:
			muzzle.position = Vector2(12, -7)
			muzzle.rotation = -PI/6
			angle_max = -1*(PI/12)
			angle_min = -3*(PI/12)
		elif animated_sprite_2d.frame == 8:
			muzzle.position = Vector2(7, -12)
			muzzle.rotation = -2*(PI/6)
			angle_max = -3*(PI/12)
			angle_min = -5*(PI/12)
		elif animated_sprite_2d.frame == 9:
			muzzle.position = Vector2(-1, -14)
			muzzle.rotation = -3*(PI/6)
			angle_max = -5*(PI/12)
			angle_min = -7*(PI/12)
		elif animated_sprite_2d.frame == 10:
			muzzle.position = Vector2(-8, -13)
			muzzle.rotation = -4*(PI/6)
			angle_max = -7*(PI/12)
			angle_min = -9*(PI/12)
		elif animated_sprite_2d.frame == 11:
			muzzle.position = Vector2(-12, -7)
			muzzle.rotation = -5*(PI/6)
			angle_max = -9*(PI/12)
			angle_min = -11*(PI/12)
		
		# Changes angle range from signed ([-180, 180]) to unsigned ([0, 360])
		if angle_with_player < 0:
			angle_with_player += 360
		if angle_max < 0:
			angle_max += 360
		if angle_min < 0:
			angle_min += 360
		
		
		## Spawn bullet and pause tracking when timer's running, otherwise
		## track until player is in sightcone
		if shoot_timer.is_stopped():
			if angle_with_player < angle_min:
				animated_sprite_2d.play("shoot")
			elif angle_with_player > angle_max:
				animated_sprite_2d.play_backwards("shoot")
			else:
				shoot_timer.start()
				var bullet_path: PackedScene = load("res://Bullet/bullet_ts.tscn")
				var bullet: Area2D = bullet_path.instantiate()
				owner.add_child(bullet)
				bullet.position = muzzle.global_position
				bullet.rotation = muzzle.global_rotation
				animated_sprite_2d.pause()


## Activate turret when fully visible
func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if animated_sprite_2d.animation == "idle":
		if animated_sprite_2d.frame == 0:
			animated_sprite_2d.play("activate")
		elif animated_sprite_2d.frame == 1 or animated_sprite_2d.frame == 3:
			animated_sprite_2d.play("activate_1")
		else:
			animated_sprite_2d.play("activate_2")
	visible_on_screen_notifier_2d.visible = false

## Deactivate turret just before it reaches left edge of screen
func _on_visible_on_screen_notifier_2d_2_screen_exited() -> void:
	animated_sprite_2d.play("deactivate")


## Start the 'shoot' animation once turret has activated
func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "activate" or animated_sprite_2d.animation == "activate_1" or animated_sprite_2d.animation == "activate_2":
		animated_sprite_2d.play("shoot")


## Triggers turret destruction when hit by player bullet
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)
		animated_sprite_2d.play("explode")
		death_explosion_sfx.play()


## Remove turret after explosion
func _on_death_explosion_sfx_finished() -> void:
	queue_free()
