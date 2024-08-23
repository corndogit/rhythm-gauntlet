extends Node


@export var bpm : float = 120.0
var beat : float = bpm / 60.0 / 4.0
var half_beat : float = beat / 2.0

@onready var music : AudioStreamPlayer = get_node("MusicPlayer")


func _ready():
	print(beat)
	music.play()
	
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_attack"):
		print(str("accuracy: " + str(get_accuracy())))


func get_accuracy():
	var position = absf(fmod(music.get_playback_position(), beat) - half_beat)
	return 100 * position / half_beat
