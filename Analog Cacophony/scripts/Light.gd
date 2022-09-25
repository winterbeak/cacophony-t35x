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
onready var unlit_sprite: Sprite = $UnlitSprite
onready var lit_sprite: Sprite = $LitSprite
onready var key_text: Label = $KeyText

enum LIGHT_COLOR {OFF, YELLOW, RED}

var pressed: bool = false
var color: int = LIGHT_COLOR.OFF

func label_text() -> String:
	if key == "S":
		return ";"
	elif key == "?":
		return "/"
	else:
		return key.to_upper()

func _ready() -> void:
	key_text.text = label_text()
	unlit_sprite.texture = tex_unpressed
	lit_sprite.modulate.a = 0.0
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
	key_text.rect_position.y = 14

func release() -> void:
	pressed = false
	key_text.rect_position.y = 10

func _process(delta):
	if Input.is_action_just_pressed(key):
		self.press()
	elif Input.is_action_just_released(key):
		self.release()
	
	if color == LIGHT_COLOR.OFF:
		lit_sprite.modulate.a = 0.0
	else:
		lit_sprite.modulate.a = 1.0
	if pressed:
		unlit_sprite.texture = tex_pressed
		if color == LIGHT_COLOR.YELLOW:
			lit_sprite.texture = tex_yellow_pressed
		elif color == LIGHT_COLOR.RED:
			lit_sprite.texture = tex_red_pressed
	else:
		unlit_sprite.texture = tex_unpressed
		if color == LIGHT_COLOR.YELLOW:
			lit_sprite.texture = tex_yellow_unpressed
		elif color == LIGHT_COLOR.RED:
			lit_sprite.texture = tex_red_unpressed

# Called when the timer runs out.
func _on_Timer_timeout():
	turn_off()
