extends CharacterBody2D


@export var speed = 300.0
@export var base_damage = 1.0
@export var action_delay = 0.5

var can_attack = true
var can_be_hit = true

@onready var sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var sight : RayCast2D = get_node("Sight")
@onready var hp_bar : ProgressBar = get_node("ProgressBar")
@onready var health = get_node("HealthComponent")
@onready var attack_timer : Timer = get_node("AttackTimer")
@onready var block_timer : Timer = get_node("BlockTimer")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func attack():
	if is_facing_enemy():
		var enemy = sight.get_collider()
		var hurtbox = enemy.get_node("HurtboxComponent")
		if hurtbox:
			hurtbox.take_damage(base_damage)


func block():
	can_be_hit = false
	block_timer.start(action_delay)
	

func is_facing_enemy():
	return sight.is_colliding() and sight.get_collider().get("name") == "Enemy"


func _ready():
	hp_bar.value = health.max_hp


func _handle_input():
	# Don't attack during cooldown
	if not can_attack:
		return

	if Input.is_action_just_pressed("ui_attack"):
		print("attack!")
		attack()
		_handle_action_cooldown()
	elif Input.is_action_just_pressed("ui_block"):
		print("block!")
		block()
		_handle_action_cooldown()


func _handle_movement(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# keep moving unless sight is intercepted by an enemy
	if not is_facing_enemy():
		velocity.x = speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()


func _handle_action_cooldown():
	can_attack = false
	attack_timer.start(action_delay)


func _physics_process(delta):
	_handle_movement(delta)
	_handle_input()


func _on_health_component_health_changed(amount):
	if hp_bar:
		hp_bar.value = amount


func _on_health_component_health_died():
	queue_free()


func _on_block_timer_timeout():
	can_be_hit = true


func _on_attack_timer_timeout():
	can_attack = true # Replace with function body.
