extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var visible_on_screen_notifier_2d_2: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D2


func _process(_delta: float) -> void:
	#print(animated_sprite_2d.animation)
	var angle_with_player: float = global_position.angle_to_point(Global.player_global_position)
	var angle_min: float
	var angle_max: float
	if animated_sprite_2d.animation == "shoot":
		if animated_sprite_2d.frame == 0:
			#if angle_with_player < -11*(PI/12) and angle_with_player > 11*(PI/12):
				#animated_sprite_2d.stop()
			angle_max = -11*(PI/12)
			angle_min = 11*(PI/12)
		elif animated_sprite_2d.frame == 1:
			angle_max = 11*(PI/12)
			angle_min = 9*(PI/12)
		elif animated_sprite_2d.frame == 2:
			angle_max = 9*(PI/12)
			angle_min = 7*(PI/12)
		elif animated_sprite_2d.frame == 3:
			angle_max = 7*(PI/12)
			angle_min = 5*(PI/12)
		elif animated_sprite_2d.frame == 4:
			angle_max = 5*(PI/12)
			angle_min = 3*(PI/12)
		elif animated_sprite_2d.frame == 5:
			angle_max = 3*(PI/12)
			angle_min = 1*(PI/12)
		elif animated_sprite_2d.frame == 6:
			angle_max = 1*(PI/12)
			angle_min = -1*(PI/12)
		elif animated_sprite_2d.frame == 7:
			angle_max = -1*(PI/12)
			angle_min = -3*(PI/12)
		elif animated_sprite_2d.frame == 8:
			angle_max = -3*(PI/12)
			angle_min = -5*(PI/12)
		elif animated_sprite_2d.frame == 9:
			angle_max = -5*(PI/12)
			angle_min = -7*(PI/12)
		elif animated_sprite_2d.frame == 10:
			angle_max = -7*(PI/12)
			angle_min = -9*(PI/12)
		elif animated_sprite_2d.frame == 11:
			angle_max = -9*(PI/12)
			angle_min = -11*(PI/12)
		
		if animated_sprite_2d.frame != 0:
			if angle_with_player < angle_min:
				animated_sprite_2d.play("shoot")
			elif angle_with_player > angle_max:
				animated_sprite_2d.play_backwards("shoot")
			else:
				animated_sprite_2d.pause()
		else:
			if angle_with_player < angle_min and angle_with_player > 0:
				animated_sprite_2d.play("shoot")
			elif angle_with_player > angle_max and angle_with_player < 0:
				animated_sprite_2d.play_backwards("shoot")
			else:
				animated_sprite_2d.pause()
		print(angle_with_player)
		#print(angle_min)
		#print(angle_with_player < angle_min)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	animated_sprite_2d.play("activate")
	

func _on_visible_on_screen_notifier_2d_2_screen_exited() -> void:
	animated_sprite_2d.play("deactivate")


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "activate":
		animated_sprite_2d.play("shoot")
