class_name ComboComponent
extends Control


const JUDGE_TEXT = ["Miss", "Good", "Great", "Perfect"]
var score = 0
var max_score = 0
var combo = 0
var max_combo = 0
var hits_taken = 0

@export var perfect_color : Color = Color(0, 1, 1, 1)
@export var mid_color : Color = Color(1, 1, 0, 1)
@export var miss_color : Color = Color(1, 0, 0, 1)
@export var block_success_color : Color = Color(1, 1, 1, 1)

@onready var display_timer : Timer = get_node("DisplayTimer")
@onready var judge_label : Label = get_node("HBoxContainer/JudgeLabel")
@onready var combo_label : Label = get_node("HBoxContainer/ComboCountLabel")


func _set_judge_label_text(accuracy: int):
	_start_display_timer()
	if accuracy >= 3:
		judge_label.modulate = perfect_color
	elif accuracy >= 1:
		judge_label.modulate = mid_color
	else:
		judge_label.modulate = miss_color
	judge_label.text = JUDGE_TEXT[accuracy]

func on_player_enemy_hit(accuracy: float):
	_start_display_timer()
	if accuracy >= 1:
		combo += 1
	else:
		combo = 0
	
	_set_judge_label_text(int(accuracy))
	
	combo_label.text = str(combo)
	max_combo = max(combo, max_combo)
	score += accuracy
	max_score += 3


func on_player_blocked(success):
	_start_display_timer()
	judge_label.text = "Block"
	if success:
		judge_label.modulate = block_success_color
		combo_label.text = "!"
	else:
		judge_label.modulate = miss_color
		combo_label.text = "x"
	
	
func on_game_over():
	ScoreManager.score = score
	ScoreManager.max_score = max_score
	ScoreManager.combo = combo
	ScoreManager.max_combo = max_combo
	ScoreManager.hits_taken = hits_taken


func _ready():
	self.visible = false


func _start_display_timer():
	self.visible = true
	display_timer.start()


func _on_display_timer_timeout():
	self.visible = false
