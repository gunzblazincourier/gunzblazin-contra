extends Control
## Game over screen
##
## Shown when player loses all lives. Option to either end game or start level
## again

## Current score of player
@onready var score: Label = $Score

## High score which is updated when player score more than this score
@onready var high_score: Label = $HighScore

## Cursor to select 'Continue' or 'End' option
@onready var cursor: TextureRect = $Cursor


## Update score when screen is displayed
func _ready() -> void:
	score.text = str(Global.score)


## Flash scores
func _on_label_flashing_timer_timeout() -> void:
	if score.visible == true:
		score.visible = false
		high_score.visible = false
	else:
		score.visible = true
		high_score.visible = true


func _process(_delta: float) -> void:
	var er: Error
	if Input.is_action_just_pressed("start"):
		# Perform respective action based on option selected
		if cursor.position.y == 166:
			Global.lives = Global.DEFAULT_LIVES
			er = get_tree().change_scene_to_file("res://Title/intermission.tscn")
		else:
			er = get_tree().change_scene_to_file("res://Title/title.tscn")
	# Stored in variable and printed to prevent 'return value
	# discarded' error
	print(er)
	
	# Allow option selection
	if Input.is_action_just_pressed("select"):
		if cursor.position.y == 166:
			cursor.position.y = 181
		elif cursor.position.y == 181:
			cursor.position.y = 166
