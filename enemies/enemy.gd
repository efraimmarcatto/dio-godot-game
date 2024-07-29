class_name Enemy
extends Node2D

@export var health: int = 10
@export var death_body: PackedScene
@onready var hit_label_marker: Marker2D = $HitLabelMarker
@onready var damage_digit = preload("res://misc/damage_digit.tscn")
@export var attack_damage: int = 1

func damage(amount: int)->void:
	var hit_label = damage_digit.instantiate()
	hit_label.damage_amount = amount
	if hit_label_marker:
		hit_label.position = hit_label_marker.position
	add_child(hit_label)
	health -= amount
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	if health <=0:
		die()

func  die()->void:
	if death_body:
		var death_object = death_body.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	queue_free()
