extends Node2D


@onready var play_game_button = get_node("Control/Background/VBoxContainer/TitleContainer/VBoxContainer/ButtonsContainer/PlayGameButton")
@onready var options_button = get_node("Control/Background/VBoxContainer/TitleContainer/VBoxContainer/ButtonsContainer/OptionsButton")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player/AnimatedSprite2D.play("default")
	$Player/Camera2D.enabled = false
	$Player/ProgressBar.visible = false
	$LevelMusic/BeatTracker.play()


func _on_play_game_button_pressed():
	_set_buttons_disabled(true)
	$AcceptSound.play()
	$Enemy.queue_free()
	$Player/AnimatedSprite2D.play("walk")
	await get_tree().create_timer(2.0).timeout
	ScoreManager.reset()
	get_tree().change_scene_to_file("res://scenes/LevelOne.tscn")


func _set_buttons_disabled(value : bool):
	play_game_button.disabled = value
	options_button.disabled = value
