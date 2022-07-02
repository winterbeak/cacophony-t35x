extends Node2D

const RED_TIME: float = 0.8

export var key = ""

var tex_unpressed: Texture = preload("res://assets/images/button_unpressed.png")
var tex_pressed: Texture = preload("res://assets/images/button_pressed.png")
var tex_yellow_unpressed: Texture = preload("res://assets/images/button_yellow_unpressed.png")
var tex_yellow_pressed: Texture = preload("res://assets/images/button_yellow_pressed.png")
var tex_red_unpressed: Texture = preload("res://assets/images/button_red_unpressed.png")
var tex_red_pressed: Texture = preload("res://assets/images/button_red_pressed.png")

onready var red_timer: Timer = $RedTimer
onready var sprite: Sprite = $Sprite

const OFF: int = 0
const YELLOW: int = 1
const RED: int = 2

var pressed: bool = false
var color: int = OFF

func _ready() -> void:
	sprite.texture = tex_unpressed
	turn_off()

func turn_on() -> void:
	color = YELLOW

func turn_off() -> void:
	color = OFF

# Turns the light red for an amount of time determined by RED_TIME.
func turn_red() -> void:
	color = RED
	red_timer.start(RED_TIME)

func press() -> void:
	pressed = true

func release() -> void:
	pressed = false

func current_sprite() -> Texture:
	if pressed:
		if color == YELLOW:
			return tex_yellow_pressed
		elif color == RED:
			return tex_red_pressed
		else:
			return tex_pressed
	else:
		if color == YELLOW:
			return tex_yellow_unpressed
		elif color == RED:
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
func _on_RedTimer_timeout():
	turn_off()
