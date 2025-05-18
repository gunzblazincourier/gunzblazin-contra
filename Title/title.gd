extends Control
## Title screen
##
## Scripting from entry of title to starting the game

## Has title screen fully appeared, with all elements visible
var has_title_appeared: bool

## Whether '1 Player' or '2 Player' has been selected
var is_option_selected: bool

## The characters of Contra, Bill and Lance
@onready var bill_and_lance: TextureRect = $BillAndLance

## Cursor to select 'Player 1' or 'Platyer 2' option
@onready var cursor: TextureRect = $Cursor

## '1 Player' text on title
@onready var player_1_text: TextureRect = $Player1Text

## '2 Player' text on title
@onready var player_2_text: TextureRect = $Player2Text

## Title music
@onready var title_music: AudioStreamPlayer2D = $TitleMusic

## How long the title screen stays after selecting option after music has
## finished playing
@onready var transition_duration_timer: Timer = $TransitionDurationTimer

## Speed with which selected option flashes
@onready var option_flashing_timer: Timer = $OptionFlashingTimer


## Initialization of the boolean variables declared in beginning
func _ready() -> void:
	has_title_appeared = false
	is_option_selected = false


func _process(delta: float) -> void:
	# Cursor and BillAndLance picture appears when title screen is fully in view 
	if has_title_appeared == true:
		bill_and_lance.visible = true
		cursor.visible = true
		# Option selection allowed unless already selected
		if is_option_selected == false:
			if Input.is_action_just_pressed("select"):
				if cursor.position == Vector2(35, 166):
					cursor.position = Vector2(35, 182)
				elif cursor.position == Vector2(35, 182):
					cursor.position = Vector2(35, 166)
		
		# Confirm option
		if Input.is_action_just_pressed("start") and is_option_selected == false:
			transition_duration_timer.start()
			option_flashing_timer.start()
			is_option_selected = true
		
		# Proceed to next scene
		if is_option_selected == true:
			if transition_duration_timer.is_stopped() and not title_music.playing:
				option_flashing_timer.one_shot = true
				
				# Stored in variable and printed to prevent 'return value
				# discarded' error
				var er: Error = get_tree().change_scene_to_file("res://Title/intermission.tscn")
				print(er)
	
	# Title screen sliding right-to-left
	if position.x > 0:
		position.x -= 64 * delta
	else:
		position.x = 0
	
	# Snaps screen to final position when 'Start' or 'Select' key is pressed
	# Position is set to a small negative value here instead of 0 since a
	# negative value is a trigger for certain actions, like playing of music.
	# The last x-position of the screen is marginally negative even when nothing
	# is pressed and sliding proceeds uninterrupted, before setting itself to 0.
	if Input.is_action_just_pressed("start") or Input.is_action_just_pressed("select") and \
			has_title_appeared == false:
		position.x = -0.3
	
	# Plays title music and sets related boolean variable title has appeared
	if has_title_appeared == false:
		if position.x < 0:
			title_music.play()
			has_title_appeared = true


## Selected option flashes by toggling visibility of the text upon timeout
func _on_option_flashing_timer_timeout() -> void:
	if cursor.position == Vector2(35, 166):
		if player_1_text.visible == false:
			player_1_text.visible = true
		else:
			player_1_text.visible = false
	if cursor.position == Vector2(35, 182):
		if player_2_text.visible == false:
			player_2_text.visible = true
		else:
			player_2_text.visible = false
