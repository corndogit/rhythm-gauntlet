extends Node


var title_text : String = ""
var next_level_scene_path : String = ""
var score : int = 0
var max_score : int = 0
var combo : int = 0
var max_combo : int = 0
var hits_taken : int = 0


func reset():
	title_text = ""
	next_level_scene_path = ""
	score = 0
	max_score = 0
	combo = 0
	max_combo = 0
	hits_taken = 0
