extends Area2D

const BULLET_SPEED: int = 400
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	audio_stream_player_2d.play()


# Travels in constant direction
func _physics_process(delta: float) -> void:
	position += transform.x * BULLET_SPEED * delta


# Removes bullet if it enters specific hitboxes (eg an enemy's)
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		queue_free()
