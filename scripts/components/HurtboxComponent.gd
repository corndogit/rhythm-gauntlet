extends Node2D


var _is_damageable = true
@export var healthComponent : Node2D
@export var cooldown : float = 0.5
@onready var timer : Timer = get_node("CooldownTimer")


func _process(_delta):
	_is_damageable = timer.is_stopped()


func take_damage(amount: float):
	print("hurtbox taking damage")
	if healthComponent and _is_damageable:
		print(healthComponent)
		healthComponent.take_damage(amount)
		timer.start(cooldown)


func can_take_damage():
	return _is_damageable
