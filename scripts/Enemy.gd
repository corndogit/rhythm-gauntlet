extends CharacterBody2D


const SPEED = 20.0
const JUMP_VELOCITY = -400.0

var can_attack = true
var can_be_hit = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var hp_bar : ProgressBar = get_node("ProgressBar")
@onready var health = get_node("HealthComponent")


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
	queue_free()
