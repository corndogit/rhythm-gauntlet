extends Node2D


var hp : float
@export var max_hp : float = 10.0
var has_died = false

signal health_changed(amount: float)
signal health_died


func _ready():
	hp = max_hp


func take_damage(amount: float):
	hp -= amount
	health_changed.emit(hp)
	if hp <= 0:
		has_died = true
		health_died.emit()
