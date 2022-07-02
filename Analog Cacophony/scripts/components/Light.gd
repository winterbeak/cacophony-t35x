extends Node2D

const RED_TIME: float = 0.8

var tex_unpressed: Texture = preload("res://assets/images/button_unpressed.png")
var tex_pressed: Texture = preload("res://assets/images/button_pressed.png")

onready var red_timer: Timer = $RedTimer
onready var sprite: Sprite = $Sprite

func _ready() -> void:
	turn_off()

func turn_on() -> void:
	pass

func turn_off() -> void:
	pass

# Turns the light red for an amount of time determined by RED_TIME.
func turn_red() -> void:
	red_timer.start(RED_TIME)

func press() -> void:
	sprite.texture = tex_pressed

func release() -> void:
	sprite.texture = tex_unpressed

# Called when the timer runs out.
func _on_RedTimer_timeout():
	turn_off()
