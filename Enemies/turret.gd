extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var visible_on_screen_notifier_2d_2: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D2


func _process(_delta: float) -> void:
	var angle_with_player: float = global_position.angle_to_point(Global.player_global_position)
	var min: float
	var max: float
	if animated_sprite_2d.animation == "shoot":
		if animated_sprite_2d.frame == 0:
			#if angle_with_player < -11*(PI/12) and angle_with_player > 11*(PI/12):
				#animated_sprite_2d.stop()
			max = -11*(PI/12)
			min = 11*(PI/12)
		elif animated_sprite_2d.frame == 1:
			max = 11*(PI/12)
			min = 9*(PI/12)
		elif animated_sprite_2d.frame == 2:
			max = 9*(PI/12)
			min = 7*(PI/12)
		elif animated_sprite_2d.frame == 3:
			max = 7*(PI/12)
			min = 5*(PI/12)
		elif animated_sprite_2d.frame == 4:
			max = 5*(PI/12)
			min = 3*(PI/12)
		elif animated_sprite_2d.frame == 5:
			max = 3*(PI/12)
			min = 1*(PI/12)
		elif animated_sprite_2d.frame == 6:
			max = 1*(PI/12)
			min = -1*(PI/12)
		elif animated_sprite_2d.frame == 7:
			max = -1*(PI/12)
			min = -3*(PI/12)
		elif animated_sprite_2d.frame == 8:
			max = -3*(PI/12)
			min = -5*(PI/12)
		elif animated_sprite_2d.frame == 9:
			max = -5*(PI/12)
			min = -7*(PI/12)
		elif animated_sprite_2d.frame == 10:
			max = -7*(PI/12)
			min = -9*(PI/12)
		elif animated_sprite_2d.frame == 1:
			max = -9*(PI/12)
			min = -11*(PI/12)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	animated_sprite_2d.play("activate")
	

func _on_visible_on_screen_notifier_2d_2_screen_exited() -> void:
	animated_sprite_2d.play("deactivate")


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "activate":
		animated_sprite_2d.play("shoot")
