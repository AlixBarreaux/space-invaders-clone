extends Control

# -------------------- DECLARE VARIABLES --------------------

onready var get_ready_label : Label = $GetReadyLabel

onready var score_number_label : Label = $GlobalStatsContainer/ScoreContainer/ScoreNumber
onready var wave_number_label : Label = $GlobalStatsContainer/WaveContainer/WaveNumber

# Game over GUI elements
onready var game_over_container : Control = $GameOverContainer

onready var lives_label : Label = $PlayerLivesContainer/PlayerOneLivesContainer/PlayerLives

var current_score : int = 0
var current_wave : int = 1

export var current_lives : int = 3
var max_lives : int = 6

var players_eliminated_amount : int = 0

# --------------------  DECLARE SIGNALS  --------------------

# --------------------   RUN THE CODE    --------------------

func _ready() -> void:
	Events.connect("alien_killed", self, "update_score")
	Events.connect("wave_cleared", self, "update_wave")
	Events.connect("game_over", self, "on_game_over")
	Events.connect("wave_state_changed", self, "on_wave_state_changed")
	Events.connect("player_died", self, "decrease_player_lives")
	
#	players_eliminated_amount = 
	for players in GameConfig.player_list:
		# Get the number of players current playing
		print("")
	
	update_lives_label()

func decrease_player_lives() -> void:
	current_lives -= 1
	check_if_life_remaining()
	update_lives_label()

var can_players_respawn : bool = true
func check_if_life_remaining() -> void:
	if current_lives <= 0:
		Events.emit_signal("disable_player_reviving")
		can_players_respawn = false
		
		check_remaining_players()


func update_lives_label() -> void:
	if can_players_respawn:
		lives_label.text = str(current_lives)
	if not can_players_respawn:
		lives_label.text = "0"
		


var players_remaining : int = 0
func check_remaining_players() -> void:
	
	if players_remaining == 0:
		print("GAME OVEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEER!!!!")
		$GameOverContainer/GameOverButtons/MainMenu.grab_focus()
		Events.emit_signal("game_over")
	else:
		players_remaining -= 1
	
	var players_index : int = -1
	for players in GameConfig.player_list:
		players_index += 1
		if GameConfig.player_list[GameConfig.player_list.keys()[players_index]]["is_ready"]:
			players_remaining += 1
	# At this stage there are 0 lives left and on player is dead already
	players_remaining -= 1
	print("Players ready left to be eliminated: ", players_remaining)


# -------------------- DECLARE FUNCTIONS --------------------

func update_score(points_added_to_score : int) -> void:
	current_score += points_added_to_score
	score_number_label.text = str(current_score)


func update_wave() -> void:
	current_wave += 1
	wave_number_label.text = str(current_wave)


func on_wave_state_changed() -> void:
	get_ready_label.hide()


# Show the final score
func on_game_over() -> void:
	# Finalize the score with: Score * Wave
	current_wave = int($GlobalStatsContainer/WaveContainer/WaveNumber.text)
	current_score *= current_wave
	score_number_label.text = str(current_score)
	# Show the final score
	game_over_container.show()


# Go back to main menu
func _on_MainMenu_pressed() -> void:
	GameConfig.player_list = {"player_one" : {
												"is_created" : false,
												"is_ready" : false
												},
								"player_two" : {
												"is_created" : false,
												"is_ready" : false
												},
								"player_three" : {
												"is_created" : false,
												"is_ready" : false
												},
								"player_four" : {
												"is_created" : false,
												"is_ready" : false
												}
								}
	
	
	assert(self.get_parent().get_parent().name == "SceneManager")
	self.get_parent().get_parent().choose_scene("main_menu")


# Quit the game
func _on_Quit_pressed() -> void:
	get_tree().quit()

