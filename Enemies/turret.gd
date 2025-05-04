extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var visible_on_screen_notifier_2d_2: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D2


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	animated_sprite_2d.play("activate")
	

func _on_visible_on_screen_notifier_2d_2_screen_exited() -> void:
	animated_sprite_2d.play_backwards("activate")
