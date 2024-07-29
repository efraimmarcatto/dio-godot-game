extends Node2D

@onready var path_follow_2d: PathFollow2D = %PathFollow2D
@export var creatures: Array[PackedScene]
@export var mobs_per_minute: float = 60
@export var active: bool = true
var cooldown: float = 0.0

func _process(delta: float) -> void:

	if active:
		cooldown -= delta
		if cooldown > 0: return 
		
		var interval = 60.0 / mobs_per_minute
		cooldown = interval
		
		var creature_scene:PackedScene = creatures.pick_random()
		var creature = creature_scene.instantiate()
		creature.global_position = get_point()
		get_parent().add_child(creature)


func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
