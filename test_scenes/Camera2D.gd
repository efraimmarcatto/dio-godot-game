extends Camera2D

func _process(delta: float) -> void:
	global_position = GameManager.player_position
