class_name Player
extends CharacterBody2D


@export var speed = 0.0
@export var base_damage = 1.0
@export var action_delay = 0.5
@export var level_music : LevelMusic

var can_attack = true
var can_be_hit = true
var is_dead = false

@onready var sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var sight : RayCast2D = get_node("Sight")
@onready var hp_bar : ProgressBar = get_node("ProgressBar")
@onready var health : HealthComponent = get_node("HealthComponent")
@onready var attack_timer : Timer = get_node("AttackTimer")
@onready var block_timer : Timer = get_node("BlockTimer")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal player_died
signal enemy_hit


func attack():
	sprite.play("attack")
	if is_facing_enemy():
		var enemy = sight.get_collider()
		var hurtbox = enemy.get_node("HurtboxComponent")
		if hurtbox:
			var damage_dealt = base_damage * level_music.get_accuracy()
			hurtbox.take_damage(damage_dealt)
			enemy_hit.emit(damage_dealt)


func block():
	if level_music.get_accuracy() >= 1:
		sprite.play("block")
		can_be_hit = false
	else:
		sprite.play("block_fail")
	block_timer.start(action_delay * 2)
	

func is_facing_enemy():
	var facing_enemy = sight.is_colliding() and "Enemies" in sight.get_collider().get_groups()
	if not facing_enemy: 
		return false
	var enemy = sight.get_collider() 
	return facing_enemy and not enemy.is_dead


func _ready():
	hp_bar.value = health.max_hp


func _handle_input():
	# Don't attack during cooldown
	if not can_attack:
		return

	if Input.is_action_just_pressed("ui_attack"):
		attack()
		_handle_action_cooldown()
	elif Input.is_action_just_pressed("ui_block"):
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
	if is_dead:
		return
	_handle_movement(delta)
	_handle_input()


func _on_health_component_health_changed(amount):
	if hp_bar:
		hp_bar.value = amount
	_damage_flash(0.1)


func _damage_flash(duration):
	sprite.modulate = Color(1, 0.8, 0.8, 0.8)
	await get_tree().create_timer(duration).timeout
	sprite.modulate = Color(1, 1, 1, 1)


func _on_health_component_health_died():
	player_died.emit()
	sprite.visible = false
	can_be_hit = false
	is_dead = true


func _on_block_timer_timeout():
	sprite.play("default")
	can_be_hit = true


func _on_attack_timer_timeout():
	sprite.play("default")
	can_attack = true
