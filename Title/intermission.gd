extends Control

@onready var score: Label = $Score
@onready var high_score: Label = $HighScore


func _on_label_flashing_timer_timeout() -> void:
	if score.visible == true:
		score.visible = false
		high_score.visible = false
	else:
		score.visible = true
		high_score.visible = true
