extends Node


func _ready():
	connect("enemy_died", _on_enemy_died)
	

func _on_enemy_died(enemy: Enemy):
	pass
