class_name FireballEmitterComponent
extends Area2D

@export var fireball_damage : float = 1.0
@onready var sound : AudioStreamPlayer2D = get_node("FireSound")
var fireball_scene = load("res://scenes/entities/fireball.tscn") 


func fire():
	var instance = fireball_scene.instantiate()
	instance.damage = fireball_damage
	sound.play()
	add_child(instance)
