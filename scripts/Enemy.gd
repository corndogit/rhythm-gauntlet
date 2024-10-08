class_name Enemy
extends CharacterBody2D


const SPEED = 20.0
const BEATS_PER_ACTION = 4

var can_attack = true
var can_be_hit = true
var is_dead = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var _beat_count = 0
var _is_debouncing = false
var _beat_hit = false

@export var level_music : LevelMusic
@export var max_hp : float = 10
@export var base_damage = 1.0

@onready var hp_bar : ProgressBar = get_node("ProgressBar")
@onready var health : HealthComponent = get_node("HealthComponent")
@onready var sight : RayCast2D = get_node("Sight")
@onready var sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var collision_shape : CollisionShape2D = get_node("CollisionShape2D")

signal enemy_died

func attack(target, delay = 0.0):
	if "Enemies" in target.get_groups():
		return
	var hurtbox = target.get_node("HurtboxComponent")
	if hurtbox:
		if delay > 0.0:
			await get_tree().create_timer(delay * 2).timeout
		hurtbox.take_damage(base_damage, target.can_be_hit)


func _ready():
	health.max_hp = max_hp
	hp_bar.max_value = max_hp
	health.hp = max_hp
	hp_bar.value = max_hp


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if _beat_hit:
		_handle_beat(delta)
	
	move_and_slide()


func _on_health_component_health_changed(amount: float):
	if hp_bar:
		hp_bar.value = amount
	_damage_flash(0.1)


func _damage_flash(duration):
	sprite.modulate = Color(1, 0.8, 0.8, 0.8)
	await get_tree().create_timer(duration).timeout
	sprite.modulate = Color(1, 1, 1, 1)


func _on_health_component_health_died():
	visible = false
	is_dead = true
	collision_shape.disabled = true
	enemy_died.emit(self)
	await get_tree().create_timer(0.5).timeout
	queue_free()


func _on_level_music_beat_hit():
	_beat_hit = true


func _handle_beat(delta):
	if is_dead or _is_debouncing:
		return
	_is_debouncing = true
	if _beat_count == 0:
		_attack_motion()
		if sight.is_colliding():
			attack(sight.get_collider(), delta)
	
	_beat_count = fmod(_beat_count + 1, 4)
	sprite.set_frame(_beat_count)
	
	await get_tree().create_timer(0.1).timeout
	_is_debouncing = false
	_beat_hit = false

func _attack_motion():
	velocity.y += -100.0
