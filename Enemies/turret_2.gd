extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.visible = false
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#pass
	print(visible)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	animated_sprite_2d.visible = true
	print("tret")
	animated_sprite_2d.play("rise")
