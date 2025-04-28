extends Control

var title_appeared: bool
var timer_started: bool
@onready var texture_rect: TextureRect = $TextureRect
@onready var texture_rect_2: TextureRect = $TextureRect2
@onready var texture_rect_3: TextureRect = $TextureRect3
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title_appeared = false
	timer_started = false
	#pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if title_appeared == true:
		texture_rect_2.visible = true
		texture_rect_3.visible = true
		if Input.is_action_just_pressed("select"):
			if texture_rect_3.position == Vector2(35, 166):
				texture_rect_3.position = Vector2(35, 182)
			elif texture_rect_3.position == Vector2(35, 182):
				texture_rect_3.position = Vector2(35, 166)
		if Input.is_action_just_pressed("start") and timer_started == false:
			timer.start()
			timer_started = true
		
		if timer_started == true:
			if timer.is_stopped() and not audio_stream_player_2d.playing:
				print("BEGIN")
	
	if position.x > 0:
		position.x -= 64 * delta
	else:
		position.x = 0
	
	if Input.is_action_just_pressed("start") or Input.is_action_just_pressed("select") and \
			title_appeared == false:
		position.x = -0.3
	
	if title_appeared == false:
		if position.x < 0:
			audio_stream_player_2d.play()
			title_appeared = true
