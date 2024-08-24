extends CharacterBody2D


const SPEED = 20.0
const BEATS_PER_ACTION = 4

var can_attack = true
var can_be_hit = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var _beat_count = 0

@export var level_music : LevelMusic

@onready var hp_bar : ProgressBar = $ProgressBar
@onready var health = $HealthComponent
@onready var sight = $Sight

signal enemy_died

func attack(enemy):
	var hurtbox = enemy.get_node("HurtboxComponent")
	if hurtbox:
		hurtbox.take_damage(1.0, enemy.can_be_hit)


func _ready():
	hp_bar.value = health.max_hp


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()


func _on_health_component_health_changed(amount: float):
	if hp_bar:
		hp_bar.value = amount


func _on_health_component_health_died():
	enemy_died.emit()
	queue_free()


func _on_level_music_beat_hit():
	if _beat_count == 0 and $Sight.is_colliding():
		velocity.y += -100.0
		attack($Sight.get_collider())

	_beat_count = fmod(_beat_count + 1, 4)
