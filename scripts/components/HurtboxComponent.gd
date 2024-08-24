class_name HurtboxComponent
extends Node2D


var _is_damageable : bool = true
@export var healthComponent : HealthComponent
@export var cooldown : float = 0.1
@onready var timer : Timer = get_node("CooldownTimer")


func _process(_delta):
	_is_damageable = timer.is_stopped()


func take_damage(amount: float, deal_damage = true):
	if healthComponent and can_take_damage() and deal_damage:
		healthComponent.take_damage(amount)
		timer.start(cooldown)


func can_take_damage():
	return _is_damageable
