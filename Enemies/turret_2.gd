extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var death_explosion_sfx: AudioStreamPlayer2D = $DeathExplosionSFX
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.visible = false
	collision_shape_2d.disabled = true
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#pass
	print(visible)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	animated_sprite_2d.visible = true
	print("tret")
	animated_sprite_2d.play("rise")


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)
		animated_sprite_2d.play("explode")
		death_explosion_sfx.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	animated_sprite_2d.play("shoot")
	collision_shape_2d.disabled = false
