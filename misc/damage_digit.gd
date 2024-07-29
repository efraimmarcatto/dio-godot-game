extends Node2D

@export var damage_amount = 0
@onready var label: Label = $LabelNode/Label

func _ready() -> void:
	label.text = str(damage_amount)
