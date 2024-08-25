extends Node2D


var level_one = preload("res://scenes/Main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player/Camera2D.enabled = false
	$Player/ProgressBar.visible = false
	$LevelMusic/BeatTracker.play()


func _on_play_game_button_pressed():
	_set_buttons_disabled(true)
	$AcceptSound.play()
	$Player.speed = 300
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_packed(level_one)


func _set_buttons_disabled(value : bool):
	$Control/Background/VBoxContainer/ButtonsContainer/PlayGameButton.disabled = value
	$Control/Background/VBoxContainer/ButtonsContainer/TutorialButton.disabled = value
	$Control/Background/VBoxContainer/ButtonsContainer/OptionsButton.disabled = value
