class_name Player
extends CharacterBody2D


@export var speed = 0.0
@export var base_damage = 1.0
@export var action_delay = 0.5
@export var level_music : LevelMusic

var can_attack = true
var is_blocking = false
var can_be_hit = true
var is_game_over = false
var has_stopped_once = false

var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var sight : RayCast2D = get_node("Sight")
@onready var hp_bar : ProgressBar = get_node("ProgressBar")
@onready var health : HealthComponent = get_node("HealthComponent")
@onready var combo : ComboComponent = get_node("ComboComponent")
@onready var attack_timer : Timer = get_node("AttackTimer")
@onready var block_timer : Timer = get_node("BlockTimer")


signal enemy_hit(accuracy: int)
signal player_blocked(success: bool)


func attack():
	sprite.play("attack")
	if is_facing_enemy():
		var enemy = sight.get_collider()
		var hurtbox = enemy.get_node("HurtboxComponent")
		if hurtbox:
			var accuracy = level_music.get_accuracy()
			hurtbox.take_damage(base_damage * accuracy, enemy.can_be_hit)
			if enemy.can_be_hit:
				combo.on_player_enemy_hit(accuracy)
	await sprite.animation_finished
	sprite.play("default")


func block():
	is_blocking = true
	var successful_block = level_music.get_accuracy() >= 2
	if successful_block:
		sprite.play("block")
		can_be_hit = false
	else:
		sprite.play("hurt")
	combo.on_player_blocked(successful_block)
	block_timer.start(action_delay * 2)
	await sprite.animation_finished
	sprite.play("default")
	

func is_facing_enemy():
	var facing_enemy = sight.is_colliding() and "Enemies" in sight.get_collider().get_groups()
	if not facing_enemy: 
		return false
	var enemy = sight.get_collider() 
	return facing_enemy and not enemy.is_dead


func _stop_moving():
	velocity.x = move_toward(velocity.x, 0, speed)
	if not has_stopped_once:
		sprite.play("default")
		has_stopped_once = true


func _color_flash(color):
	sprite.modulate = color
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1, 1)


func _handle_action_cooldown():
	can_attack = false
	attack_timer.start(action_delay)


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
	if not is_facing_enemy() and not is_blocking:
		velocity.x = speed
		sprite.play("walk")
		has_stopped_once = false
	else:
		_stop_moving()

	move_and_slide()


func _show_game_over_dialog():
	combo.on_game_over()
	var dialog = load("res://scenes/ui/game_over_dialog.tscn").instantiate()
	add_child(dialog)


func _on_health_component_health_changed(amount):
	if amount < hp_bar.value:  # take damage
		_color_flash(Color(1, 0.8, 0.8, 0.8))
		sprite.play("hurt")
		_handle_action_cooldown()
		combo.hits_taken += 1
	elif amount > hp_bar.value:  # heal
		_color_flash(Color(0.8, 1, 0.8, 1))
	hp_bar.value = amount
	await sprite.animation_finished
	sprite.play("default")


func _on_health_component_health_died():
	ScoreManager.title_text = "You Died"
	can_be_hit = false
	is_game_over = true
	sprite.play("death")
	await sprite.animation_finished
	sprite.visible = false
	hp_bar.visible = false
	_show_game_over_dialog()


func _on_block_timer_timeout():
	can_be_hit = true
	is_blocking = false


func _on_attack_timer_timeout():
	can_attack = true


func _on_goal_level_finish():
	ScoreManager.title_text = "You Win!"
	GlobalConfig.enable_level_two = true
	is_game_over = true
	combo.on_game_over()
	_show_game_over_dialog()


func _ready():
	hp_bar.value = health.max_hp
	sprite.play("default")


func _physics_process(delta):
	if is_game_over:
		_stop_moving()
		return
	_handle_movement(delta)
	_handle_input()
