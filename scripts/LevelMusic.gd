class_name LevelMusic
extends Node


@export var bpm : float = 120.0
var beat : float
var beat_half : float
var beat_16th : float

@onready var beat_tracker : AudioStreamPlayer = $BeatTracker
@onready var music : AudioStreamPlayer = $MusicPlayer


signal beat_hit

func _ready():
	music.play()
	beat_tracker.play()
	beat = 60.0 / bpm
	beat_half = beat / 2.0
	beat_16th = beat / 32.0
	print("%s BPM: beat=%s, beat_half=%s, beat_16th=%s" % [str(bpm),str(beat),str(beat_half),str(beat_16th)])


func _physics_process(delta):
	var pos_mod = fposmod(_get_beat_pos(), beat)
#	print("pos_mod: %s, delta: %s" % [str(pos_mod), str(delta)])
	if pos_mod <= delta * 2:
		beat_hit.emit()


func get_accuracy():
	var accuracy = absf(fmod(_get_beat_pos(), beat) - beat_half) / beat_half
	if accuracy > 0.85:
		return 3.0
	if accuracy > 0.70:
		return 2.0
	if accuracy > 0.65:
		return 1.0
	return 0.0


func _get_beat_pos():
	return beat_tracker.get_playback_position() + AudioServer.get_time_since_last_mix()
