class_name Fireball
extends CharacterBody2D

var damage : float = 1.0 


func _ready():
	$Sprite.play("default")


func _physics_process(delta):
	velocity.x = -300
	move_and_collide(velocity * delta)

func _on_timer_timeout():
	queue_free()


func _on_hitbox_body_entered(body: Node2D):
	if body.name == "Player":
		var player : Player = body 
		var hurtbox = player.get_node("HurtboxComponent")
		if hurtbox:
			await get_tree().create_timer(0.05).timeout
			hurtbox.take_damage(damage, !player.is_blocking)
	queue_free()
