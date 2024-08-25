extends Enemy


@onready var emitter : FireballEmitterComponent = get_node("FireballEmitterComponent")

func attack(target, _delay = 0.0):
	if "Enemies" in target.get_groups():
		return
	emitter.fire()


func _attack_motion():
	pass
