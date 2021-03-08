extends Control

func _ready() -> void:
	OS.window_per_pixel_transparency_enabled = false
	get_tree().get_root().set_transparent_background(false)
	$VBoxContainer/HBoxContainer2/CheckButton.pressed = Global.canBlink
#func _physics_process(delta: float) -> void:
#	if Input.is_action_just_pressed("b"):
#		get_tree().change_scene("res://src/floatingCam/MainScene.tscn")


func _on_FACE(color: Color) -> void:
	Global.faceCol = color


func _on_IRIS(color: Color) -> void:
	Global.irisCol = color


func _on_EYELID(color: Color) -> void:
	Global.eyeLidCol = color


func _on_PUPILCOl(color: Color) -> void:
	Global.pupilCol = color


func _on_MOUTH(color: Color) -> void:
	Global.mouthCol = color




func _on_Button_pressed() -> void:
	get_tree().change_scene("res://src/floatingCam/MainScene.tscn")


func _on_HSlider_value_changed(value: float) -> void:
	print(value)
	Global.sensitivity = value
	


func _on_CheckButton_toggled(button_pressed: bool) -> void:
	Global.canBlink = button_pressed
	print(button_pressed)
