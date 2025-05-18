extends Control

@onready var score: Label = $Score
@onready var high_score: Label = $HighScore
@onready var cursor: TextureRect = $Cursor


func _ready() -> void:
	score.text = str(Global.score)


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
		if cursor.position.y == 166:
			er = get_tree().change_scene_to_file("res://Title/intermission.tscn")
		else:
			er = get_tree().change_scene_to_file("res://Title/title.tscn")
	print(er)
	
	if Input.is_action_just_pressed("select"):
		if cursor.position.y == 166:
			cursor.position.y = 181
		elif cursor.position.y == 181:
			cursor.position.y = 166
