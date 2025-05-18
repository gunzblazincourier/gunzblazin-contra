extends Control

@onready var score: Label = $Score
@onready var high_score: Label = $HighScore


func _ready() -> void:
	score.text = str(Global.score)


func _on_label_flashing_timer_timeout() -> void:
	if score.visible == true:
		score.visible = false
		high_score.visible = false
	else:
		score.visible = true
		high_score.visible = true


func _on_screen_timer_timeout() -> void:
	# Stored in variable and printed to prevent 'return value
	# discarded' error
	Global.background_music.play()
	var er: Error = get_tree().change_scene_to_file("res://Levels/level_1_fade.tscn")
	print(er)
	print("BEGIN")
