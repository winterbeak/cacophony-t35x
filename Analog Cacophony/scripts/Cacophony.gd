extends Node2D

signal win

const WIN_TIME = 30
onready var progress_bar = $ProgressBar
onready var win_timer = $WinTimer

var started: bool = false

func _ready():
	start()  # For now we just start when the program starts

func start():
	started = true
	win_timer.start(WIN_TIME)

func _on_Grid_fail():
	win_timer.start(WIN_TIME)

func _process(delta):
	if started:
		progress_bar.set_fraction(1 - win_timer.time_left/WIN_TIME)

func _on_WinTimer_timeout():
	emit_signal("win")
