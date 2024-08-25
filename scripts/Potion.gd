extends StaticBody2D

@export var heal_amount : float = 2.5

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		var player : Player = body
		var health : HealthComponent = player.get_node("HealthComponent")
		if health:
			health.heal(heal_amount)
		queue_free()
