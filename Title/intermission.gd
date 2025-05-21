extends Control
## Intermission screen
##
## Screen displayed before a level, showing player lives and score

## Current score of player
@onready var score: Label = $Score

## High score which is updated when player score more than this score
@onready var high_score: Label = $HighScore

## Current lives held by player
@onready var life: Label = $Life


## Update the text on screen with the global score and life values
func _ready() -> void:
	score.text = str(Global.score)
	high_score.text = str(Global.high_score)
	life.text = str(Global.lives + 1)


## Flash labels
func _on_label_flashing_timer_timeout() -> void:
	if score.visible == true:
		score.visible = false
		high_score.visible = false
	else:
		score.visible = true
		high_score.visible = true


## Proceed to level
func _on_screen_timer_timeout() -> void:
	Global.background_music.play()
	# Stored in variable and printed to prevent 'return value
	# discarded' error
	var er: Error = get_tree().change_scene_to_file("res://Levels/level_1_fade.tscn")
	print(er)
