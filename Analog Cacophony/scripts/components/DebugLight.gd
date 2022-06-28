extends Node2D

const ON_COLOR: Color = Color(1.0, 1.0, 0.0)
const OFF_COLOR: Color = Color(0.4, 0.4, 0.4)
const RED_COLOR: Color = Color(1.0, 0.0, 0.0)

const RED_TIME: float = 0.8

onready var color_rect: ColorRect = $ColorRect
onready var red_timer: Timer = $RedTimer

func _ready() -> void:
	turn_off()

func turn_on() -> void:
	color_rect.color = ON_COLOR

func turn_off() -> void:
	color_rect.color = OFF_COLOR

# Turns the light red for an amount of time determined by RED_TIME.
func turn_red() -> void:
	color_rect.color = RED_COLOR
	red_timer.start(RED_TIME)

# Called when the timer runs out.
func _on_RedTimer_timeout():
	turn_off()
