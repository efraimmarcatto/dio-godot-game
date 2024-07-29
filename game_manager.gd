extends Node

var player_position: Vector2
var player_texture: Texture2D

func stop_spawners() -> void:
	var spawners = get_tree().get_nodes_in_group("spawners")
	for spawner in spawners:
		spawner.queue_free()
