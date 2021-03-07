extends Node2D

onready var face := $face
onready var faceSprite := $face/face
onready var eyeBack := $face/eye
onready var eyeBack2 := $face/eye2
onready var mouth := $face/mouth
onready var eyeLidl := $face/eye/eyeLid
onready var eyeLidr := $face/eye2/eyeLid
onready var tween := $Tween
onready var eyepupill := $face/eye/pupil
onready var eyepupilr := $face/eye2/pupil

onready var eyeIrisL := $face/eye/iris
onready var eyeIrisR := $face/eye2/iris

export var inMainScene := true
onready var lookAtEr := $lookatEr
export var angleFrition := 0.45
export var faceFric := 0.02
export var mouthFric := 0.5
export var chanceOfRandLookToMove := 0.01
export var mouseMarginBox := 50
export var clampedExtents := 40
export var randomWanderExtents := 8
export var dur := 0.111
var effect : AudioEffectRecord
var idx = AudioServer.get_bus_index("Record")
var screensize : Vector2
var oldMousePos : Vector2
var randomLook := false
var newFacePos : Vector2
var speedOfWindow := 10
var beginningInfoText ="""
Hello, PLEASE READ THIS! \n
press H to see this message again, this is the (h)elp message
press f to go (f)ullscreen, and exit it \n
press b to go (b)ack home \n
press 0 to go to fl(0)ating mode \n
press e to go to window(e)d mode \n
press esc to close the program - or alt + f4
"""

#ADD A WAY TO SHOW EMOTIONS

func _ready() -> void:
	screensize = get_viewport_rect().size
	effect = AudioServer.get_bus_effect(idx, 0)
	effect.set_recording_active(true)
	effect.format = 0
	randomize()
	if inMainScene:
		OS.alert(beginningInfoText, "READ ME")
		OS.set_window_always_on_top(true)
		OS.window_per_pixel_transparency_enabled = false
		get_tree().get_root().set_transparent_background(true)
		faceSprite.modulate = Global.faceCol
		eyeIrisL.modulate = Global.irisCol
		eyeIrisR.modulate = Global.irisCol
		eyeLidl.modulate = Global.eyeLidCol
		eyeLidr.modulate = Global.eyeLidCol
		eyepupill.modulate = Global.pupilCol
		eyepupilr.modulate = Global.pupilCol
		mouth.modulate = Global.mouthCol
	
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("h"):
		OS.set_window_always_on_top(false)
		OS.alert(beginningInfoText, "READ ME")
		OS.set_window_always_on_top(true)
	if Input.is_action_just_pressed("f"):
		OS.window_fullscreen = !OS.window_fullscreen
		print("presed")
		OS.window_per_pixel_transparency_enabled = true
		get_tree().get_root().set_transparent_background(true)
#	print(get_global_mouse_position())
	if Input.is_action_pressed("b"):
		get_tree().change_scene("res://src/HomeScreen/HomeScreen.tscn")
	if Input.is_action_pressed("eee"):
		print(OS.window_size)
		OS.window_size.y = OS.window_size.x
		OS.window_borderless = false 
		OS.window_per_pixel_transparency_enabled = false
		get_tree().get_root().set_transparent_background(true)
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_just_pressed("switchToFloating"):
		OS.window_borderless = true 
		print(OS.window_size)
		OS.window_size.x = OS.window_size.y
		OS.window_per_pixel_transparency_enabled = true
		get_tree().get_root().set_transparent_background(true)
		pass
	if Input.is_action_just_pressed("minus"):
		if speedOfWindow >= 2:
			speedOfWindow -= 1
	if Input.is_action_just_pressed("plus"):
		if speedOfWindow <= 50:
			speedOfWindow += 1
#	print(speedOfWindow)
	if Input.is_action_pressed("ui_left"):
		OS.window_position.x -= speedOfWindow
	if Input.is_action_pressed("ui_right"):
		OS.window_position.x += speedOfWindow
	if Input.is_action_pressed("ui_up"):
		OS.window_position.y -= speedOfWindow
	if Input.is_action_pressed("ui_down"):
		OS.window_position.y += speedOfWindow
	if !inMainScene:
		faceSprite.modulate = Global.faceCol
		eyeIrisL.modulate = Global.irisCol
		eyeIrisR.modulate = Global.irisCol
		eyeLidl.modulate = Global.eyeLidCol
		eyepupill.modulate = Global.pupilCol
		eyepupilr.modulate = Global.pupilCol
		mouth.modulate = Global.mouthCol


	
	
#Make sure to enable audio input
#Make sure to get a audiostreammicrophoneinput
#Make sure ur main microphone is the default one on the computer
func _process(delta: float) -> void:
#	Thinking of using a position 2d to control where the face looks
	var newAng :float= lookAtEr.global_position.angle_to_point(screensize/2)
	eyeBack.rotation = lerp_angle(eyeBack.rotation, newAng, angleFrition)
	eyeBack2.rotation = lerp_angle(eyeBack2.rotation, newAng, angleFrition)
	if Input.is_action_just_pressed("click"):
		randomLook = false
	var amt := 5
	if Input.is_action_pressed("ABtn"):
		print('pressed A')
		eyeBack.rotation_degrees += amt
		eyeBack2.rotation_degrees += amt
	if Input.is_action_pressed("DBtn"):
		print('pressed D')
		eyeBack.rotation_degrees -= amt
		eyeBack2.rotation_degrees -= amt
		
	var global_mouse_pos = OS.get_window_position() + get_global_mouse_position()
	
	if randomLook:
		if randf() < chanceOfRandLookToMove:
			screensize = get_viewport_rect().size
#			print("happened", get_global_mouse_position(), screensize)
			if get_global_mouse_position().x > screensize.x/2 and get_global_mouse_position().y < screensize.y/2:
				var b : Vector2 = Vector2( (rand_range(-600,-100)),(rand_range( 100 , 500  )) ).clamped(clampedExtents)
#				print("right top", b)
				lookAtEr.global_position = screensize/2 + -b
			if get_global_mouse_position().x <= screensize.x/2 and get_global_mouse_position().y < screensize.y/2:
				var b : Vector2 = Vector2( (rand_range(200,250)),(rand_range( 0 , 500  )) ).clamped(clampedExtents)
#				print("left top", b)
				lookAtEr.global_position = screensize/2 + -b
			if get_global_mouse_position().x > screensize.x/2 and get_global_mouse_position().y >= screensize.y/2:
#				print("right bottom")
				var b : Vector2 = Vector2( (rand_range(200,250)),(rand_range( 0 , 500  )) ).clamped(clampedExtents)
				lookAtEr.global_position = screensize/2 + +b
			if get_global_mouse_position().x <= screensize.x/2 and get_global_mouse_position().y >= screensize.y/2:
#				print("left bottom")
				var b : Vector2 = Vector2( (rand_range(-400,-200)),(rand_range( 0 , 500  )) ).clamped(clampedExtents)
				lookAtEr.global_position = screensize/2 + +b


	else:
#		print(get_global_mouse_position())

		lookAtEr.global_position = face.get_local_mouse_position().clamped(25) + screensize/2
	if inMainScene:
		face.global_position = lerp(face.global_position, lookAtEr.global_position,faceFric)
	var newPos := get_global_mouse_position()
	var noiseLevel = abs(AudioServer.get_bus_peak_volume_left_db(AudioServer.get_bus_index("Record"), 0))
#	print(noiseLevel," ", modulator)
	
	if noiseLevel < 120 or true:
#SIMPLEFIEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
		var clamped :float = range_lerp(noiseLevel, 78, 135, 10, 0  )
		var xVal : float = (-0.014*clamped*clamped+2)
		var yVal : float = (0.014*clamped*clamped+0.75)

		mouth.scale.x = lerp(mouth.scale.x, xVal, mouthFric)
		mouth.scale.y = lerp(mouth.scale.y, yVal, mouthFric)
	else:
#		var clamped :float = range_lerp(noiseLevel, 78, 135, 10, 0  )
#	#	print(randomLook)
#		var xVal : float = (-0.0012*clamped*clamped+2)
#		var yVal : float = (0.002*clamped*clamped+0.5)
#
#		mouth.scale.x = lerp(mouth.scale.x, xVal, mouthFric)
#		mouth.scale.y = lerp(mouth.scale.y, yVal, mouthFric)
		pass
#	mouth.scale.x = xVal
#	mouth.scale.y = yVal



##	Starts at 80
#	var fac := 4
#	var xVal : float = (noiseLevel/100 / 0.45*fac)/fac * 70/noiseLevel
#	var yVal : float = (2/(noiseLevel/150)/(noiseLevel / 200))/fac * 105/noiseLevel
#	print(noiseLevel)
#	noiseLevel = 10/(noiseLevel/10)
#	if noiseLevel >= 0.9:
#		mouth.scale.x = clamp( lerp(mouth.scale.x, xVal, mouthFric), -10, 10 )
#		mouth.scale.y = clamp( lerp(mouth.scale.y, yVal, mouthFric), -10, 10 )  
#	else:
#		mouth.scale.x = clamp( lerp(mouth.scale.x, 2, mouthFric), -10, 10 )
#		mouth.scale.y = clamp( lerp(mouth.scale.y, 1, mouthFric), -10, 10 )  
##	mouth.scale.x = xVal/fac
##	mouth.scale.y = yVal/fac
##	print(noiseLevel)
##	print(xVal,yVal)
	
	if Input.is_action_pressed("rightClick"):
#	print("timer timed out")
		tween.interpolate_property(eyeLidl, "modulate", Color8(Global.eyeLidCol.r,Global.eyeLidCol.g,Global.eyeLidCol.b,0), Global.eyeLidCol, dur, Tween.TRANS_CIRC,Tween.EASE_OUT)
		tween.interpolate_property(eyeLidr, "modulate", Color8(Global.eyeLidCol.r,Global.eyeLidCol.g,Global.eyeLidCol.b,0), Global.eyeLidCol, dur, Tween.TRANS_CIRC,Tween.EASE_OUT)

		tween.interpolate_property(eyeLidl, "modulate", Global.eyeLidCol, Color8(Global.eyeLidCol.r,Global.eyeLidCol.g,Global.eyeLidCol.b,0) ,dur , Tween.TRANS_CIRC,Tween.EASE_IN)
		tween.interpolate_property(eyeLidr, "modulate", Global.eyeLidCol, Color8(Global.eyeLidCol.r,Global.eyeLidCol.g,Global.eyeLidCol.b,0) , dur, Tween.TRANS_CIRC,Tween.EASE_IN)
		tween.start()


func _on_Timer_timeout() -> void:
#	$AnimationPlayer.play("blink")
#	print("timer timed out")
	tween.interpolate_property(eyeLidl, "modulate", Color8(Global.eyeLidCol.r,Global.eyeLidCol.g,Global.eyeLidCol.b,0), Global.eyeLidCol, dur, Tween.TRANS_CIRC,Tween.EASE_OUT)
	tween.interpolate_property(eyeLidr, "modulate", Color8(Global.eyeLidCol.r,Global.eyeLidCol.g,Global.eyeLidCol.b,0), Global.eyeLidCol, dur, Tween.TRANS_CIRC,Tween.EASE_OUT)

	tween.interpolate_property(eyeLidl, "modulate", Global.eyeLidCol, Color8(Global.eyeLidCol.r,Global.eyeLidCol.g,Global.eyeLidCol.b,0) ,dur , Tween.TRANS_CIRC,Tween.EASE_IN)
	tween.interpolate_property(eyeLidr, "modulate", Global.eyeLidCol, Color8(Global.eyeLidCol.r,Global.eyeLidCol.g,Global.eyeLidCol.b,0) , dur, Tween.TRANS_CIRC,Tween.EASE_IN)
	tween.start()
#	used to be 1,7 for rand_range
	$Timer.start(rand_range(1,7))


func _on_moveTimer_timeout() -> void:
	if oldMousePos == get_global_mouse_position():
		randomLook = true
		print("swtiched to true")
		pass
	else :
		print("swtiched to false")
		randomLook = false
		pass
	oldMousePos = get_global_mouse_position()

