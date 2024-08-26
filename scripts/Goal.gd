extends StaticBody2D


signal level_finish

func _on_area_2d_body_entered(_body):
	level_finish.emit()
