extends Control
@onready var texture_1: TextureButton = $HBoxContainer/Texture1
@onready var texture_2: TextureButton = $HBoxContainer/Texture2
@onready var texture_3: TextureButton = $HBoxContainer/Texture3
@export var texture1: Texture2D
@export var texture2: Texture2D
@export var texture3: Texture2D


var atlas: AtlasTexture

func _on_texture_1_pressed() -> void:
	if texture1:
		GameManager.player_texture = texture1
	get_tree().change_scene_to_file("res://test_scenes/test_scene.tscn")


func _on_texture_2_pressed() -> void:
	if texture2:
		GameManager.player_texture = texture2
	get_tree().change_scene_to_file("res://test_scenes/test_scene.tscn")


func _on_texture_3_pressed() -> void:
	if texture3:
		GameManager.player_texture = texture3
	get_tree().change_scene_to_file("res://test_scenes/test_scene.tscn")

