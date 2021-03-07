extends Control


func _ready() -> void:
	OS.window_per_pixel_transparency_enabled = false
	get_tree().get_root().set_transparent_background(false)


func _on_Button_pressed() -> void:
	get_tree().change_scene("res://src/floatingCam/MainScene.tscn")



func _on_settings_pressed() -> void:
	get_tree().change_scene("res://src/HomeScreen/Settings/Settings.tscn")


func _on_extraInfo_pressed() -> void:
	pass # Replace with function body.
