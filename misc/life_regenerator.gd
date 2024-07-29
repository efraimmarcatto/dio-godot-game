extends Node2D

@export var renegeration_amount: int = 10

func _ready() -> void:
	self.body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		body.heal(renegeration_amount)
		queue_free()
	
