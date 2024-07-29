extends Node

@export var speed: float = 1

@export var enemy: Enemy
@export var sprite: AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var player_position: Vector2 = GameManager.player_position
	var direction = (player_position - enemy.position).normalized()
	
	enemy.velocity = direction * speed * 100
	enemy.move_and_slide()
	
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0: 
		sprite.flip_h = true
