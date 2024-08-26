extends Node2D

const SCENE_ONE_PATH = "res://scenes/LevelOne.tscn"
const SCENE_TWO_PATH = "res://scenes/LevelTwo.tscn"

@onready var play_game_button = get_node("Control/Background/VBoxContainer/TitleContainer/VBoxContainer/ButtonsContainer/PlayGameButton")
@onready var play_level_two_button = get_node("Control/Background/VBoxContainer/TitleContainer/VBoxContainer/ButtonsContainer/PlayLevelTwoButton")
@onready var options_button = get_node("Control/Background/VBoxContainer/TitleContainer/VBoxContainer/ButtonsContainer/OptionsButton")

# Called when the node enters the scene tree for the first time.
func _ready():
	play_level_two_button.visible = GlobalConfig.enable_level_two
	play_level_two_button.disabled = not GlobalConfig.enable_level_two
	$Player/AnimatedSprite2D.play("default")
	$Player/Camera2D.enabled = false
	$Player/ProgressBar.visible = false
	$LevelMusic/BeatTracker.play()


func _on_play_game_button_pressed():
	await _start_game()
	ScoreManager.next_level_scene_path = SCENE_TWO_PATH
	get_tree().change_scene_to_file(SCENE_ONE_PATH)


func _set_buttons_disabled(value : bool):
	play_game_button.disabled = value
	play_level_two_button.disabled = value
	options_button.disabled = value


func _on_play_level_two_button_pressed():
	await _start_game()
	get_tree().change_scene_to_file(SCENE_TWO_PATH)


func _start_game():
	_set_buttons_disabled(true)
	$AcceptSound.play()
	$Enemy.queue_free()
	$Player/AnimatedSprite2D.play("walk")
	await get_tree().create_timer(2.0).timeout
	ScoreManager.reset()
