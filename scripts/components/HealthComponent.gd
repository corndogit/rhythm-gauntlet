extends Node2D


var hp : float
@export var max_hp : float = 10.0
var has_died = false
@onready var hitSound : AudioStreamPlayer2D = get_node("HitSound")
@onready var dieSound : AudioStreamPlayer2D = get_node("DieSound")

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
		dieSound.play()
	else:
		hitSound.play()
