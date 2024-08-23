extends Control


func _ready() -> void:
	Singleton.weapon_1 = 1
	Singleton.weapon_2 = 1


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_weapon_1_item_selected(index: int) -> void:
	Singleton.weapon_1 = index + 1


func _on_weapon_2_item_selected(index: int) -> void:
	Singleton.weapon_2 = index + 1
