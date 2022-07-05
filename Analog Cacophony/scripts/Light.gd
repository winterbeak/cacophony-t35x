extends Node2D

const RED_TIME: float = 0.8

export var key = ""

var tex_unpressed: Texture = preload("res://assets/images/button_unpressed.png")
var tex_pressed: Texture = preload("res://assets/images/button_pressed.png")
var tex_yellow_unpressed: Texture = preload("res://assets/images/button_yellow_unpressed.png")
var tex_yellow_pressed: Texture = preload("res://assets/images/button_yellow_pressed.png")
var tex_red_unpressed: Texture = preload("res://assets/images/button_red_unpressed.png")
var tex_red_pressed: Texture = preload("res://assets/images/button_red_pressed.png")

onready var timer: Timer = $Timer
onready var sprite: Sprite = $Sprite

enum LIGHT_COLOR {OFF, YELLOW, RED}

var pressed: bool = false
var color: int = LIGHT_COLOR.OFF

func _ready() -> void:
	sprite.texture = tex_unpressed
	turn_off()

func turn_on() -> void:
	turn_color(LIGHT_COLOR.YELLOW)

func turn_off() -> void:
	turn_color(LIGHT_COLOR.OFF)

# Turns the light red for an amount of time determined by RED_TIME.
func flash_red() -> void:
	turn_color(LIGHT_COLOR.RED, RED_TIME)

# Turns the light a color for a certain amount of time.
# If the time is negative, the light is turned on indefinitely.
func turn_color(color_const: int, time: float = -1.0):
	color = color_const
	if time >= 0.0:
		timer.start(time)
		
	# If another call to turn_color occurs before this one ends
	else:
		timer.stop()

func press() -> void:
	pressed = true

func release() -> void:
	pressed = false

func current_sprite() -> Texture:
	if pressed:
		if color == LIGHT_COLOR.YELLOW:
			return tex_yellow_pressed
		elif color == LIGHT_COLOR.RED:
			return tex_red_pressed
		else:
			return tex_pressed
	else:
		if color == LIGHT_COLOR.YELLOW:
			return tex_yellow_unpressed
		elif color == LIGHT_COLOR.RED:
			return tex_red_unpressed
		else:
			return tex_unpressed

func _process(delta):
	if Input.is_action_just_pressed(key):
		self.press()
	elif Input.is_action_just_released(key):
		self.release()
	
	sprite.texture = current_sprite()

# Called when the timer runs out.
func _on_Timer_timeout():
	turn_off()