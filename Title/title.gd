extends Control

var title_appeared: bool
@onready var texture_rect: TextureRect = $TextureRect
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title_appeared = false
	#pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(texture_rect.position.x)
	if texture_rect.position.x > 0:
		texture_rect.position.x -= 64 * delta
	else:
		texture_rect.position.x = 0
	
	if Input.is_action_just_pressed("start") and title_appeared == false:
		texture_rect.position.x = -0.3
	
	if title_appeared == false:
		if texture_rect.position.x < 0:
			audio_stream_player_2d.play()
			title_appeared = true
