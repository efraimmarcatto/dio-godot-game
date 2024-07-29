extends Node2D
@onready var area_2d: Area2D = $Area2D
@export var damage_amount: int = 5

func deal_damage():
	var bodies = area_2d.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			body.damage(damage_amount)
