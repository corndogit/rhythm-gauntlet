extends ParallaxBackground


const DEFAULT_SCALE = 1.0

@export var animation_step : float = 0.025

@onready var indicator : TextureRect = get_node("MarginContainer/BeatIndicator")


func _on_level_music_beat_hit():
	_scale_animation()


func _scale_animation():
	var scale_factor = 1.15
	while scale_factor > DEFAULT_SCALE:
		indicator.scale = Vector2(scale_factor, scale_factor)
		scale_factor -= animation_step
		await get_tree().create_timer(animation_step).timeout
	indicator.scale = Vector2(DEFAULT_SCALE, DEFAULT_SCALE)
