extends Node2D

@onready var sprite_2d_2: Sprite2D = $Sprite2D2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sprite_2d_2.position.x += 256 * delta


func _on_timer_timeout() -> void:
	var er: Error = get_tree().change_scene_to_file("res://Levels/level1.tscn")
	print(er)
	print("BEGIN")
