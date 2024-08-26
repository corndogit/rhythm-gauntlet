extends CanvasLayer


@export var title_text : String = "Game Over"

@onready var game_over_label = get_node("MarginContainer/VBoxContainer/GameOverLabel")
@onready var score_label : Label = get_node("MarginContainer/VBoxContainer/LabelsHBox/ScoreLabel")
@onready var max_combo_label : Label = get_node("MarginContainer/VBoxContainer/LabelsHBox/MaxComboLabel")
@onready var hits_taken_label : Label = get_node("MarginContainer/VBoxContainer/LabelsHBox/HitsTakenLabel")

@onready var level_button : Button = get_node("MarginContainer/VBoxContainer/ButtonsHBox/LevelButton")


func _ready():
	game_over_label.text = ScoreManager.title_text if ScoreManager.title_text != "" else title_text 
	score_label.text = score_label.text % ScoreManager.score
	max_combo_label.text = max_combo_label.text % ScoreManager.max_combo
	hits_taken_label.text = hits_taken_label.text % ScoreManager.hits_taken
	
	if ScoreManager.next_level_scene_path == "":
		level_button.text = "Retry"


func _on_main_menu_button_pressed():
	ScoreManager.reset()
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	


func _on_level_button_pressed():
	var scene_path = ScoreManager.next_level_scene_path
	ScoreManager.reset()
	if scene_path == "":
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file(scene_path)
	ScoreManager.next_level_scene_path = ""
