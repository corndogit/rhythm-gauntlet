extends Enemy


func _ready():
	health.max_hp = max_hp
	hp_bar.max_value = max_hp
	health.hp = max_hp
	hp_bar.value = max_hp
	can_be_hit = false


func _handle_beat(delta):
	if is_dead or _is_debouncing:
		return
	_is_debouncing = true
	
	if _beat_count == 0 and sight.is_colliding():
		attack(sight.get_collider(), delta)
	
	_beat_count = fmod(_beat_count + 1, 4)
	sprite.set_frame(_beat_count)
	
	if _beat_count == 1 or _beat_count == 2:
		can_be_hit = true
	else:
		can_be_hit = false
	
	await get_tree().create_timer(0.1).timeout
	_is_debouncing = false
	_beat_hit = false
